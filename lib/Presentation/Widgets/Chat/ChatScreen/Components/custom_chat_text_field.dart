import 'package:flutter/material.dart';

 class CustomChatTextField extends StatelessWidget {
  final String? hintTxt;
  final double? fontSize;
  final Widget? prefix;
  final Color? inputColor;
  final Widget? suffix;
  final Color? iconColor;
  final Function()? suffixFunction;
  final void Function(String)? onChangedFunction;
  final TextEditingController inputController;

  const CustomChatTextField({
    Key? key,
    this.inputColor,
    this.suffixFunction,
    this.suffix,
    this.onChangedFunction,
    this.prefix,
    this.fontSize,
    this.iconColor,
    this.hintTxt,
    required this.inputController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45),
        border: Border.all(color: Colors.grey), // Add border decoration
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
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
                  child: suffix,
                ),
                border: InputBorder.none,  
              ),
              controller: inputController,
            ),
          ),
        ],
      ),
    );
  }
}