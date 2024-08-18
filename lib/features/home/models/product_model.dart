import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  String sku;
  String name;
  String description;
  double regularPrice;
  double salePrice;
  int stockQuantity;
  List<String> images;
  String categoryId;
  String subCategoryId;
  String brandId;
  bool isFeatured;

  ProductModel({
    required this.id,
    required this.sku,
    required this.name,
    required this.description,
    required this.regularPrice,
    required this.salePrice,
    required this.stockQuantity,
    required this.images,
    required this.categoryId,
    required this.subCategoryId,
    required this.brandId,
    required this.isFeatured,
  });

  /// empty
  static ProductModel empty() => ProductModel(
        id: '',
        sku: '',
        name: '',
        description: '',
        regularPrice: 0,
        salePrice: 0,
        stockQuantity: 0,
        images: [],
        categoryId: '',
        subCategoryId: '',
        brandId: '',
        isFeatured: false,
      );

  /// from data
  factory ProductModel.fromJson(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      //
      return ProductModel(
        id: data['id'] ?? '',
        sku: data['sku'] ?? '',
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        regularPrice: data['regularPrice'].toDouble() ?? 0,
        salePrice: data['salePrice'].toDouble() ?? 0,
        stockQuantity: data['stockQuantity'] ?? 0,
        images: List<String>.from(data['images'] ?? []),
        categoryId: data['categoryId'] ?? '',
        subCategoryId: data['subCategoryId'] ?? '',
        brandId: data['brandId'] ?? '',
        isFeatured: data['isFeatured'] ?? false,
      );
    } else {
      return ProductModel.empty();
    }
  }

  /// from data
  factory ProductModel.fromQuerySnapshot(
      QueryDocumentSnapshot<Object?> document) {
    final data = document.data() as Map<String, dynamic>;
    //
    return ProductModel(
      id: data['id'] ?? '',
      sku: data['sku'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      regularPrice: data['regularPrice'].toDouble() ?? 0,
      salePrice: data['salePrice'].toDouble() ?? 0,
      stockQuantity: data['stockQuantity'] ?? 0,
      images: List<String>.from(data['images'] ?? []),
      categoryId: data['categoryId'] ?? '',
      subCategoryId: data['subCategoryId'] ?? '',
      brandId: data['brandId'] ?? '',
      isFeatured: data['isFeatured'] ?? false,
    );
  }

  /// to data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'description': description,
      'regularPrice': regularPrice,
      'salePrice': salePrice,
      'stockQuantity': stockQuantity,
      'images': images,
      'categoryId': categoryId,
      'subCategoryId': subCategoryId,
      'brandId': brandId,
      'isFeatured': isFeatured,
    };
  }
}
