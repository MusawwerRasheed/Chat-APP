import 'package:flutter/material.dart';

class Validate {
  bool validateSignUp(BuildContext? context, String? fullNameController,
      String? emailController, String? passwordController) {
    if (fullNameController!.isEmpty ||
        emailController!.isEmpty ||
        passwordController!.isEmpty) {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar( 
          backgroundColor:Colors.redAccent, 
            content: Text('Please fill in all fields')),
      );
      return false;
    }

    if (passwordController.length < 6) {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(
           backgroundColor: Colors.redAccent,
            content: Text('Password should be at least 6 characters')),
      );
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController)) {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar( 

          backgroundColor:Colors.redAccent, 
            content: Text('Please enter a valid email')),
      );
      return false;
    }

    return true;
  }

  bool validateLogin(BuildContext? context, String? emailController,
      String? passwordController) {
    if (emailController!.isEmpty || passwordController!.isEmpty) {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
         backgroundColor:Colors.redAccent, 
        ),
      );
      return false;
    }

    if (passwordController.length < 6) {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(
          backgroundColor:Colors.redAccent,
            content: Text('Password should be at least 6 characters')),
      );
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(emailController)) {
      ScaffoldMessenger.of(context!).showSnackBar(
        const SnackBar(
         backgroundColor:Colors.redAccent, 
            content: Text('Please enter a valid email')),
      );
      return false;
    }

    return true;
  }
}
