import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool? obscure;
  

  const CustomTextField({
    Key? key,
    this.obscure,
    
    required this.controller,
    required this.label,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        labelText: label,
        hintText: hintText,
      ),
      obscureText: obscure ?? false,
    );
  }







}
