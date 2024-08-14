import 'package:abrar_shop/features/home/models/category_model.dart';
import 'package:flutter/material.dart';

class FeaturedCategoryDetails extends StatelessWidget {
  final CategoryModel category;
  const FeaturedCategoryDetails({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),

      // body
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.blueAccent.shade100.withOpacity(.5),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(category.imageUrl),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
