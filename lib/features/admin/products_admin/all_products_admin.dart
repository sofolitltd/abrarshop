import 'package:abrar_shop/features/admin/products_admin/add_products.dart';
import 'package:abrar_shop/features/admin/products_admin/edit_products.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../home/models/product_model.dart';

class AllProductsAdmin extends StatelessWidget {
  const AllProductsAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),

      //
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: () {
            Get.to(() => const AddProduct());
          },
          label: const Text('Add Product'),
          icon: const Icon(
            Iconsax.add_circle,
            size: 18,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('createdDate', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No data found'));
          }

          final docs = snapshot.data!.docs;
          return Scrollbar(
            scrollbarOrientation: ScrollbarOrientation.bottom,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  border: TableBorder.all(color: Colors.black12),
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    const TableRow(
                      decoration: BoxDecoration(
                        color: Colors.black12,
                      ),
                      children: [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),

                        //  category
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Category',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),

                        // stock
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Stock',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),

                        // price
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Price',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),

                        // featured
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Featured',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),

                        // actions
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Actions',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    for (var i = 0; i < docs.length; i++)
                      TableRow(
                        children: [
                          //name
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                docs[i]['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          // category
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                (docs[i]['category'] != '' ||
                                        (docs[i]['subCategory'] != '')
                                    ? '${docs[i]['category']}/${docs[i]['subCategory']}'
                                    : '-'),
                              ),
                            ),
                          ),

                          //stock
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                docs[i]['stock'].toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                          // price
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Text(docs[i]['salePrice'].toStringAsFixed(0)),
                            ),
                          ),

                          //featured
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: docs[i]['isFeatured'] != true
                                    ? const Icon(
                                        Icons.favorite_border,
                                        color: Colors.grey,
                                      )
                                    : const Icon(
                                        Icons.favorite,
                                        color: Colors.blueAccent,
                                      ),
                              ),
                            ),
                          ),

                          // action
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    style: IconButton.styleFrom(
                                      visualDensity: const VisualDensity(
                                        vertical: -3,
                                        horizontal: -3,
                                      ),
                                    ),
                                    onPressed: () {
                                      final product =
                                          ProductModel.fromQuerySnapshot(
                                              docs[i]);
                                      Get.to(
                                          () => EditProduct(product: product));
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  IconButton(
                                    style: IconButton.styleFrom(
                                      visualDensity: const VisualDensity(
                                        vertical: -3,
                                        horizontal: -3,
                                      ),
                                    ),
                                    onPressed: () {
                                      showDeleteConfirmationDialog(
                                          context, docs[i].id);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // delete dialog
  Future<void> showDeleteConfirmationDialog(
      BuildContext context, String productId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this category?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(productId)
                      .delete();
                  Get.snackbar(
                    'Success',
                    'Product deleted successfully',
                    colorText: Colors.white,
                    backgroundColor: Colors.green,
                  );
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Failed to delete category: $e',
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

//
// BRB Lovely Ceiling Fan 56"
// Al Nuaim Denim Black 6ML
// Al Rehab Silver 6ml
