import 'package:flutter/material.dart';

class Validate {
  bool isEmailValid(String email) {
    RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  

  static String? password(v) {
    if (v.trim().isEmpty) {
      return "Please provide password";
    }
    if (v.length < 6) {
      return "Must be greater than 6";
    }
    return null;
  }
}
