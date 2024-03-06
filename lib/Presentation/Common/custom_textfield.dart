import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool? obscure;
  final String? Function(String?)? validatorValue;

  const CustomTextField({
    Key? key,
    this.obscure,
    this.validatorValue,
    required this.controller,
    required this.label,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validatorValue,
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
