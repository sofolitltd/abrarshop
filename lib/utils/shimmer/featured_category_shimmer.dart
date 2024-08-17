import 'package:abrar_shop/utils/shimmer/shimmer_effect.dart';
import 'package:flutter/material.dart';

class FeaturedCategoryShimmer extends StatelessWidget {
  const FeaturedCategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: ListView.separated(
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(width: 4),
        itemBuilder: (context, index) {
          return const Column(
            children: [
              KShimmerEffect(height: 64, width: 64, radius: 32),
              SizedBox(height: 8),
              SizedBox(
                width: 72,
                height: 24,
                child: Center(
                  child: KShimmerEffect(
                    height: 16,
                    width: 54,
                    radius: 8,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
