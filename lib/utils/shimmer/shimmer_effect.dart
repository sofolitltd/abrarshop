import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class KShimmerEffect extends StatelessWidget {
  final double height, width, radius;

  const KShimmerEffect({
    super.key,
    required this.height,
    required this.width,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade400,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
