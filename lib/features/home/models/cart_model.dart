import 'package:cloud_firestore/cloud_firestore.dart';

class CartItemModel {
  String id;
  String name;
  double price;
  String imageUrl;
  int quantity;

  CartItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  /// empty
  static CartItemModel empty() =>
      CartItemModel(id: '', name: '', price: 0, imageUrl: '', quantity: 0);

  /// from data
  factory CartItemModel.fromJson(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      //
      return CartItemModel(
        id: document.id,
        name: data['name'] ?? '',
        price: data['price'] ?? '',
        imageUrl: data['imageUrl'] ?? '',
        quantity: data['quantity'] ?? false,
      );
    } else {
      return CartItemModel.empty();
    }
  }

  /// to data
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }
}
