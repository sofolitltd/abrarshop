import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../features/authentication/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<UserModel> getUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await _db.collection('users').doc(user.uid).get();
        if (snapshot.exists) {
          return UserModel.fromQuerySnapshot(snapshot.data()!);
        } else {
          // Handle the case where the user document doesn't exist
          throw 'User document not found';
        }
      } else {
        throw 'User not authenticated';
      }
    } on FirebaseException catch (e) {
      throw 'Firebase error: $e';
    } catch (e) {
      throw 'Something wrong: $e';
    }
  }
}
