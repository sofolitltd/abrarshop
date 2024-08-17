import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/address_model.dart';

class AddressController extends GetxController {
  static AddressController get instance => Get.find();

  var addresses = <AddressModel>[
    AddressModel(
      name: 'Asif Reyad',
      mobile: '01704340860',
      email: 'asifreyad1@gmail.com',
      address: '109/2, Purbo Shanbon, Rangpur',
    ),
    AddressModel(
      name: 'Sofol IT',
      mobile: '01704340860',
      email: 'Sofolitltd@gmail.com',
      address: 'Chittagong University , Chittagong',
    ),
  ].obs;

  Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);

  @override
  void onInit() {
    super.onInit();
    if (addresses.isNotEmpty) {
      selectedAddress.value =
          addresses[0]; // Set the first address as selected by default
    }
  }

  //
  void showAddressBottomSheet() {
    //
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //
                const Text(
                  'Select Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                //
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.close)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            //
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return Obx(
                    () => ListTile(
                      title: Text(address.name),
                      subtitle: Text('${address.mobile}\n${address.address}'),
                      tileColor: selectedAddress.value == address
                          ? Colors.blue.shade50
                          : null, // Highlight selected address
                      onTap: () {
                        selectedAddress.value =
                            address; // Update selected address
                        Get.back();
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle "Add New Address" button press
              },
              child: const Text('Add New Address'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }
}
