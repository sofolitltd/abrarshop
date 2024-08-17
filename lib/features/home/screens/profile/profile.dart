import 'package:abrar_shop/features/home/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());

    //
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

      //
      body: ListView(
        children: [
          //
          ListTile(
            tileColor: Colors.blueAccent,
            leading: const CircleAvatar(
              radius: 24,
            ),
            title: const Text(
              'Asifuzzaman Reyad',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: const Text(
              'asifreyad@mail.com',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(
                Iconsax.edit,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 16),
          //
          Container(
            constraints: const BoxConstraints(minHeight: 600),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Text(
                  'Account Settings',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                ),

                const SizedBox(height: 8),

                //
                Column(
                  children: [
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
                  ]
                      .map(
                        (profile) => ListTile(
                          onTap: () {
                            Get.toNamed(
                              profile['route'] as String,
                            );
                          },
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            profile['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            profile['subtitle'] as String,
                            style: const TextStyle(),
                          ),
                          leading: Icon(
                            profile['icon'] as IconData,
                            size: 32,
                            color: Colors.blueAccent,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
