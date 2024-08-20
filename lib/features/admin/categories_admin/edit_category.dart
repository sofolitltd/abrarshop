import 'dart:io';

import 'package:abrar_shop/features/home/controllers/category_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '/features/home/models/category_model.dart';

class EditCategory extends StatefulWidget {
  final CategoryModel category;

  const EditCategory({super.key, required this.category});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final categoryController = Get.put(CategoryController());

  final TextEditingController _nameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _selectedParent;
  bool _isFeatured = false;
  bool _isLoading = false;

  File? _imageFile;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.category.name;
    _selectedParent = widget.category.parentId;
    _isFeatured = widget.category.isFeatured;
    _imageUrl = widget.category.imageUrl;
  }

  String _generateSlug(String name) {
    return name.toLowerCase().replaceAll(' ', '-');
  }

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
                final picker = ImagePicker();
                final pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 40,
                  maxWidth: 500,
                  maxHeight: 500,
                );
                if (pickedFile != null) {
                  setState(() {
                    _imageFile = File(pickedFile.path);
                  });
                }
              },
              child: const Text('Gallery'),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                final picker = ImagePicker();
                final pickedFile = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 40,
                  maxWidth: 500,
                  maxHeight: 500,
                );
                if (pickedFile != null) {
                  setState(() {
                    _imageFile = File(pickedFile.path);
                  });
                }
              },
              child: const Text('Camera'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadImage(String categoryId) async {
    if (_imageFile == null) return;

    final storageRef =
        FirebaseStorage.instance.ref().child('categories/$categoryId.jpg');

    try {
      await storageRef.putFile(_imageFile!);

      _imageUrl = await storageRef.getDownloadURL();
      print('Image uploaded: $_imageUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  //
  Future<void> _deletePreviousImage() async {
    if (widget.category.imageUrl.isNotEmpty && _imageFile != null) {
      try {
        Reference imageRef =
            FirebaseStorage.instance.refFromURL(widget.category.imageUrl);
        await imageRef.delete();
        print('Deleted previous image: ${widget.category.imageUrl}');
      } catch (e) {
        print('Error deleting previous image: $e');
      }
    }
  }

  //
  void _updateCategory() async {
    _isLoading = true;
    setState(() {});

    final slug = _generateSlug(_nameController.text.trim());

    try {
      if (_imageFile != null) {
        //
        await _deletePreviousImage(); // Delete previous image if a new one is selected

        //
        await _uploadImage(widget.category.id);
      }

      final updatedCategory = CategoryModel(
        id: widget.category.id,
        name: _nameController.text.trim(),
        slug: slug,
        imageUrl: _imageUrl ?? widget.category.imageUrl,
        parentId: _selectedParent ?? '',
        isFeatured: _isFeatured,
        createdDate: Timestamp.now(),
      );

      //
      await _firestore
          .collection('categories')
          .doc(updatedCategory.id)
          .update(updatedCategory.toJson())
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
      appBar: AppBar(title: const Text('Edit Category')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              List<CategoryModel> categories = categoryController
                  .allMainCategories
                  .where((cat) => cat.id != widget.category.id)
                  .toList();
              return ButtonTheme(
                alignedDropdown: true,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black54),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButton<String>(
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 8),
                          isDense: true,
                          isExpanded: true,
                          value: _selectedParent,
                          hint: const Text('Parent Category'),
                          items: [
                            const DropdownMenuItem<String>(
                              value: '',
                              child: Text(''),
                            ),
                            ...categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category.name,
                                child: Text(category.name),
                              );
                            }).toList(),
                          ],
                          onChanged: (String? value) {
                            _selectedParent = value;
                            setState(() {});
                          },
                          underline: const SizedBox(),
                        ),
                      ),
                    ),
                    if (_selectedParent != null && _selectedParent!.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          _selectedParent = null;
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear),
                      ),
                  ],
                ),
              );
            }),
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
                        : _imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(_imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                  ),
                  child: _imageFile != null || _imageUrl != null
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
                  'Featured Category',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateCategory,
                child: _isLoading
                    ? const SizedBox(
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text('Update Category'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
