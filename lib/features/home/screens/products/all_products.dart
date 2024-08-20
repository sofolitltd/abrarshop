import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/features/home/controllers/product_controller.dart';
import '/features/home/screens/products/products_details.dart';
import '/utils/constants/constants.dart';
import '/utils/shimmer/popular_product_shimmer.dart';
import '../../controllers/cart_controller.dart';
import '../../models/cart_model.dart';
import '../cart/cart.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());
    productController.fetchProducts();
    productController.setProducts(
        'Latest Items', productController.allProducts);
    //
    final cartController = Get.put(CartController());

    //
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        surfaceTintColor: Colors.transparent,
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
        },
        child: Column(
          children: [
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
                          value: productController.selectedSortOption.value,
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
                            productController.setProducts(
                              value!,
                              productController.allProducts,
                            );
                          },
                          underline: const SizedBox(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // all products
            Obx(
              () {
                // loading
                if (productController.isLoading.value == true) {
                  return const Expanded(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: PopularProductShimmer(),
                  ));
                }

                // if featured category empty
                if (productController.allProducts.isEmpty) {
                  return const Text('No data found');
                }

                // ui
                return Expanded(
                  child: GridView.builder(
                    // shrinkWrap: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: .65,
                    ),
                    itemCount: productController.allProducts.length,
                    itemBuilder: (context, index) {
                      // category
                      final product = productController.allProducts[index];

                      //
                      return GestureDetector(
                        onTap: () {
                          //  products details
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
                                    color: Colors.blueAccent.shade100
                                        .withOpacity(.5),
                                    image: product.images.isNotEmpty
                                        ? DecorationImage(
                                            fit: BoxFit.cover,
                                            image:
                                                NetworkImage(product.images[0]),
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
                                              imageUrl:
                                                  product.images.isNotEmpty
                                                      ? product.images[0]
                                                      : '',
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
                                                padding:
                                                    const EdgeInsets.all(4),
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
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
