import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String id;
  String name;
  String slug;
  String imageUrl;
  String parentId;
  bool isFeatured;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
    required this.parentId,
    required this.isFeatured,
  });

  /// empty
  static CategoryModel empty() => CategoryModel(
      id: '',
      name: '',
      slug: '',
      imageUrl: '',
      parentId: '',
      isFeatured: false);

  /// from data
  factory CategoryModel.fromJson(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      //
      return CategoryModel(
        id: data['id'] ?? '',
        name: data['name'] ?? '',
        slug: data['slug'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        parentId: data['parentId'] ?? '',
        isFeatured: data['isFeatured'] ?? false,
      );
    } else {
      return CategoryModel.empty();
    }
  }

  /// from data
  factory CategoryModel.fromQuerySnapshot(data) {
    //
    return CategoryModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      slug: data['slug'] ?? '',
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
      'slug': slug,
      'imageUrl': imageUrl,
      'parentId': parentId,
      'isFeatured': isFeatured,
    };
  }
}
