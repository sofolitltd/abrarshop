import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '/features/home/models/product_model.dart';

class ProductRepository extends GetxController {
  static ProductRepository get instance => Get.find();

  // var
  final _db = FirebaseFirestore.instance;

  // sort

  /// get all products
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await _db.collection('products').get();
      final productList = snapshot.docs
          .map((document) => ProductModel.fromJson(document))
          .toList();
      return productList;
    } on FirebaseException catch (e) {
      throw 'Firebase error: $e';
    } catch (e) {
      //
      throw 'Something wrong: $e';
    }
  }

  /// get  products by query
  Future<List<ProductModel>> getProductsByQuery(Query query) async {
    try {
      final querySnapshot = await query.get();
      final List<ProductModel> productList = querySnapshot.docs
          .map((doc) => ProductModel.fromQuerySnapshot(doc))
          .toList();
      return productList;
    } on FirebaseException catch (e) {
      throw 'Firebase error: $e';
    } catch (e) {
      //
      throw 'Something wrong: $e';
    }
  }
}
