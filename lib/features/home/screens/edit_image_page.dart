import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reorderables/reorderables.dart';

class EditImagePage extends StatefulWidget {
  @override
  _EditImagePageState createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  List<dynamic> _images = []; // Store XFile or Uint8List (for web)
  List<String> _uploadedImageUrls = [];

  final List<dynamic> _newImages = []; // New images to be uploaded
  final List<String> _deletedImageUrls = []; // Track deleted image URLs

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchImages();
  }

  Future<void> _fetchImages() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Fetch image URLs from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('uploads')
          .doc('Q4m6u7Tb9G3Y8zoBPPrG')
          .get();

      List<dynamic> imageUrls = snapshot['images'] ?? [];
      List<dynamic> fetchedImages = [];

      for (var url in imageUrls) {
        if (kIsWeb) {
          // Handle web as Uint8List
          http.Response response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            Uint8List imageBytes = response.bodyBytes;
            fetchedImages.add(imageBytes);
          }
        } else {
          // Handle mobile as File
          final Directory tempDir = await getTemporaryDirectory();
          final File file = File(
              '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
          http.Response response = await http.get(Uri.parse(url));
          if (response.statusCode == 200) {
            await file.writeAsBytes(response.bodyBytes);
            fetchedImages.add(file);
          }
        }
      }

      setState(() {
        _uploadedImageUrls = List<String>.from(imageUrls);
        _images = fetchedImages;
      });
    } catch (e) {
      print('Error fetching images: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImages(ImageSource source) async {
    if (kIsWeb) {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles != null) {
        for (var file in pickedFiles) {
          Uint8List bytes = await file.readAsBytes();
          setState(() {
            _newImages.add(bytes); // New images are added here
            _images.add(bytes);
          });
        }
      }
    } else {
      if (source == ImageSource.gallery) {
        final pickedFiles = await _picker.pickMultiImage();
        if (pickedFiles != null) {
          for (var file in pickedFiles) {
            File imageFile = File(file.path);
            setState(() {
              _newImages.add(imageFile); // New images are added here
              _images.add(imageFile);
            });
          }
        }
      } else {
        final pickedFile = await _picker.pickImage(source: source);
        if (pickedFile != null) {
          File imageFile = File(pickedFile.path);
          setState(() {
            _newImages.add(imageFile); // New images are added here
            _images.add(imageFile);
          });
        }
      }
    }
  }

  Future<void> _compressAndUploadImages() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<String> newImageUrls = [];

      // 1. Delete old images removed from the UI
      for (String oldImageUrl in _deletedImageUrls) {
        try {
          Reference oldStorageRef = _storage.refFromURL(oldImageUrl);
          await oldStorageRef.delete();
          print('Deleted old image: $oldImageUrl');
        } catch (e) {
          print('Error deleting old image: $e');
        }
      }

      // 2. Compress and upload only new images
      for (var image in _newImages) {
        Uint8List compressedBytes;
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef = _storage.ref().child('uploads/$fileName.jpeg');

        if (image is File) {
          compressedBytes = await compressImage(image);
          File tempFile = File('${Directory.systemTemp.path}/$fileName.jpeg');
          await tempFile.writeAsBytes(compressedBytes);
          UploadTask uploadTask = storageRef.putFile(tempFile);
          await uploadTask;
        } else if (image is Uint8List) {
          compressedBytes = await compressImageFromBytes(image);
          UploadTask uploadTask = storageRef.putData(
              compressedBytes, SettableMetadata(contentType: 'image/jpeg'));
          await uploadTask;
        }

        String imageUrl = await storageRef.getDownloadURL();
        newImageUrls.add(imageUrl);
      }

      // 3. Update Firestore with the reordered and new image URLs
      _uploadedImageUrls.addAll(newImageUrls);
      await FirebaseFirestore.instance
          .collection('uploads')
          .doc('Q4m6u7Tb9G3Y8zoBPPrG')
          .update({'images': _uploadedImageUrls});

      _showToast('Upload successful!');
    } catch (e) {
      print('Error uploading image: $e');
      _showToast('Error uploading image');
    } finally {
      setState(() {
        _isLoading = false;
        _newImages.clear(); // Clear new images after upload
        _deletedImageUrls.clear(); // Clear deleted image URLs after removal
      });
    }
  }

  void _removeImage(int index) {
    if (index < _uploadedImageUrls.length) {
      // Image exists in Firestore, mark it for deletion
      _deletedImageUrls.add(_uploadedImageUrls[index]);
      _uploadedImageUrls.removeAt(index);
    }
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _updateReorderedImages() async {
    try {
      await FirebaseFirestore.instance
          .collection('uploads')
          .doc('Q4m6u7Tb9G3Y8zoBPPrG')
          .update({'images': _uploadedImageUrls});

      _showToast('Image order updated successfully!');
    } catch (e) {
      print('Error updating image order: $e');
      _showToast('Error updating image order');
    }
  }

  Future<Uint8List> compressImage(File imageFile) async {
    Uint8List imageBytes = await imageFile.readAsBytes();

    if (imageBytes.length <= 150 * 1024) {
      return imageBytes;
    }

    img.Image? image = img.decodeImage(imageBytes);

    if (image != null) {
      int quality = 100;
      Uint8List compressedBytes;
      List<int> jpegBytes;

      do {
        jpegBytes = img.encodeJpg(image, quality: quality);
        compressedBytes = Uint8List.fromList(jpegBytes);
        quality -= 10;
      } while (compressedBytes.length > 150 * 1024 && quality > 0);

      return compressedBytes;
    }

    return imageBytes;
  }

  Future<Uint8List> compressImageFromBytes(Uint8List imageBytes) async {
    img.Image? image = img.decodeImage(imageBytes);

    if (image != null) {
      int quality = 100;
      Uint8List compressedBytes;

      do {
        List<int> jpegBytes = img.encodeJpg(image, quality: quality);
        compressedBytes = Uint8List.fromList(jpegBytes);
        quality -= 10;
      } while (compressedBytes.length > 150 * 1024 && quality > 0);

      return compressedBytes;
    }

    return imageBytes;
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          actions: [
            TextButton(
              child: const Text('Camera'),
              onPressed: () {
                Navigator.of(context).pop();
                _pickImages(ImageSource.camera);
              },
            ),
            TextButton(
              child: const Text('Gallery'),
              onPressed: () {
                Navigator.of(context).pop();
                _pickImages(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
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
        title: const Text('Edit Images'),
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

                        // Update Firestore with new order
                        final imageUrl = _uploadedImageUrls.removeAt(oldIndex);
                        _uploadedImageUrls.insert(newIndex, imageUrl);
                      });

                      _updateReorderedImages(); // Save new order to Firestore
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
                                        image
                                            as Uint8List, // Handle web as Uint8List
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        image as File, // Handle mobile as File
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: IconButton(
                                icon: const Icon(Icons.delete),
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
          const SizedBox(height: 8),

          //
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _compressAndUploadImages,
              child: const Text('Upload Images'),
            ),
          ),
        ],
      ),
    );
  }
}
