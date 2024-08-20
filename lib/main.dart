import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '/features/authentication/screens/create_account_screen.dart';
import '/features/authentication/screens/login_screen.dart';
import '/navigation_menu.dart';
import 'features/home/screens/address/address.dart';
import 'features/home/screens/cart/cart.dart';
import 'features/home/screens/orders/orders.dart';
import 'features/home/screens/profile/profile.dart';
import 'firebase_options.dart';

Future<void> main() async {
  // init firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Abrar Shop',
      theme: ThemeData(
        fontFamily: 'Telenor',
        //
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent.shade700,
            foregroundColor: Colors.white,
            minimumSize: const Size(48, 48),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black,
            minimumSize: const Size(48, 48),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/menu', page: () => const NavigationMenu()),
        GetPage(name: '/cart', page: () => const Cart()),
        GetPage(name: '/profile', page: () => const Profile()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(
            name: '/create-account', page: () => const CreateAccountScreen()),
        GetPage(name: '/address', page: () => const Address()),
        GetPage(name: '/orders', page: () => const Orders()),
      ],
      home: const NavigationMenu(),
    );
  }
}
