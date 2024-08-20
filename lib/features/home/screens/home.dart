import 'package:abrar_shop/features/home/screens/categories/all_categories.dart';
import 'package:abrar_shop/features/home/screens/products/featured_products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/features/home/controllers/product_controller.dart';
import '/features/home/screens/categories/featured_category_details.dart';
import '/features/home/screens/products/products_details.dart';
import '/features/home/screens/search.dart';
import '/utils/constants/constants.dart';
import '/utils/shimmer/featured_category_shimmer.dart';
import '/utils/shimmer/popular_product_shimmer.dart';
import '../controllers/cart_controller.dart';
import '../controllers/category_controller.dart';
import '../models/cart_model.dart';
import 'cart/cart.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    //  controller
    final categoryController = Get.put(CategoryController());
    final productController = Get.put(ProductController());
    var productList = productController.allProducts;
    final cartController = Get.put(CartController());

    // ui
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        surfaceTintColor: Colors.transparent,
        title: const Text.rich(
          TextSpan(
              text: 'Abrar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
              children: [
                TextSpan(
                  text: ' Shop',
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                    color: Colors.white,
                    fontSize: 23,
                  ),
                )
              ]),
        ),
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
      body: RefreshIndicator(
        onRefresh: () async {
          productController.fetchProducts();
          categoryController.fetchCategories();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              //
              Padding(
                padding: const EdgeInsets.all(16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Get.to(() => const Search(),
                        transition: Transition.noTransition);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black26,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: const Row(
                      children: [
                        Icon(
                          Iconsax.search_normal,
                          size: 20,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 4),
                        Text(
                          ' Search in store ...',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // category
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //
                        Text(
                          'Featured Categories',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                        ),

                        //
                        TextButton(
                          onPressed: () {
                            Get.to(() => const AllCategories());
                          },
                          child: const Text(
                            'See More',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // category list
                    Obx(() {
                      // loading
                      if (categoryController.isLoading.value == true) {
                        return const FeaturedCategoryShimmer();
                      }

                      // if featured category empty
                      if (categoryController.featuredCategories.isEmpty) {
                        return const Text('No data found');
                      }

                      // ui
                      return SizedBox(
                        height: 96,
                        child: ListView.separated(
                          itemCount:
                              categoryController.featuredCategories.length,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) =>
                              const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            // category
                            final category =
                                categoryController.featuredCategories[index];

                            //
                            return GestureDetector(
                              onTap: () {
                                // featured category details
                                Get.to(
                                  () => FeaturedCategoryDetails(
                                    category: category,
                                    isSubCategory: false,
                                  ),
                                  transition: Transition.noTransition,
                                );
                              },
                              child: Column(
                                children: [
                                  // image
                                  Container(
                                    height: 64,
                                    width: 64,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: .5,
                                      ),
                                      color: Colors.blueAccent.shade100
                                          .withOpacity(.5),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(category.imageUrl),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // name
                                  SizedBox(
                                    width: 72,
                                    height: 24,
                                    child: Center(
                                      child: Text(
                                        category.name,
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              height: 1.2,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // featured products
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // featured product
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // 1
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //
                                Text(
                                  'Popular Products',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                ),
                                //
                                Text(
                                  'Check and Get your products',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: Colors.black.withOpacity(.6),
                                      ),
                                ),
                              ],
                            ),

                            //2
                            TextButton(
                                onPressed: () {
                                  Get.to(
                                    () => const FeaturedProducts(),
                                    transition: Transition.noTransition,
                                  );
                                },
                                child: const Text('See More'))
                          ],
                        ),

                        const SizedBox(height: 16),

                        //
                        Obx(
                          () {
                            // loading
                            if (productController.isLoading.value == true) {
                              return const PopularProductShimmer();
                            }

                            // if featured category empty
                            if (productController.featuredProducts.isEmpty) {
                              return const Text('No data found');
                            }

                            // ui
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: .65,
                              ),
                              itemCount:
                                  productController.featuredProducts.length,
                              itemBuilder: (context, index) {
                                // category
                                final product =
                                    productController.featuredProducts[index];

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
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.blueAccent.shade100
                                                  .withOpacity(.5),
                                              image: product.images.isNotEmpty
                                                  ? DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          product.images[0]),
                                                    )
                                                  : null,
                                            ),
                                          ),
                                        ),

                                        // name
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              //
                                              SizedBox(
                                                height: 40,
                                                child: Text(
                                                  product.name,
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        height: 1.3,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),

                                              const SizedBox(height: 8),

                                              // price, add to cart
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.baseline,
                                                textBaseline:
                                                    TextBaseline.ideographic,
                                                children: [
                                                  //
                                                  Text(
                                                    '$kTkSymbol ${product.salePrice.toStringAsFixed(0)} ',
                                                    textAlign: TextAlign.start,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                          height: 1.3,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),

                                                  //
                                                  InkWell(
                                                    onTap: () {
                                                      var cartItem =
                                                          CartItemModel(
                                                        id: product.id,
                                                        name: product.name,
                                                        price:
                                                            product.salePrice,
                                                        imageUrl:
                                                            product.images[0],
                                                        quantity: 1,
                                                      );

                                                      // Toggle item in cart
                                                      cartController
                                                          .toggleItemInCart(
                                                              cartItem);
                                                    },
                                                    child: Obx(
                                                      () {
                                                        // Use Obx to observe changes in cartItems
                                                        bool isInCart =
                                                            cartController
                                                                .cartItems
                                                                .any((item) =>
                                                                    item.id ==
                                                                    product.id);
                                                        return Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: isInCart
                                                                ? Colors.red
                                                                : Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            border: Border.all(
                                                              color: isInCart
                                                                  ? Colors
                                                                      .transparent
                                                                  : Colors
                                                                      .black38,
                                                            ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          child: Icon(
                                                            isInCart
                                                                ? Iconsax
                                                                    .shopping_bag5
                                                                : Iconsax
                                                                    .shopping_bag,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
