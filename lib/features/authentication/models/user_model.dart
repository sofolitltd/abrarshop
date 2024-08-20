import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String mobile;
  final String email;
  final String image;
  final Timestamp createdDate;
  final String fcmToken;

  UserModel({
    required this.uid,
    required this.name,
    required this.mobile,
    required this.email,
    required this.image,
    required this.createdDate,
    required this.fcmToken,
  });

  // empty
  static UserModel empty() => UserModel(
        uid: '',
        name: '',
        mobile: '',
        email: '',
        image: '',
        createdDate: Timestamp.now(),
        fcmToken: '',
      );

  // Factory constructor to create a UserModel from a Firestore document
  factory UserModel.fromQuerySnapshot(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] as String,
      name: data['name'] as String,
      mobile: data['mobile'] as String,
      email: data['email'] as String,
      image: data['image'] as String,
      createdDate: data['createdDate'] as Timestamp,
      fcmToken: data['fcmToken'] as String,
    );
  }

  // Method to convert UserModel to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'mobile': mobile,
      'email': email,
      'image': image,
      'createdDate': createdDate,
      'fcmToken': fcmToken,
    };
  }
}
