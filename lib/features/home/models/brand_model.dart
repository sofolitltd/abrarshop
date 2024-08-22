import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  String id;
  String name;
  String slug;
  String imageUrl;
  bool isFeatured;
  Timestamp createdDate;

  BrandModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.imageUrl,
    required this.isFeatured,
    required this.createdDate,
  });

  /// empty
  static BrandModel empty() => BrandModel(
        id: '',
        name: '',
        slug: '',
        imageUrl: '',
        isFeatured: false,
        createdDate: Timestamp.now(),
      );

  /// from data
  factory BrandModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      //
      return BrandModel(
        id: data['id'] ?? '',
        name: data['name'] ?? '',
        slug: data['slug'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        isFeatured: data['isFeatured'] ?? false,
        createdDate: data['createdDate'] ?? Timestamp,
      );
    } else {
      return BrandModel.empty();
    }
  }

  /// from data
  factory BrandModel.fromJson(data) {
    //
    return BrandModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      slug: data['slug'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isFeatured: data['isFeatured'] ?? false,
      createdDate: data['createdDate'] ?? Timestamp,
    );
  }

  /// to data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'imageUrl': imageUrl,
      'isFeatured': isFeatured,
      'createdDate': createdDate,
    };
  }
}
