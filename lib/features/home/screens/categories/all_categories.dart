import 'package:abrar_shop/features/home/controllers/category_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllCategories extends StatelessWidget {
  const AllCategories({super.key});

  @override
  Widget build(BuildContext context) {
    //
    final categoryController = Get.put(CategoryController());

    //
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),

      //
      body: Row(
        children: [
          //
          Container(
            color: Colors.black12.withOpacity(.05),
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: 130,
            child: Obx(
              () => ListView.builder(
                itemCount: categoryController.allCategories.length,
                itemBuilder: (_, index) {
                  final category = categoryController.allCategories[index];
                  categoryController.selectedCategory.value = category.id;

                  //
                  return InkWell(
                    //
                    onTap: () {
                      categoryController.selectedCategory.value = category.id;
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      child: Text(category.name),
                    ),
                  );
                },
              ),
            ),
          ),

          //
          Expanded(
            child: FutureBuilder(
                future: categoryController.fetchCategoriesByQuery(
                    FirebaseFirestore.instance.collection('categories').where(
                        'parentId',
                        isEqualTo: categoryController.selectedCategory.value)),
                builder: (context, snapShot) {
                  if (snapShot.hasData) return const Text('No data found!');
                  if (snapShot.connectionState == ConnectionState.waiting)
                    return const Text('Loading...');
                  //
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: 3,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (_, index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(),
                            const SizedBox(height: 4),
                            //
                            Text(
                                '${categoryController.selectedCategory.value} '),
                          ],
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
