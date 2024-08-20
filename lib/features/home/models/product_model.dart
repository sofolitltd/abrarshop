import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  String sku;
  String name;
  String slug;
  String description;
  double regularPrice;
  double salePrice;
  int stock;
  List<String> images;
  String category;
  String subCategory;
  String brand;
  bool isFeatured;
  Timestamp createdDate;

  ProductModel({
    required this.id,
    required this.sku,
    required this.name,
    required this.slug,
    required this.description,
    required this.regularPrice,
    required this.salePrice,
    required this.stock,
    required this.images,
    required this.category,
    required this.subCategory,
    required this.brand,
    required this.isFeatured,
    required this.createdDate,
  });

  /// empty
  static ProductModel empty() => ProductModel(
        id: '',
        sku: '',
        name: '',
        slug: '',
        description: '',
        regularPrice: 0,
        salePrice: 0,
        stock: 0,
        images: [],
        category: '',
        subCategory: '',
        brand: '',
        isFeatured: false,
        createdDate: Timestamp.now(),
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
        slug: data['slug'] ?? '',
        description: data['description'] ?? '',
        regularPrice: data['regularPrice'].toDouble() ?? 0,
        salePrice: data['salePrice'].toDouble() ?? 0,
        stock: data['stock'] ?? 0,
        images: List<String>.from(data['images'] ?? []),
        category: data['category'] ?? '',
        subCategory: data['subCategory'] ?? '',
        brand: data['brand'] ?? '',
        isFeatured: data['isFeatured'] ?? false,
        createdDate: data['createdDate'] ?? Timestamp,
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
      slug: data['slug'] ?? '',
      description: data['description'] ?? '',
      regularPrice: data['regularPrice'].toDouble() ?? 0,
      salePrice: data['salePrice'].toDouble() ?? 0,
      stock: data['stock'] ?? 0,
      images: List<String>.from(data['images'] ?? []),
      category: data['category'] ?? '',
      subCategory: data['subCategory'] ?? '',
      brand: data['brand'] ?? '',
      isFeatured: data['isFeatured'] ?? false,
      createdDate: data['createdDate'] ?? Timestamp,
    );
  }

  /// to data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'slug': slug,
      'description': description,
      'regularPrice': regularPrice,
      'salePrice': salePrice,
      'stock': stock,
      'images': images,
      'category': category,
      'subCategory': subCategory,
      'brand': brand,
      'isFeatured': isFeatured,
      'createdDate': createdDate,
    };
  }
}
