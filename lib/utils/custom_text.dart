import 'package:flutter/material.dart';

class KText extends StatelessWidget {
  final String text;
  final int? maxLines;
  final TextStyle? style;

  const KText(this.text, {super.key, this.maxLines, this.style});

  @override
  Widget build(BuildContext context) {
    // Regular expression to check if the text contains only English characters
    final isEnglish = RegExp(r'^[\x00-\x7F]+$').hasMatch(text);

    // Select font family based on the text content
    final fontFamily = isEnglish ? 'Telenor' : 'HindSiliguri';

    // Use the provided style or default to the selected font
    final textStyle = style?.copyWith(fontFamily: fontFamily) ??
        TextStyle(fontFamily: fontFamily);

    return Text(
      text,
      textAlign: TextAlign.start,
      maxLines: maxLines ?? 2,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
    );
  }
}
