import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? buttonFunction;

  const CustomButton({
    Key? key,
    required this.buttonText,
    required this.buttonFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: buttonFunction,
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, // Background color
        onPrimary: Colors.white, // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0), // Rounded corners
          side: const BorderSide(color: Colors.blue), // Border color
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(buttonText),
    );
  }
}
