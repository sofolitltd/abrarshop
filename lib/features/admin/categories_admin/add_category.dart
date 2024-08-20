import 'package:abrar_shop/features/home/controllers/category_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  //
  String _generateSlug(String name) {
    // Simple slug generation: lowercase, replace spaces with hyphens
    return name.toLowerCase().replaceAll(' ', '-');
  }

//
  void _addCategory() async {
    _isLoading = true;
    setState(() {});

    final categoryId = DateTime.now().microsecondsSinceEpoch.toString();
    final slug = _generateSlug(_nameController.text.trim());

    final category = CategoryModel(
      id: categoryId,
      name: _nameController.text.trim(),
      slug: slug,
      imageUrl: '', // Add your logic for image URL
      parentId: _selectedParent ?? '',
      isFeatured: _isFeatured,
    );

    try {
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
        child: ListView(
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
                              vertical: 14,
                              horizontal: 8), // Add horizontal padding
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

            //
            const SizedBox(height: 16),

            //
            ElevatedButton(
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
          ],
        ),
      ),
    );
  }
}
