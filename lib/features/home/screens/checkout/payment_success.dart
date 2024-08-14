import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // img
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.shade50,
                    ),
                    padding: const EdgeInsets.all(24),
                    child: const Icon(
                      Iconsax.copy_success,
                      size: 100,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 24),

                  //
                  Text('Payment Successful!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Your Item Will be Shipped Soon.',
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.titleSmall!.copyWith()),

                  const SizedBox(height: 32),

                  ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Continue Shopping'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
