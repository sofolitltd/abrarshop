import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/features/home/controllers/category_controller.dart';
import 'featured_category_details.dart';

class AllCategories extends StatelessWidget {
  const AllCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    categoryController.assignFirstSubcategory();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Row(
        children: [
          Container(
            color: Colors.black12.withOpacity(.05),
            padding: const EdgeInsets.symmetric(vertical: 8),
            width: 110,
            child: Obx(
              () => ListView.builder(
                itemCount: categoryController.allMainCategories.length,
                itemBuilder: (_, index) {
                  final category = categoryController.allMainCategories[index];

                  //
                  return InkWell(
                    onTap: () {
                      categoryController.selectedCategory.value = category.id;
                      categoryController.fetchSubCategories(category.id);
                    },
                    child: Obx(
                      // Wrap with Obx to rebuild when selectedCategory changes
                      () => Container(
                        color: categoryController.selectedCategory.value ==
                                category.id
                            ? Colors.black12
                            : Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        child: Text(category.name),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          //
          Expanded(
            child: Obx(
              () => categoryController.subCategories.isEmpty
                  ? const Center(child: Text('No data found'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: categoryController.subCategories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: .7,
                      ),
                      itemBuilder: (_, index) {
                        //
                        final subCategory =
                            categoryController.subCategories[index];

                        //
                        return GestureDetector(
                          onTap: () {
                            // featured category details
                            Get.to(
                              () => FeaturedCategoryDetails(
                                category: subCategory,
                                isSubCategory: true,
                              ),
                              transition: Transition.noTransition,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black12),
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                // image
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: .5,
                                      ),
                                      color: Colors.blueAccent.shade100
                                          .withOpacity(.5),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image:
                                            NetworkImage(subCategory.imageUrl),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // name
                                SizedBox(
                                  // width: 72,
                                  height: 32,
                                  child: Center(
                                    child: Text(
                                      subCategory.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            height: 1.2,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
