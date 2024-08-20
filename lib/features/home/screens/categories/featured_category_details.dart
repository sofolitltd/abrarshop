import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/features/home/controllers/cart_controller.dart';
import '/features/home/models/category_model.dart';
import '/utils/constants/constants.dart';
import '/utils/shimmer/popular_product_shimmer.dart';
import '../../controllers/product_controller.dart';
import '../../models/cart_model.dart';
import '../cart/cart.dart';
import '../products/products_details.dart';

class FeaturedCategoryDetails extends StatelessWidget {
  final CategoryModel category;
  final bool isSubCategory;
  const FeaturedCategoryDetails({
    super.key,
    required this.category,
    required this.isSubCategory,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());

    final productController = Get.put(ProductController());
    if (isSubCategory) {
      productController.getSubCategoryProduct(category.name);
      productController.setSubCategoryProducts(
          'Latest Items', productController.subCategoryProducts);
    } else {
      productController.getCategoryProduct(category.name);
      productController.setCategoryProducts(
          'Latest Items', productController.categoryProducts);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              //
              IconButton.filledTonal(
                onPressed: () {
                  Get.to(
                    () => const Cart(),
                    transition: Transition.rightToLeft,
                  );
                },
                icon: const Icon(
                  Iconsax.shopping_bag,
                  size: 22,
                ),
              ),

              //
              Obx(
                () => Badge(
                  label: Text(
                    '${cartController.cartItems.length}',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),

      // body
      body: ListView(
        children: [
          //
          // sort menu
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //
                Text(
                  'Sort by:',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        height: 1.6,
                      ),
                ),

                //
                Obx(
                  () => ButtonTheme(
                    alignedDropdown: true,
                    child: Container(
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DropdownButton(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        isDense: true,
                        isExpanded: true,
                        value: isSubCategory
                            ? productController
                                .selectedSubCategorySortOption.value
                            : productController
                                .selectedCategorySortOption.value,
                        items: <String>[
                          'Name',
                          'Latest Items',
                          'Low to High',
                          'High to Low',
                        ].map((String menu) {
                          return DropdownMenuItem(
                            value: menu,
                            child: Text(menu),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          if (isSubCategory) {
                            productController.setSubCategoryProducts(
                                value!, productController.subCategoryProducts);
                          } else {
                            productController.setCategoryProducts(
                                value!, productController.categoryProducts);
                          }
                        },
                        underline: const SizedBox(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //
          Obx(
            () {
              // loading
              if (productController.isLoading.value == true) {
                return const PopularProductShimmer();
              }
              // if featured category empty
              if (isSubCategory
                  ? productController.subCategoryProducts.isEmpty
                  : productController.categoryProducts.isEmpty) {
                return const Center(child: Text('No data found'));
              }

              // ui
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: .65,
                ),
                itemCount: isSubCategory
                    ? productController.subCategoryProducts.length
                    : productController.categoryProducts.length,
                itemBuilder: (context, index) {
                  // category
                  final product = isSubCategory
                      ? productController.subCategoryProducts[index]
                      : productController.categoryProducts[index];

                  //
                  return GestureDetector(
                    onTap: () {
                      // featured products details
                      Get.to(
                        () => ProductsDetails(product: product),
                        transition: Transition.noTransition,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        children: [
                          // image
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: const Border(
                                  bottom: BorderSide(
                                    color: Colors.black12,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(8),
                                color:
                                    Colors.blueAccent.shade100.withOpacity(.5),
                                image: product.images.isNotEmpty
                                    ? DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(product.images[0]),
                                      )
                                    : null,
                              ),
                            ),
                          ),

                          // name
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //
                                SizedBox(
                                  height: 40,
                                  child: Text(
                                    product.name,
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          height: 1.3,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // price, add to cart
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.ideographic,
                                  children: [
                                    //
                                    Text(
                                      '$kTkSymbol ${product.salePrice.toStringAsFixed(0)} ',
                                      textAlign: TextAlign.start,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            height: 1.3,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),

                                    //
                                    InkWell(
                                      onTap: () {
                                        var cartItem = CartItemModel(
                                          id: product.id,
                                          name: product.name,
                                          price: product.salePrice,
                                          imageUrl: product.images[0],
                                          quantity: 1,
                                        );

                                        // Toggle item in cart
                                        cartController
                                            .toggleItemInCart(cartItem);
                                      },
                                      child: Obx(
                                        () {
                                          // Use Obx to observe changes in cartItems
                                          bool isInCart = cartController
                                              .cartItems
                                              .any((item) =>
                                                  item.id == product.id);
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: isInCart
                                                  ? Colors.red
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color: isInCart
                                                    ? Colors.transparent
                                                    : Colors.black38,
                                              ),
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            child: Icon(
                                              isInCart
                                                  ? Iconsax.shopping_bag5
                                                  : Iconsax.shopping_bag,
                                              size: 18,
                                              color: isInCart
                                                  ? Colors.white
                                                  : Colors
                                                      .black, // Change color based on cart status
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
