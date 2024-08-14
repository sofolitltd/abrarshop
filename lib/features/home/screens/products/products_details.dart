import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '/features/home/models/product_model.dart';
import '/utils/constants/constants.dart';
import '../../controllers/cart_controller.dart';
import '../cart/cart.dart';
import '../widgets/image_section.dart';
import 'cart_section.dart';

class ProductsDetails extends StatelessWidget {
  final ProductModel product;

  const ProductsDetails({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    //
    final cartController = Get.put(CartController());

    //
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        title: IconButton.filledTonal(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Iconsax.arrow_left,
            size: 22,
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
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

      //
      body: SingleChildScrollView(
        child: Column(
          children: [
            //
            ImageSection(images: product.images),

            const SizedBox(height: 4),

            //
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              height: MediaQuery.sizeOf(context).height - 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),

                  const SizedBox(height: 16),

                  //
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      Expanded(
                        flex: 5,
                        child: Container(
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.black12.withOpacity(.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //
                              Text(
                                'Special Price',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(),
                              ),
                              const SizedBox(height: 10),

                              Text(
                                '$kTkSymbol ${product.salePrice.toStringAsFixed(0)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      height: 1,
                                      // fontSize: 27,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      //
                      Expanded(
                        flex: 5,
                        child: SizedBox(
                          height: 75,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // regular
                              Container(
                                // width: 130,
                                decoration: BoxDecoration(
                                  color: Colors.black12.withOpacity(.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //
                                    Text(
                                      'Price:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            height: 1,
                                          ),
                                    ),

                                    const SizedBox(width: 16),

                                    Text(
                                      '$kTkSymbol ${product.regularPrice.toStringAsFixed(0)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                            color: Colors.black87,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 10),

                              // status
                              Container(
                                // width: 130,
                                decoration: BoxDecoration(
                                  color: Colors.black12.withOpacity(.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //
                                    Text(
                                      'Status:',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            height: 1.1,
                                          ),
                                    ),
                                    const SizedBox(width: 8),

                                    Text(
                                      'In Stock',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            height: 1,
                                            color: Colors.green,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  //
                  Text(
                    'Product Description',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                  ),

                  const SizedBox(height: 8),

                  //
                  Text(
                    product.description.isEmpty
                        ? '${product.name}, Special Price: ${product.salePrice.toStringAsFixed(0)}, Regular Price: ${product.regularPrice.toStringAsFixed(0)}'
                        : product.description,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          // fontWeight: FontWeight.bold,
                          height: 1.6,
                        ),
                  ),

                  const SizedBox(height: 24),

                  // add to cart
                  CartSection(product: product),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
