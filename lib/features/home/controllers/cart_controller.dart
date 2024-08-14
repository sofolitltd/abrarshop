import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/cart_model.dart';

class CartController extends GetxController {
  static CartController get instance => Get.find();
  RxList<CartItemModel> cartItems = <CartItemModel>[].obs;

  // Add a product to the cart
  void addToCart(CartItemModel item) {
    // Check if the item is already in the cart
    int index = cartItems.indexWhere((cartItem) => cartItem.id == item.id);
    if (index == -1) {
      // Item not found, add it
      cartItems.add(item);
    } else {
      // Item found, increase its quantity
      cartItems[index].quantity++;
      cartItems.refresh(); // Notify GetX of the change
    }
  }

  // Increase the quantity of an item
  void increaseQuantityOf(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) => cartItem.id == item.id);
    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh(); // Notify GetX of the change
    }
  }

  // Decrease the quantity of an item
  void decreaseQuantityOf(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) => cartItem.id == item.id);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh(); // Notify GetX of the change
      } else {
        // Remove the item if quantity becomes 0
        showDeleteConfirmationDialog(item);
      }
    }
  }

  // Get the total price of all items in the cart
  double get totalPrice =>
      cartItems.fold(0.0, (sum, item) => sum + item.price * item.quantity);

  // Get the total quantity of all items in the cart
  int get totalQuantity =>
      cartItems.fold(0, (sum, item) => sum + item.quantity);

  //
  void toggleItemInCart(CartItemModel item) {
    int index = cartItems.indexWhere((cartItem) => cartItem.id == item.id);
    if (index == -1) {
      cartItems.add(item); // Add item if not present
      Get.snackbar(
        "Item Added",
        "${item.name} added to cart",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 1),
      );
    } else {
      cartItems.removeAt(index); // Remove item if present

      //
      Get.snackbar(
        "Item Removed",
        "${item.name} removed from cart",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 1),
      );
    }
  }

  //
  void showDeleteConfirmationDialog(CartItemModel item) {
    Get.defaultDialog(
      title: "Confirm Delete",
      middleText: "Are you sure you want to delete this item from your cart?",
      textConfirm: "Yes",
      textCancel: "No",
      confirmTextColor: Colors.white,
      onConfirm: () {
        removeFromCart(item); // Remove the item
        Get.back(); // Close the dialog
      },
    );
  }

  // remove from cart
  void removeFromCart(CartItemModel item) {
    cartItems.removeWhere((cartItem) => cartItem.id == item.id);
  }
}
