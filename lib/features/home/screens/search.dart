import 'package:abrar_shop/features/home/controllers/product_controller.dart';
import 'package:abrar_shop/features/home/screens/products/products_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/constants.dart';
import '../models/product_model.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    // controller
    final productController = Get.put(ProductController());
    var productList = productController.allProducts;

    //
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text('Search '),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // search
          Padding(
            padding: const EdgeInsets.all(16),
            child: Autocomplete<ProductModel>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<ProductModel>.empty();
                }
                List<String> words =
                    textEditingValue.text.toLowerCase().split(' ');
                return productList.where((ProductModel item) {
                  return words
                      .every((word) => item.name.toLowerCase().contains(word));
                });
              },
              displayStringForOption: (ProductModel option) => option.name,
              onSelected: (ProductModel productModel) {
                //
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  onSubmitted: (_) => onFieldSubmitted(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    // fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: ' Search in store ...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.black12,
                      ),
                    ),
                    prefixIcon: const Icon(
                      Iconsax.search_normal,
                      size: 20,
                      color: Colors.black54,
                    ),
                    suffix: GestureDetector(
                      onTap: () {
                        textEditingController.clear();
                      },
                      child: const Icon(
                        Iconsax.close_circle,
                        size: 18,
                        color: Colors.black54,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                  ),
                );
              },
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<ProductModel> onSelected,
                  Iterable<ProductModel> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 1042),
                        height: MediaQuery.of(context).size.height - 32,
                        width: MediaQuery.of(context).size.width - 32,
                        padding: const EdgeInsets.all(12),
                        child: ListView.separated(
                          itemCount: options.length,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(thickness: .5),
                          itemBuilder: (BuildContext context, int index) {
                            final ProductModel option =
                                options.elementAt(index);
                            //
                            return InkWell(
                              onTap: () {
                                // onSelected(option);

                                //
                                Get.to(
                                  () => ProductsDetails(product: option),
                                  transition: Transition.zoom,
                                );
                              },
                              child: Row(
                                children: [
                                  //
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12),
                                    ),
                                    width: 56,
                                    height: 56,
                                    child: option.images.isNotEmpty
                                        ? Image.network(
                                            option.images[0],
                                            fit: BoxFit.cover,
                                          )
                                        : const Placeholder(),
                                  ),

                                  const SizedBox(width: 16),

                                  //
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          option.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(),
                                        ),

                                        const SizedBox(height: 8),

                                        //
                                        Text(
                                          '${option.regularPrice.toStringAsFixed(0)} $kTkSymbol',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                                fontSize: 18,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'All Products',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          // list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: productList.length,
              shrinkWrap: true,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 12),
              itemBuilder: (context, index) {
                ProductModel product = productList[index];

                //
                return GestureDetector(
                  onTap: () {
                    //
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductsDetails(product: product),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      //
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black12),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            // image
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withOpacity(.5),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.black12),
                                image: product.images.isEmpty
                                    ? null
                                    : DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          product.images[0],
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            //
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  //
                                  Text(
                                    '${product.name} ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(),
                                  ),

                                  const SizedBox(height: 10),

                                  Row(
                                    children: [
                                      //
                                      Text(
                                        '$kTkSymbol ${product.salePrice.toStringAsFixed(0)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                              color: Colors.red,
                                              fontSize: 20,
                                              height: 1,
                                            ),
                                      ),

                                      const SizedBox(width: 16),

                                      //
                                      // Text.rich(
                                      //   TextSpan(
                                      //       text: 'Sale: ',
                                      //       children: [
                                      //         TextSpan(
                                      //           text:
                                      //               '${product.salePrice.toStringAsFixed(0)} $kTkSymbol',
                                      //           style: Theme.of(
                                      //                   context)
                                      //               .textTheme
                                      //               .titleSmall!
                                      //               .copyWith(
                                      //                 fontSize:
                                      //                     20,
                                      //                 height: 1,
                                      //               ),
                                      //         ),
                                      //       ]),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      //
                      // IconButton(
                      //     onPressed: () async {
                      //       //
                      //
                      //       await showDeleteDialog(
                      //           context: context,
                      //           id: product.id,
                      //           collectionName: 'products');
                      //
                      //       //
                      //       for (int i = 0;
                      //           i < product.images.length;
                      //           i++) {
                      //         await FirebaseStorage.instance
                      //             .refFromURL(
                      //                 product.images[i])
                      //             .delete()
                      //             .then((val) {
                      //           print('Delete images');
                      //         });
                      //       }
                      //     },
                      //     icon: const Icon(
                      //       Icons.delete_outline,
                      //       size: 20,
                      //     )),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
