import 'dart:io';

import 'package:abrar_shop/features/home/models/brand_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '/features/home/controllers/category_controller.dart';

class EditBrand extends StatefulWidget {
  final BrandModel brand;

  const EditBrand({super.key, required this.brand});

  @override
  State<EditBrand> createState() => _EditBrandState();
}

class _EditBrandState extends State<EditBrand> {
  final categoryController = Get.put(CategoryController());

  final TextEditingController _nameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isFeatured = false;
  bool _isLoading = false;

  File? _imageFile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.brand.name;

    _isFeatured = widget.brand.isFeatured;
    _imageUrl = widget.brand.imageUrl;
  }

  String _generateSlug(String name) {
    return name.toLowerCase().replaceAll(' ', '-');
  }

  //
  Future<void> _pickImage() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Choose Image Source'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);

                //
                final picker = ImagePicker();
                final pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                  // imageQuality: 50,
                  maxWidth: 500,
                  maxHeight: 500,
                );
                if (pickedFile != null) {
                  setState(() {
                    _imageFile = File(pickedFile.path);
                  });
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Gallery'),
              ),
            ),

            //
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                final picker = ImagePicker();
                final pickedFile = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                  maxWidth: 500,
                  maxHeight: 500,
                );
                if (pickedFile != null) {
                  setState(() {
                    _imageFile = File(pickedFile.path);
                  });
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Camera'),
              ),
            ),
          ],
        );
      },
    );
  }

  //
  Future<void> _uploadImage(String brandId) async {
    if (_imageFile == null) return;

    final storageRef =
        FirebaseStorage.instance.ref().child('brands/$brandId.jpg');

    try {
      if (kIsWeb) {
        // For web, use putData instead of putFile
        final bytes = await _imageFile!.readAsBytes();
        await storageRef.putData(bytes);
      } else {
        // For mobile, continue using putFile
        await storageRef.putFile(_imageFile!);
      }

      _imageUrl = await storageRef.getDownloadURL();
      print('Image uploaded: $_imageUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  //
  Future<void> _deletePreviousImage() async {
    if (widget.brand.imageUrl.isNotEmpty && _imageFile != null) {
      try {
        Reference imageRef =
            FirebaseStorage.instance.refFromURL(widget.brand.imageUrl);
        await imageRef.delete();
        print('Deleted previous image: ${widget.brand.imageUrl}');
      } catch (e) {
        print('Error deleting previous image: $e');
      }
    }
  }

  //
  void _updateBrand() async {
    _isLoading = true;
    setState(() {});

    final slug = _generateSlug(_nameController.text.trim());

    try {
      if (_imageFile != null) {
        await _deletePreviousImage();
        await _uploadImage(widget.brand.id);
      }

      final brandCategory = BrandModel(
        id: widget.brand.id,
        name: _nameController.text.trim(),
        slug: slug,
        imageUrl: _imageUrl ?? widget.brand.imageUrl,
        isFeatured: _isFeatured,
        createdDate: Timestamp.now(),
      );

      // Update products and subcategories first
      if (_nameController.text != widget.brand.name) {
        QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
            .collection('products')
            .where('brand', isEqualTo: widget.brand.name)
            .get();

        for (var doc in productsSnapshot.docs) {
          await doc.reference.update({
            'brand': _nameController.text,
          });
        }
      }

      // Now update the category itself
      await _firestore
          .collection('brands')
          .doc(brandCategory.id)
          .update(brandCategory.toJson())
          .then((val) {
        _isLoading = false;
        setState(() {});
        Navigator.pop(context);
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to update category: $e');
    } finally {
      _isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    categoryController.fetchCategories();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Brand')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Brand Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(8),
                    image: _imageFile != null
                        ? DecorationImage(
                            image: FileImage(_imageFile!),
                            fit: BoxFit.cover,
                          )
                        : _imageUrl!.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(_imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                  ),
                  child: _imageFile != null || _imageUrl!.isNotEmpty
                      ? null
                      : const Icon(
                          Icons.image_outlined,
                          color: Colors.black38,
                          size: 32,
                        ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Choose Image'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isFeatured,
                  onChanged: (bool? value) {
                    setState(() {
                      _isFeatured = value ?? false;
                    });
                  },
                ),
                Text(
                  'Featured Brand',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateBrand,
                child: _isLoading
                    ? const SizedBox(
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text('Update Brand'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
