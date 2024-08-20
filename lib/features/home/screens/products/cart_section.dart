import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../controllers/cart_controller.dart';
import '../../models/cart_model.dart';
import '../../models/product_model.dart';
import '../cart/cart.dart';

class CartSection extends StatelessWidget {
  final ProductModel product;

  const CartSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Initialize the CartController using GetX
    final cartController = Get.put(CartController());

    // Convert ProductModel to CartModel for cart operations
    var cartItem = CartItemModel(
      id: product.id,
      name: product.name,
      price: product.salePrice,
      imageUrl: product.images.isNotEmpty ? product.images[0] : '',
      quantity: 1,
    );

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: () {
                // add to cart (if already not in cart)
                int index = cartController.cartItems.indexWhere(
                    (cartItemInCart) => cartItemInCart.id == cartItem.id);
                if (index == -1) {
                  // Item not in cart, add it and navigate
                  cartController.addToCart(cartItem);
                }

                //
                Get.to(
                  () => const Cart(),
                  transition: Transition.rightToLeft,
                );
              },
              icon: const Icon(
                Iconsax.book,
                size: 16,
              ),
              label: Text(
                'Buy Now'.toUpperCase(),
              ),
            ),
          ),

          const SizedBox(width: 16),

          //
          Expanded(
            flex: 3,
            child: OutlinedButton.icon(
              onPressed: () {
                // add to cart (if already not in cart)
                int index = cartController.cartItems.indexWhere(
                    (cartItemInCart) => cartItemInCart.id == cartItem.id);
                if (index == -1) {
                  // Item not in cart, add it and navigate
                  cartController.addToCart(cartItem);
                  //
                  Get.snackbar(
                    "Item Added",
                    "${cartItem.name} added to cart",
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 1),
                    colorText: Colors.white,
                    backgroundColor: Colors.green,
                  );
                } else {
                  Get.snackbar(
                    "Already Added",
                    "${cartItem.name} already in cart",
                    snackPosition: SnackPosition.BOTTOM,
                    colorText: Colors.white,
                    backgroundColor: Colors.red,
                    margin: const EdgeInsets.all(16),
                    duration: const Duration(seconds: 1),
                  );
                }

                //
              },
              icon: const Icon(
                Iconsax.shopping_bag,
                size: 16,
              ),
              label: Text(
                'Add To Cart'.toUpperCase(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
