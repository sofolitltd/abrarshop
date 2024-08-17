import 'package:abrar_shop/features/home/screens/products/all_products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/features/home/screens/home.dart';
import 'features/home/screens/cart/cart.dart';
import 'features/home/screens/profile/profile.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigatorController());

    return Scaffold(
      // bottom nav
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) {
            controller.selectedIndex.value = index;
          },
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.shop), label: 'Shop'),
            NavigationDestination(
                icon: Icon(Iconsax.shopping_bag), label: 'Cart'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),

      // body
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

// controller
class NavigatorController extends GetxController {
  Rx<int> selectedIndex = 0.obs;

  //
  final screens = [
    const Home(),
    const AllProducts(),
    const Cart(),
    const Profile(),
  ];
}
