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
          // category
          Container(
            color: Colors.black12.withOpacity(.05),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 8,
            ),
            width: 120,
            child: Obx(
              () => ListView.builder(
                itemCount: categoryController.allMainCategories.length,
                itemBuilder: (_, index) {
                  final category = categoryController.allMainCategories[index];

                  //
                  return InkWell(
                    onTap: () {
                      categoryController.selectedCategory.value = category.name;
                      categoryController.fetchSubCategories(category.name);
                    },
                    child: Obx(
                      // Wrap with Obx to rebuild when selectedCategory changes
                      () => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: categoryController.selectedCategory.value ==
                                  category.name
                              ? Colors.blueAccent
                              : Colors.transparent,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        child: Text(
                          category.name,
                          style: TextStyle(
                            color: categoryController.selectedCategory.value ==
                                    category.name
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // sub category
          Expanded(
            child: Obx(
              () => categoryController.subCategories.isEmpty
                  ? const Center(child: Text('No data found'))
                  : GridView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: categoryController.subCategories.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1,
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
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              children: [
                                // image
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: .5,
                                      ),
                                      color: Colors.blueAccent.shade100
                                          .withOpacity(.5),
                                      image: subCategory.imageUrl.isNotEmpty
                                          ? DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  subCategory.imageUrl),
                                            )
                                          : null,
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
