import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '/features/home/models/product_model.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  // var
  final _db = FirebaseFirestore.instance;

  /// get all categories
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await _db.collection('products').get();
      final list = snapshot.docs
          .map((document) => ProductModel.fromJson(document))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      throw 'Firebase error: $e';
    } catch (e) {
      //
      throw 'Something wrong: $e';
    }
  }
}
