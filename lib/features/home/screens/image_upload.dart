import 'dart:io';
import 'dart:typed_data'; // For handling image bytes

import 'package:abrar_shop/features/home/screens/edit_image_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb; // Check if the platform is web
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For showing toast notifications
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image/image.dart'
    as img; // Add this import for image compression
import 'package:image_picker/image_picker.dart';
import 'package:reorderables/reorderables.dart'; // Import the reorderables package

class ImageRow extends StatefulWidget {
  @override
  _ImageRowState createState() => _ImageRowState();
}

class _ImageRowState extends State<ImageRow> {
  List<dynamic> _images = []; // Store XFile or Uint8List (for web)
  List<String> _uploadedImageUrls = [];
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _isLoading = false; // Loading indicator state

  Future<Uint8List> compressImage(File imageFile) async {
    // Read the image file as bytes
    Uint8List imageBytes = await imageFile.readAsBytes();

    // Check the size of the image before compressing
    if (imageBytes.length <= 150 * 1024) {
      return imageBytes; // Return the original image if it's already under 150 KB
    }

    // Decode image from bytes
    img.Image? image = img.decodeImage(imageBytes);

    if (image != null) {
      int quality = 100; // Start with high quality
      Uint8List compressedBytes;
      List<int> jpegBytes;

      // Keep compressing until the image size is <= 150 KB
      do {
        jpegBytes = img.encodeJpg(image, quality: quality);
        compressedBytes = Uint8List.fromList(jpegBytes);
        quality -= 10; // Decrease quality for more compression
      } while (compressedBytes.length > 150 * 1024 && quality > 0);

      return compressedBytes;
    }

    // Return the original image if compression is not possible
    return imageBytes;
  }

  Future<void> _pickImages(ImageSource source) async {
    if (kIsWeb) {
      // Web multiple image picker using ImagePicker
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null) {
        for (var file in pickedFiles) {
          Uint8List bytes = await file.readAsBytes(); // Get image bytes
          setState(() {
            _images.add(bytes);
          });
        }
      }
    } else {
      if (source == ImageSource.gallery) {
        // Mobile multiple image picker
        final pickedFiles = await _picker.pickMultiImage();
        if (pickedFiles != null) {
          for (var file in pickedFiles) {
            File imageFile = File(file.path);
            setState(() {
              _images.add(imageFile); // Add file directly
            });
          }
        }
      } else {
        // Camera (for mobile only)
        final pickedFile = await _picker.pickImage(source: source);
        if (pickedFile != null) {
          File imageFile = File(pickedFile.path);
          setState(() {
            _images.add(imageFile); // Add file directly
          });
        }
      }
    }
  }

  Future<void> _compressAndUploadImages() async {
    setState(() {
      _isLoading = true; // Start loading indicator
    });

    try {
      print('Image Index | Image Name | Original Size | Compressed Size');
      print('-------------------------------------------------------------');

      for (int i = 0; i < _images.length; i++) {
        var image = _images[i];
        Uint8List compressedBytes;
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef = _storage.ref().child('uploads/$fileName.jpeg');

        if (image is File) {
          // Mobile
          File imageFile = image;
          int originalSize = await imageFile.length() ~/ 1024; // Size in KB
          compressedBytes = await compressImage(imageFile);
          int compressedSize = compressedBytes.length ~/ 1024; // Size in KB

          // Print original and compressed size
          print('$i | $fileName | ${originalSize}KB | ${compressedSize}KB');

          // Save compressed image to a temporary file
          File tempFile = File('${Directory.systemTemp.path}/$fileName.jpeg');
          await tempFile.writeAsBytes(compressedBytes);

          // Upload the compressed file
          UploadTask uploadTask = storageRef.putFile(tempFile);
          await uploadTask;
        } else if (image is Uint8List) {
          // Web
          int originalSize = image.length ~/ 1024; // Size in KB
          compressedBytes = await compressImageFromBytes(image);
          int compressedSize = compressedBytes.length ~/ 1024; // Size in KB

          // Print original and compressed size
          print('$i | $fileName | ${originalSize}KB | ${compressedSize}KB');

          // Upload the compressed bytes
          UploadTask uploadTask = storageRef.putData(
              compressedBytes, SettableMetadata(contentType: 'image/jpeg'));
          await uploadTask;
        } else {
          continue; // Skip unsupported image types
        }

        // Get and save image URL
        String imageUrl = await storageRef.getDownloadURL();
        _uploadedImageUrls.add(imageUrl);
        setState(() {});
      }

      //
      await FirebaseFirestore.instance
          .collection('uploads')
          .doc()
          .set({'images': _uploadedImageUrls});

      //
      _showToast(
          'Upload successful!'); // Show toast notification only once after all uploads
    } catch (e) {
      print('Error uploading image: $e');
      _showToast('Error uploading image');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading indicator
      });
    }
  }

// Function to compress image from bytes (for web)
  Future<Uint8List> compressImageFromBytes(Uint8List imageBytes) async {
    img.Image? image = img.decodeImage(imageBytes);

    if (image != null) {
      int quality = 100; // Start with high quality
      Uint8List compressedBytes;

      // Keep compressing until the image size is <= 150 KB
      do {
        List<int> jpegBytes = img.encodeJpg(image, quality: quality);
        compressedBytes = Uint8List.fromList(jpegBytes);
        quality -= 10; // Decrease quality for more compression
      } while (compressedBytes.length > 150 * 1024 && quality > 0);

      return compressedBytes;
    }
    return imageBytes; // Return the original if compression is not possible
  }

  //
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'Select Image Source',
              style: TextStyle(fontSize: 18),
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImages(ImageSource.camera);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Iconsax.camera,
                        size: 40,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Camera'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImages(ImageSource.gallery);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Iconsax.gallery,
                        size: 40,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Gallery'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
        actions: [
          IconButton.filledTonal(
            onPressed: () {
              Get.to(
                () => EditImagePage(),
                transition: Transition.rightToLeft,
              );
            },
            icon: const Icon(
              Iconsax.image,
              size: 22,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isLoading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // "+" icon to add images
                GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        size: 50,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ReorderableWrap(
                    scrollDirection: Axis.horizontal,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        final image = _images.removeAt(oldIndex);
                        _images.insert(newIndex, image);
                      });
                    },
                    children: _images.asMap().entries.map((entry) {
                      int index = entry.key;
                      var image = entry.value;
                      return Container(
                        key: ValueKey(index),
                        width: 100,
                        height: 100,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: kIsWeb
                                    ? Image.memory(
                                        image,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File((image).path),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () => _removeImage(index),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _images.isNotEmpty ? _compressAndUploadImages : null,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Upload'),
            ),
          ),
        ],
      ),
    );
  }
}
