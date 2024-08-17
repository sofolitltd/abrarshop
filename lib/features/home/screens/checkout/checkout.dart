import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/features/home/screens/checkout/payment_success.dart';
import '../../controllers/address_controller.dart';
import '../../controllers/cart_controller.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    final addressController = Get.put(AddressController());

    double deliveryCharge = 50;

    return Scaffold(
      // app bar
      appBar: AppBar(
        title: const Text('Checkout'),
      ),

      // body
      body: ListView(
        children: [
          //
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12),
            ),
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Cart Item',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                ),
                // cart
                ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(16),
                  itemCount: cartController.cartItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  // name
                                  Text(
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

                                  const SizedBox(height: 2),

                                  // add/remove
                                  Row(
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
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),

                                      const SizedBox(width: 4),
                                      //
                                      Text(
                                        '(${cartItem.price.toStringAsFixed(0)} x ${cartItem.quantity})',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Colors.black54,
                                            ),
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
                ),
              ],
            ),
          ),

          //

          // coupon
          Visibility(
            visible: false,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black26),
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              margin: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Have a promo code? Enter here',
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  //Apply
                  ElevatedButton(onPressed: () {}, child: const Text('Apply')),
                ],
              ),
            ),
          ),

          // total
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blueGrey.shade50),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 3,
                  blurRadius: 8,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // subtotal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Obx(
                      () => Text(
                        cartController.totalPrice.toStringAsFixed(0),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),

                // delivery
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Fee',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text(
                      deliveryCharge.toStringAsFixed(0),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total',
                        style: Theme.of(context).textTheme.titleMedium),
                    Obx(
                      () => Text(
                        (cartController.totalPrice + deliveryCharge)
                            .toStringAsFixed(0),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),

                const Divider(height: 32, thickness: .5),

                // payment method

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Method',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                    ),

                    const SizedBox(height: 16),

                    // payment option
                    Row(
                      children: [
                        //
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.black26),
                            image: const DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                'https://freelogopng.com/images/all_img/1656234745bkash-app-logo-png.png',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        //
                        Text(
                          'Bkash',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                        ),
                        const Spacer(),

                        //
                        const Icon(
                          Iconsax.tick_circle,
                          color: Colors.green,
                          size: 28,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                const Divider(thickness: .5),

                // address
                Obx(
                  () {
                    final selectedAddress =
                        AddressController.instance.selectedAddress.value;

                    //
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shipping Address',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                            ),

                            //
                            TextButton(
                              onPressed: () {
                                addressController.showAddressBottomSheet();
                              },
                              child: Text(
                                'Change',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),

                        // Name
                        Text(
                          selectedAddress?.name ?? 'No Address',
                          // Display "No Address" if null
                          style: Theme.of(context).textTheme.titleMedium,
                        ),

                        const SizedBox(height: 8),

                        // Call
                        if (selectedAddress !=
                            null) // Only show call details if an address is selected
                          Row(
                            children: [
                              const Icon(Iconsax.call, size: 16),
                              const SizedBox(width: 12),
                              Text(selectedAddress.mobile),
                            ],
                          ),

                        // Location
                        if (selectedAddress !=
                            null) // Only show location details if an address is selected
                          Row(
                            children: [
                              const Icon(Iconsax.location, size: 16),
                              const SizedBox(width: 12),
                              Text(selectedAddress.address),
                            ],
                          ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ],
      ),

      // btn
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Get.to(const PaymentSuccess());
          },
          child: const Text('Confirm Order'),
        ),
      ),
    );
  }
}
