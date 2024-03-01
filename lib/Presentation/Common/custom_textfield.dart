import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool? obscure;
  final String? Function(String?)? validator;
  final bool? isValid;
  final String? validateText;

  const CustomTextField({
    Key? key,
    this.obscure,
    this.validator,
    this.validateText,
    required this.isValid,
    required this.controller,
    required this.label,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (v) {
        if (isValid == true && (v == null || v.trim().isEmpty)) {
          return validateText;
        }
        return validator?.call(v);
      },
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
