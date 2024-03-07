import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
   
  const CustomText({
    super.key,
    required this.customText,
  });

  final String customText;

  @override
  Widget build(BuildContext context) {
    return Text(customText);
  }
}
