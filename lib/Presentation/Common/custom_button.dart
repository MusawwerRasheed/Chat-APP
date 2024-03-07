import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? buttonFunction;
  final Color? primaryColor;
  final Color? onPrimaryColor;
  final Color? borderSideColor;

  const CustomButton({
    Key? key,
    this.borderSideColor,
    this.primaryColor,
    this.onPrimaryColor,
    required this.buttonText,
    required this.buttonFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: buttonFunction,
      style: ElevatedButton.styleFrom(
        primary: primaryColor ?? Colors.blue,
        onPrimary: onPrimaryColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: const BorderSide(color: Colors.blue),
        ),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        textStyle: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Text(buttonText),
    );
  }
}
