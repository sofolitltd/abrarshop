import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;
  String name;
  String imageUrl;
  String parentId;
  bool isFeatured;

  CategoryModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.parentId = '',
    required this.isFeatured,
  });

  /// empty
  static CategoryModel empty() =>
      CategoryModel(id: '', name: '', imageUrl: '', isFeatured: false);

  /// from data
  factory CategoryModel.fromJson(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      //
      return CategoryModel(
        id: data['id'] ?? '',
        name: data['name'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        parentId: data['parentId'] ?? '',
        isFeatured: data['isFeatured'] ?? false,
      );
    } else {
      return CategoryModel.empty();
    }
  }

  /// from data
  factory CategoryModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    //
    return CategoryModel(
      id: document.id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      parentId: data['parentId'] ?? '',
      isFeatured: data['isFeatured'] ?? false,
    );
  }

  /// to data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'parentId': parentId,
      'isFeatured': isFeatured,
    };
  }
}
