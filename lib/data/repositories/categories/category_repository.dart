import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '/features/home/models/category_model.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();

  // var
  final _db = FirebaseFirestore.instance;

  /// get all categories
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final snapshot = await _db.collection('categories').orderBy('name').get();
      final list = snapshot.docs
          .map((document) => CategoryModel.fromJson(document))
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
