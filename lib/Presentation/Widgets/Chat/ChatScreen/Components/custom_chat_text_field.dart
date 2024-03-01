import 'package:flutter/material.dart';

class CustomChatTextField extends StatelessWidget {
  const CustomChatTextField({
    super.key,
    required this.inputController,
  });

  final TextEditingController inputController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Message',
        hintStyle: TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
        prefixIcon: Icon(
          Icons.face_outlined,
          color: Colors.grey,
        ),
        border: InputBorder.none,
      ),
      controller: inputController,
    );
  }
}