import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
CustomText({
    
    super.key,
    this.overflow,
    required this.customText,
    this.textStyle,
  });
TextOverflow? overflow;
  final String customText;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return Text(
      
       customText,
       overflow: overflow?? TextOverflow.fade,
      textScaleFactor: 1, 
      style: textStyle ?? TextStyle( ),
    );
  }
}
