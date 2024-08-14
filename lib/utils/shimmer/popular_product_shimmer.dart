import 'package:abrar_shop/utils/shimmer/shimmer_effect.dart';
import 'package:flutter/material.dart';

class PopularProductShimmer extends StatelessWidget {
  const PopularProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: .7,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        //
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            children: [
              // image
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blueAccent.shade100.withOpacity(.5),
                  ),
                  child:
                      const KShimmerEffect(height: 300, width: 300, radius: 8),
                ),
              ),

              // name
              const Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //
                    KShimmerEffect(height: 42, width: 300, radius: 6),

                    SizedBox(height: 8),

                    // price, add to cart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.ideographic,
                      children: [
                        //
                        KShimmerEffect(height: 28, width: 64, radius: 8),

                        //
                        KShimmerEffect(height: 28, width: 28, radius: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
