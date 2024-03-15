import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.customText,
    this.textStyle,
  });

  final String customText;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return Text(
       customText,
      textScaleFactor: 1, 
      style: textStyle,
    );
  }
}
