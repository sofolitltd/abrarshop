import 'package:abrar_shop/features/home/models/brand_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BrandRepository extends GetxController {
  static BrandRepository get instance => Get.find();

  // var
  final _db = FirebaseFirestore.instance;

  /// get all categories
  Future<List<BrandModel>> getAllBrands() async {
    try {
      final snapshot = await _db.collection('brands').orderBy('name').get();
      final list = snapshot.docs
          .map((document) => BrandModel.fromSnapshot(document))
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
