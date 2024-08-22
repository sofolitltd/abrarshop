import 'dart:io';

import 'package:abrar_shop/features/home/controllers/category_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '/features/home/models/category_model.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final categoryController = Get.put(CategoryController());

  final TextEditingController _nameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _selectedParent;
  bool _isFeatured = false;

  bool _isLoading = false;

  File? _imageFile; // To store the selected image
  String? _imageUrl;

  //
  String _generateSlug(String name) {
    // Simple slug generation: lowercase, replace spaces with hyphens
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
                Navigator.pop(context); // Close the dialog
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
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog
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
  Future<void> _uploadImage(String categoryId) async {
    if (_imageFile == null) return; // No image selected

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('categories/$categoryId.jpg'); // Unique name for the image

    try {
      await storageRef.putFile(_imageFile!);
      _imageUrl = await storageRef.getDownloadURL();
      print('Image uploaded: $_imageUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

//
  void _addCategory() async {
    _isLoading = true;
    setState(() {});

    final categoryId = DateTime.now().microsecondsSinceEpoch.toString();
    final slug = _generateSlug(_nameController.text.trim());

    try {
      //
      await _uploadImage(categoryId);

      //
      final category = CategoryModel(
        id: categoryId,
        name: _nameController.text.trim(),
        slug: slug,
        imageUrl: _imageUrl ?? '',
        // Add your logic for image URL
        parentId: _selectedParent ?? '',
        isFeatured: _isFeatured,
        createdDate: Timestamp.now(),
      );

      //
      await _firestore
          .collection('categories')
          .doc(category.id)
          .set(category.toJson())
          .then((val) {
        // Get.snackbar('Success', 'Category added successfully');
        _isLoading = false;
        setState(() {});
        Navigator.pop(context);
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to add category: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    categoryController.fetchCategories();

    //
    return Scaffold(
      appBar: AppBar(title: const Text('Add Category')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            //
            Obx(() {
              List<CategoryModel> categories =
                  categoryController.allMainCategories;
              return ButtonTheme(
                alignedDropdown: true,
                child: Row(
                  // Wrap DropdownButton and IconButton in a Row
                  children: [
                    Expanded(
                      // Allow DropdownButton to take available space
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButton<String>(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 8),
                          // Add horizontal padding
                          isDense: true,
                          isExpanded: true,
                          value: _selectedParent,
                          hint: const Text('Parent Category'),
                          items: categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category.name,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            _selectedParent = value;
                            setState(() {});
                          },
                          underline: const SizedBox(),
                        ),
                      ),
                    ),
                    if (_selectedParent != null)
                      IconButton(
                        // Add clear icon button
                        onPressed: () {
                          _selectedParent = null; // Clear the selection
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear),
                      ),
                  ],
                ),
              );
            }),

            //
            const SizedBox(height: 16),

            // Image Display and Picker
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // if (_imageFile != null)
                //
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
                        : null,
                  ),
                  child: _imageFile != null
                      ? null
                      : const Icon(
                          Icons.image_outlined,
                          color: Colors.black38,
                          size: 32,
                        ),
                ),

                const SizedBox(width: 16),

                //
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Choose Image'),
                ),
              ],
            ),

            //
            const SizedBox(height: 16),

            // featured
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
                  'Featured Category',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),

            const SizedBox(height: 24),

            //
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _addCategory,
                child: _isLoading == true
                    ? const SizedBox(
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text('Add Category'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
