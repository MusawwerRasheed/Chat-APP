import 'package:flutter/material.dart';

class CustomChatTextField extends StatelessWidget {
  final String? hintTxt;
  final double? fontSize;
  final Widget? prefix;
  final Color? inputColor;
  final Widget? suffix;
  final Color? iconColor;
  final  Function()? suffixFunction;
  final void Function(String)? onChangedFunction;

  const CustomChatTextField(
      {this.inputColor,
      this.suffixFunction, 
      this.suffix,
      this.onChangedFunction,
      this.prefix,
      this.fontSize,
      this.iconColor,
      this.hintTxt,
      super.key,
      required this.inputController});

  final TextEditingController inputController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChangedFunction,
      decoration: InputDecoration(
        hintText: hintTxt ?? 'Message',
        hintStyle: TextStyle(
          fontSize: fontSize ?? 15,
          color: inputColor ?? Colors.black,
        ),
        prefixIcon: prefix ??
            Icon(
              Icons.face_outlined,
              color: iconColor ?? Colors.grey,
            ),
        suffixIcon: GestureDetector(
          onTap: suffixFunction,
          child: suffix) ,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(45),
        ),
      ),
      controller: inputController,
    );
  }
}
