import 'package:abrar_shop/features/admin/brands_admin/all_brands_admin.dart';
import 'package:abrar_shop/features/admin/products_admin/all_products_admin.dart';
import 'package:abrar_shop/features/authentication/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../admin/categories_admin/all_categories_admin.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(UserController());
    var user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (user == null) {
          return _buildLoginPrompt(context);
        } else {
          return _buildProfileContent(context, user);
        }
      }),
      bottomNavigationBar: user == null ? null : _buildSignOutButton(context),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent.shade100.withOpacity(.5),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(24),
              child: const Icon(
                Iconsax.user,
                size: 100,
                color: Colors.black26,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please login first',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/login', arguments: '/profile');
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, User user) {
    return ListView(
      children: [
        _buildProfileHeader(user),
        const SizedBox(height: 16),
        _buildSettingsSection(context),
      ],
    );
  }

  Widget _buildProfileHeader(User user) {
    final userController = Get.put(UserController());

    return Obx(
      () => ListTile(
        tileColor: Colors.blueAccent,
        leading: const CircleAvatar(
          radius: 24,
        ),
        title: Text(
          userController.user.value.name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          userController.user.value.email,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: IconButton(
          onPressed: () {
            // Implement edit profile functionality here
          },
          icon: const Icon(
            Iconsax.edit,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final userController = Get.put(UserController());

    return Container(
      constraints: const BoxConstraints(minHeight: 600),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Account Settings'),
          const SizedBox(height: 8),
          ..._buildAccountSettings(),
          const SizedBox(height: 16),
          if (userController.user.value.email == 'asifreyad1@gmail.com') ...[
            _buildSectionHeader(context, 'Admin'),
            ..._buildAdminSettings(),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildAccountSettings() {
    final List<Map<String, dynamic>> accountSettings = [
      {
        'title': 'My Address',
        'subtitle': 'Set shopping delivery address',
        'icon': Iconsax.home_wifi,
        'route': '/address',
      },
      {
        'title': 'My Cart',
        'subtitle': 'Add/Remove products and move to Checkout',
        'icon': Iconsax.shopping_bag,
        'route': '/cart',
      },
      {
        'title': 'My Orders',
        'subtitle': 'In-progress and Completed Products',
        'icon': Iconsax.bag,
        'route': '/orders',
      },
    ];

    return accountSettings.map((setting) {
      return ListTile(
        onTap: () => Get.toNamed(setting['route']),
        contentPadding: EdgeInsets.zero,
        title: Text(
          setting['title'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(setting['subtitle']),
        leading: Icon(
          setting['icon'],
          size: 32,
          color: Colors.blueAccent,
        ),
      );
    }).toList();
  }

  List<Widget> _buildAdminSettings() {
    return [
      // cat
      ListTile(
        onTap: () => Get.to(() => const AllCategoriesAdmin()),
        contentPadding: EdgeInsets.zero,
        title: const Text(
          'Add Category',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Add category and subcategory'),
        leading: const Icon(
          Iconsax.category,
          size: 32,
          color: Colors.blueAccent,
        ),
      ),

      // brand
      ListTile(
        onTap: () => Get.to(() => const AllBrandsAdmin()),
        contentPadding: EdgeInsets.zero,
        title: const Text(
          'Add Brand',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Add product brands'),
        leading: const Icon(
          Iconsax.briefcase,
          size: 32,
          color: Colors.blueAccent,
        ),
      ),

      //
      ListTile(
        onTap: () => Get.to(() => const AllProductsAdmin()),
        contentPadding: EdgeInsets.zero,
        title: const Text(
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Add product details'),
        leading: const Icon(
          Iconsax.shop,
          size: 32,
          color: Colors.blueAccent,
        ),
      ),
    ];
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
    );
  }

  //
  Widget _buildSignOutButton(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () {
          _showSignOutDialog(context); // Show dialog before sign out
        },
        child: const Text('Sign out'),
      ),
    );
  }

  // Helper method to show the sign-out dialog
  void _showSignOutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // Close the dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed('/menu'); // Redirect to login
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
