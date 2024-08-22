import 'dart:io';

import 'package:abrar_shop/features/home/controllers/brand_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../home/controllers/category_controller.dart';
import '../../home/models/product_model.dart';

class EditProduct extends StatefulWidget {
  final ProductModel product;

  const EditProduct({super.key, required this.product});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _regularPriceController = TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _stockPriceController = TextEditingController();
  String? _selectedCategory;
  String? _selectedSubCategory;
  String? _selectedBrand;
  bool _isFeatured = false;
  bool isLoading = false;

  List<File> _imageFiles = [];
  List<String> _imageUrls = [];

  final categoryController = Get.put(CategoryController());
  final brandController = Get.put(BrandController());

  @override
  void initState() {
    super.initState();

    // Initialize the form fields with the product data
    _nameController.text = widget.product.name;
    _descriptionController.text = widget.product.description;
    _regularPriceController.text =
        widget.product.regularPrice.toStringAsFixed(0);
    _salePriceController.text = widget.product.salePrice.toStringAsFixed(0);
    _stockPriceController.text = widget.product.stock.toStringAsFixed(0);

    // _selectedBrand = widget.product.brand;
    _isFeatured = widget.product.isFeatured;
    if (widget.product.category != '') {}
    _selectedCategory = widget.product.category;

    if (widget.product.subCategory != '') {
      _selectedSubCategory = widget.product.subCategory;
    }

    if (widget.product.brand != '') {
      _selectedBrand = widget.product.brand;
    }
    _imageUrls = widget.product.images;
  }

  // pic image
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
                final pickedFiles = await picker.pickMultiImage(
                  // imageQuality: 50,
                  maxWidth: 500,
                  maxHeight: 500,
                );
                if (pickedFiles != null) {
                  setState(() {
                    _imageFiles = pickedFiles.map((x) => File(x.path)).toList();
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
                    _imageFiles.add(File(pickedFile.path));
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

  // upload image
  Future<void> _uploadImages(String productId) async {
    _imageUrls.clear();
    for (int i = 0; i < _imageFiles.length; i++) {
      final storageRef =
          FirebaseStorage.instance.ref().child('products/$productId-$i.jpg');

      try {
        await storageRef.putFile(_imageFiles[i]);

        String downloadUrl = await storageRef.getDownloadURL();
        _imageUrls.add(downloadUrl);
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  //
  Future<void> _deletePreviousImages() async {
    for (String imageUrl in widget.product.images) {
      try {
        Reference imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
        await imageRef.delete();
        print('Deleted image: $imageUrl');
      } catch (e) {
        print('Error deleting image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    categoryController.fetchCategories();
    brandController.fetchBrands();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 10,
                    ),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Product Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 10),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),

                // Prices and Stock
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Regular Price
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _regularPriceController,
                        decoration: InputDecoration(
                          labelText: 'Regular Price',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the regular price';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Sale Price
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _salePriceController,
                        decoration: InputDecoration(
                          labelText: 'Sale Price',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 10),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the sale price';
                          }
                          double regularPrice =
                              double.parse(_regularPriceController.text);
                          double salePrice = double.parse(value);
                          if (regularPrice < salePrice) {
                            return 'Regular price less than sale price';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Stock
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _stockPriceController,
                        decoration: InputDecoration(
                          labelText: 'Stock',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 10,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the stock';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Category and Subcategory Dropdowns
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                              ),
                              isDense: true,
                              isExpanded: true,
                              value: _selectedCategory,
                              hint: const Text('Parent Category'),
                              items: categoryController.allMainCategories
                                  .map((category) {
                                return DropdownMenuItem<String>(
                                  value: category.name,
                                  child: Text(category.name),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                _selectedCategory = value!;
                                _selectedSubCategory = null;
                                setState(() {});
                              },
                              underline: const SizedBox(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (_selectedCategory != null)
                        IconButton(
                          onPressed: () {
                            _selectedCategory = null;
                            _selectedSubCategory = null;
                            setState(() {});
                          },
                          icon: const Icon(Icons.clear),
                        ),
                    ],
                  ),
                ),

                // sub
                if (_selectedCategory != null) ...[
                  const SizedBox(height: 16),
                  Obx(
                    () {
                      if (_selectedCategory != null) {
                        categoryController
                            .fetchSubCategories(_selectedCategory!);
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  isDense: true,
                                  isExpanded: true,
                                  value: _selectedSubCategory,
                                  hint: const Text('Sub Category'),
                                  items: categoryController.subCategories
                                      .map((subCategory) {
                                    return DropdownMenuItem<String>(
                                      value: subCategory.name,
                                      child: Text(subCategory.name),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedSubCategory = value!;
                                    });
                                  },
                                  underline: const SizedBox(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          if (_selectedSubCategory != null)
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedSubCategory = null;
                                });
                              },
                              icon: const Icon(Icons.clear),
                            ),
                        ],
                      );
                    },
                  ),
                ],

                // brand
                ...[
                  const SizedBox(height: 16),
                  Obx(
                    () {
                      //
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  // Add horizontal padding
                                  isDense: true,
                                  isExpanded: true,
                                  value: _selectedBrand,
                                  hint: const Text('Brand'),
                                  items: brandController.allBrands.map((brand) {
                                    return DropdownMenuItem<String>(
                                      value: brand.name,
                                      // Use the category ID for value
                                      child: Text(brand.name),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    _selectedBrand = value;
                                    setState(() {});
                                  },
                                  underline: const SizedBox(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (_selectedBrand != null)
                            IconButton(
                              // Add clear icon button
                              onPressed: () {
                                _selectedBrand = null; // Clear the selection
                                setState(() {});
                              },
                              icon: const Icon(Icons.clear),
                            ),
                        ],
                      );
                    },
                  ),
                ],

                const SizedBox(height: 16),

                // Images
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (_imageFiles.isNotEmpty)
                        Row(
                          children: _imageFiles.map((imageFile) {
                            return Container(
                              height: 80,
                              width: 80,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black12),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(imageFile),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      else
                        Row(
                          children: widget.product.images.map((image) {
                            return Container(
                              height: 80,
                              width: 80,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black12),
                                image: widget.product.images.isNotEmpty
                                    ? DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(image),
                                      )
                                    : null,
                              ),
                            );
                          }).toList(),
                        ),

                      //
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 32,
                            )),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Is Featured Checkbox
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
                    const Text('Featured Product'),
                  ],
                ),

                const SizedBox(height: 16),

                // Submit Button
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              // Upload images if any new images were selected
                              if (_imageFiles.isNotEmpty) {
                                // delete old images
                                await _deletePreviousImages();

                                // add new images
                                await _uploadImages(widget.product.id);
                              }

                              // Update product data in Firestore
                              FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(widget.product.id)
                                  .update({
                                'name': _nameController.text,
                                'description': _descriptionController.text,
                                'regularPrice':
                                    double.parse(_regularPriceController.text),
                                'salePrice':
                                    double.parse(_salePriceController.text),
                                'stock': int.parse(_stockPriceController.text),
                                'category': _selectedCategory ?? '',
                                'subCategory': _selectedSubCategory ?? '',
                                'brand': _selectedBrand ?? '',
                                'isFeatured': _isFeatured,
                                'images': _imageUrls,
                              });

                              Get.snackbar(
                                'Success',
                                'Product updated successfully',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                              Navigator.pop(context);
                            } catch (e) {
                              Get.snackbar(
                                'Error',
                                'Failed to update product: $e',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Update Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
