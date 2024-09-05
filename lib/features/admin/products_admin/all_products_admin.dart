import 'package:abrar_shop/features/home/screens/products/products_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/features/admin/products_admin/add_products.dart';
import '/features/admin/products_admin/edit_products.dart';
import '../../../utils/custom_text.dart';
import '../../home/models/product_model.dart';

class AllProductsAdmin extends StatefulWidget {
  const AllProductsAdmin({super.key});

  @override
  State<AllProductsAdmin> createState() => _AllProductsAdminState();
}

class _AllProductsAdminState extends State<AllProductsAdmin> {
  bool _isList = true;

  @override
  Widget build(BuildContext context) {
    //
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

          //
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Text('Total Product: ${docs.length}'),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isList = true;
                        });
                      },
                      child: Icon(
                        Icons.list_alt,
                        color: _isList ? Colors.black : Colors.black26,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isList = false;
                        });
                      },
                      child: Icon(
                        Icons.grid_view,
                        color: _isList ? Colors.black26 : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              //
              if (_isList == true)
                Expanded(
                  child: Scrollbar(
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: docs.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        itemBuilder: (context, i) {
                          //
                          return Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // img
                                GestureDetector(
                                  onTap: () {
                                    ProductModel product =
                                        ProductModel.fromQuerySnapshot(docs[i]);
                                    //
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductsDetails(product: product),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12),
                                      color: Colors.blueAccent.shade100
                                          .withOpacity(.2),
                                      borderRadius: BorderRadius.circular(5),
                                      image: docs[i]['images'].isNotEmpty
                                          ? DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  docs[i]['images'][0]),
                                            )
                                          : null,
                                    ),
                                    // Assuming imageUrl is a valid image URL
                                  ),
                                ),

                                const SizedBox(width: 12),

                                //
                                Expanded(
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      //
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // name
                                          KText(
                                            docs[i]['name'],
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          //
                                          Row(
                                            children: [
                                              // category
                                              if (docs[i]['category'] != '')
                                                Text(
                                                    'Category: ${docs[i]['category']}'),
                                              const SizedBox(width: 4),

                                              // sub
                                              if (docs[i]['subCategory'] != '')
                                                Text(
                                                    '/ ${docs[i]['subCategory']}'),
                                            ],
                                          ),

                                          // brand
                                          if (docs[i]['brand'] != '')
                                            Text('Brand: ${docs[i]['brand']}'),

                                          // price
                                          Row(
                                            children: [
                                              Text(
                                                  'Price: ${docs[i]['regularPrice'].toStringAsFixed(0)}'),
                                              const SizedBox(width: 16),
                                              Text(
                                                  'Sale Price: ${docs[i]['salePrice'].toStringAsFixed(0)}'),
                                            ],
                                          ),

                                          //stock
                                          Text(
                                            'Stock: ${docs[i]['stock']}',
                                            style: const TextStyle(
                                                color: Colors.red),
                                          ),

                                          //featured
                                          Container(
                                            child: docs[i]['isFeatured'] != true
                                                ? const Text(
                                                    'Not Featured',
                                                  )
                                                : const Text(
                                                    'Featured',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                          ),

                                          const SizedBox(height: 8),
                                        ],
                                      ),

                                      // action
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          const Spacer(),
                                          //
                                          IconButton(
                                            style: IconButton.styleFrom(
                                              visualDensity:
                                                  const VisualDensity(
                                                vertical: -3,
                                                horizontal: -3,
                                              ),
                                            ),
                                            onPressed: () {
                                              final product = ProductModel
                                                  .fromQuerySnapshot(docs[i]);
                                              Get.to(() => EditProduct(
                                                  product: product));
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.grey,
                                            ),
                                          ),

                                          //
                                          IconButton(
                                            style: IconButton.styleFrom(
                                              visualDensity:
                                                  const VisualDensity(
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
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                )
              else
                Expanded(
                  child: Scrollbar(
                    scrollbarOrientation: ScrollbarOrientation.bottom,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Scrollbar(
                        scrollbarOrientation: ScrollbarOrientation.right,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Table(
                              border: TableBorder.all(color: Colors.black12),
                              defaultColumnWidth: const IntrinsicColumnWidth(),
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: [
                                const TableRow(
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                  ),
                                  children: [
                                    // no
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            'No',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),

                                    //
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            'Image',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // name
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            'Name',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // sub
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            'SubCategory',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),

                                    // brand
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            'Brand',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                //
                                for (var i = 0; i < docs.length; i++)
                                  TableRow(
                                    children: [
                                      //no
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Text(
                                            '${i + 1}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),

                                      // img
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black12),
                                              color: Colors.blueAccent.shade100
                                                  .withOpacity(.2),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              image: docs[i]['images']
                                                      .isNotEmpty
                                                  ? DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          docs[i]['images'][0]),
                                                    )
                                                  : null,
                                            ),
                                            // Assuming imageUrl is a valid image URL
                                          ),
                                        ),
                                      ),

                                      // name
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
                                              (docs[i]['category'] != '')
                                                  ? '${docs[i]['category']}'
                                                  : '-'),
                                        ),
                                      ),

                                      // sub
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              (docs[i]['subCategory'] != '')
                                                  ? '${docs[i]['subCategory']}'
                                                  : '--'),
                                        ),
                                      ),

                                      // brand
                                      TableCell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text((docs[i]['brand'] != '')
                                              ? '${docs[i]['brand']}'
                                              : '-'),
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
                                          child: Text(docs[i]['salePrice']
                                              .toStringAsFixed(0)),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                style: IconButton.styleFrom(
                                                  visualDensity:
                                                      const VisualDensity(
                                                    vertical: -3,
                                                    horizontal: -3,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  final product = ProductModel
                                                      .fromQuerySnapshot(
                                                          docs[i]);
                                                  Get.to(() => EditProduct(
                                                      product: product));
                                                },
                                                icon: const Icon(
                                                  Icons.edit,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              IconButton(
                                                style: IconButton.styleFrom(
                                                  visualDensity:
                                                      const VisualDensity(
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
                      ),
                    ),
                  ),
                ),
            ],
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
