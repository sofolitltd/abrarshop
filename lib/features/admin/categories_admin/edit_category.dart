import 'package:abrar_shop/features/home/controllers/category_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/features/home/models/category_model.dart';

class EditCategory extends StatefulWidget {
  final CategoryModel category;

  const EditCategory({super.key, required this.category});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final TextEditingController _nameController = TextEditingController();
  bool _isFeatured = false;
  bool _isLoading = false;
  String? _selectedParent;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final categoryController = Get.put(CategoryController());

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.category.name;
    if (widget.category.parentId.isNotEmpty) {
      _selectedParent = widget.category.parentId;
    }
    _isFeatured = widget.category.isFeatured;
  }

  String _generateSlug(String name) {
    return name.toLowerCase().replaceAll(' ', '-');
  }

  Future<void> _updateParentCategories(String oldName, String newName) async {
    final querySnapshot = await _firestore
        .collection('categories')
        .where('parentId', isEqualTo: oldName)
        .get();

    for (final doc in querySnapshot.docs) {
      await doc.reference.update({'parentId': newName});
    }
  }

  void _updateCategory() async {
    _isLoading = true;
    setState(() {});

    final oldName = widget.category.name;
    final newName = _nameController.text.trim();
    final slug = _generateSlug(newName);

    final updatedCategory = CategoryModel(
      id: widget.category.id,
      name: newName,
      slug: slug,
      imageUrl: '',
      parentId: _selectedParent ?? '',
      isFeatured: _isFeatured,
    );

    try {
      await _firestore
          .collection('categories')
          .doc(widget.category.id)
          .update(updatedCategory.toJson())
          .then((val) async {
        if (oldName != newName) {
          await _updateParentCategories(oldName, newName);
        }
        _isLoading = false;
        setState(() {});
        Navigator.pop(context);
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to update category: $e');
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
        child: ListView(
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
              List<CategoryModel> categories =
                  categoryController.allMainCategories;
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
            const SizedBox(height: 16),
            ElevatedButton(
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
          ],
        ),
      ),
    );
  }
}
