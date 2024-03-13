import 'package:flutter/material.dart';

class CustomChatTextField extends StatelessWidget {
  final String? hintTxt;
  final double? fontSize;
  final Color? inputColor;
  final Color? iconColor;
  final void Function(String)? onChangedFunction;

  const CustomChatTextField(
    {
      this.inputColor,
      this.onChangedFunction, 
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
        prefixIcon:  Icon(
          Icons.face_outlined,
          color: iconColor ?? Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(45),
        ),
      ),
      controller: inputController,
    );
  }
}
