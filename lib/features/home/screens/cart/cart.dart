import 'package:abrar_shop/navigation_menu.dart';
import 'package:abrar_shop/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../controllers/cart_controller.dart';
import '../checkout/checkout.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              const IconButton.filledTonal(
                onPressed: null,
                icon: Icon(
                  Iconsax.shopping_bag,
                  size: 22,
                ),
              ),

              // show total cart item
              Obx(
                () => Badge(
                  label: Text('${cartController.cartItems.length}'),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(
        () {
          if (cartController.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('No product found!'),
                  const SizedBox(height: 16),

                  //
                  ElevatedButton.icon(
                    onPressed: () {
                      NavigatorController navigatorController =
                          Get.find<NavigatorController>();
                      if (Get.currentRoute == '/menu') {
                        // Set the selected index to 0 (Home)
                        navigatorController.selectedIndex.value = 1;
                      } else {
                        (Get.offAll(() => const NavigationMenu()));
                        navigatorController.selectedIndex.value = 1;
                      }
                    },
                    icon: const Icon(
                      Iconsax.shop,
                      size: 16,
                    ),
                    label: const Text('Continue Shopping'),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cartController.cartItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final cartItem = cartController.cartItems[index];

              //
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image placeholder
                    Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black12),
                        image: DecorationImage(
                          image: NetworkImage(cartItem.imageUrl),
                        ),
                      ),
                      // Assuming imageUrl is a valid image URL
                    ),
                    const SizedBox(width: 12),

                    // Name, price, add/remove
                    Expanded(
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 72,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // name
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //
                                Expanded(
                                  child: Text(
                                    cartItem.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          fontSize: 18,
                                          height: 1.3,
                                        ),
                                  ),
                                ),

                                const SizedBox(width: 8),

                                // delete from cart
                                GestureDetector(
                                  onTap: () {
                                    cartController
                                        .showDeleteConfirmationDialog(cartItem);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: const Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 2),

                            // add/remove
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //
                                Expanded(
                                  child: Row(
                                    textBaseline: TextBaseline.ideographic,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    children: [
                                      Text(
                                        (cartItem.price * cartItem.quantity)
                                            .toStringAsFixed(0),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),

                                      const SizedBox(width: 4),
                                      //
                                      Text(
                                        '(${cartItem.price.toStringAsFixed(0)} x ${cartItem.quantity})',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Colors.black54,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(width: 8),

                                //
                                Row(
                                  children: [
                                    // Decrease quantity
                                    GestureDetector(
                                      onTap: () {
                                        cartController
                                            .decreaseQuantityOf(cartItem);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        child: const Icon(
                                          Iconsax.minus,
                                        ),
                                      ),
                                    ),

                                    // Display quantity
                                    Container(
                                      constraints:
                                          const BoxConstraints(minWidth: 32),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${cartItem.quantity}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                      ),
                                    ),

                                    // Increase quantity
                                    GestureDetector(
                                      onTap: () {
                                        cartController
                                            .increaseQuantityOf(cartItem);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.all(2),
                                        child: const Icon(
                                          Iconsax.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      // Checkout button with grand total
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //
              if (cartController.cartItems.isNotEmpty) ...[
                //
                Obx(
                  () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Item: ${cartController.totalQuantity}',
                        ),
                        Text(
                          'Total Price: $kTkSymbol ${cartController.totalPrice.toStringAsFixed(0)}',
                        ),
                      ]),
                ),

                const SizedBox(height: 8),

                //
                ElevatedButton(
                  onPressed: () {
                    Get.to(
                      const CheckOut(),
                      transition: Transition.noTransition,
                    );
                  },
                  child: const Text('Checkout'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
