import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/features/admin/categories_admin/add_category.dart';
import '/features/admin/categories_admin/edit_category.dart';
import '/features/home/models/category_model.dart';

class AllCategoriesAdmin extends StatelessWidget {
  const AllCategoriesAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),

      //
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: () {
            Get.to(() => const AddCategory());
          },
          label: const Text('Add Category'),
          icon: const Icon(
            Iconsax.add_circle,
            size: 18,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('categories')
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
                        //
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Image',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        //name

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

                        // parent category
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Parent Category',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),

                        // slug
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Slug',
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

                    //
                    for (var i = 0; i < docs.length; i++)
                      TableRow(
                        children: [
                          //image
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  color: Colors.blueAccent.shade100
                                      .withOpacity(.2),
                                  borderRadius: BorderRadius.circular(5),
                                  image: docs[i]['imageUrl'].isNotEmpty
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          image:
                                              NetworkImage(docs[i]['imageUrl']),
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

                          // parent
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(docs[i]['parentId'] ?? ''),
                            ),
                          ),

                          //slug
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(docs[i]['slug']),
                            ),
                          ),

                          // featured
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
                                      final category =
                                          CategoryModel.fromQuerySnapshot(
                                              docs[i]);
                                      Get.to(() =>
                                          EditCategory(category: category));
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
      BuildContext context, String categoryId) async {
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
                      .collection('categories')
                      .doc(categoryId)
                      .delete();
                  Get.snackbar(
                    'Success',
                    'Category deleted successfully',
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
