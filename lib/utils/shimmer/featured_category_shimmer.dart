import 'package:abrar_shop/utils/shimmer/shimmer_effect.dart';
import 'package:flutter/material.dart';

class FeaturedCategoryShimmer extends StatelessWidget {
  const FeaturedCategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 4),
        itemBuilder: (context, index) {
          return const SizedBox(
            width: 72,
            child: Column(
              children: [
                KShimmerEffect(height: 56, width: 56, radius: 100),
                SizedBox(height: 8),
                KShimmerEffect(
                  height: 16,
                  width: 54,
                  radius: 8,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
