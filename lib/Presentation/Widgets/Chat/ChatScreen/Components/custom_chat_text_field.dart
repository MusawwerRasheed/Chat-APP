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
        
      decoration: InputDecoration(
        hintText: 'Message',
        hintStyle: const TextStyle(
          fontSize: 15,
          color: Colors.black,
        ),
        prefixIcon: const Icon(
          Icons.face_outlined,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(45),
        ),
      ),
      controller: inputController,
    );
  }
}
