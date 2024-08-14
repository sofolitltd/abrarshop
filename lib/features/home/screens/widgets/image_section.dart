//
import 'package:flutter/material.dart';

class ImageSection extends StatefulWidget {
  const ImageSection({super.key, required this.images});

  final List images;

  @override
  State<ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          //
          Image.network(
            widget.images.isEmpty
                ? 'https://firebasestorage.googleapis.com/v0/b/abrar-shop.appspot.com/o/placeholder.png?alt=media&token=dc5ea06a-d65d-4689-9196-329781aef7d6'
                : widget.images[selectedImage],
            fit: BoxFit.cover,
          ),

          //
          Container(
            height: 64,
            margin: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const SizedBox(width: 10);
              },
              shrinkWrap: true,
              itemCount: widget.images.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    selectedImage = index;
                    setState(() {});
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedImage == index
                            ? Colors.blueAccent
                            : Colors.white,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(1, 1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          color: Colors.black12,
                        )
                      ],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          widget.images[index],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
