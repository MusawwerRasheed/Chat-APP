import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color.dart';

class Styles {
  static TextStyle largePlusJakartaSans(BuildContext context,
      {double? fontSize,
      final TextAlign? textAlign,
      Color? color,
      FontWeight? fontWeight,
      double? letterSpacing}) {
    return TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: (fontSize ?? 28.0.sp),
        letterSpacing: letterSpacing ?? 0,
        color: color ?? AppColors.blackColor,
        fontFamily: "Plus Jakarta Sans",
        fontWeight: fontWeight ?? FontWeight.w700);
  }

  static TextStyle mediumPlusJakartaSans(BuildContext context,
      {double? fontSize,
      Color? color,
      final TextAlign? textAlign,
      FontWeight? fontWeight,
      double? letterSpacing}) {
    return TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: (fontSize ?? 16.0.sp),
        letterSpacing: letterSpacing ?? 0,
        color: color ?? AppColors.blackColor,
        fontFamily: "Plus Jakarta Sans",
        
        fontWeight: fontWeight ?? FontWeight.w500);
  }

  static TextStyle smallPlusJakartaSans(BuildContext context,
      {double? fontSize,
      Color? color,
      final TextAlign? textAlign,
      FontWeight? fontWeight,
      double? letterSpacing}) {
    return TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: (fontSize ?? 14.0.sp),
        letterSpacing: letterSpacing ?? 0,
        color: color ?? AppColors.blackColor,
        fontFamily: "Plus Jakarta Sans",
        fontWeight: fontWeight ?? FontWeight.w400);
  }

  static TextStyle plusJakartaSans(BuildContext context,
      {double? fontSize,
      Color? color,
      final TextAlign? textAlign,
      FontWeight? fontWeight,
      double? letterSpacing}) {
    return TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: (fontSize ?? 16.0.sp),
        letterSpacing: letterSpacing ?? 0,
        color: color ?? AppColors.blackColor,
        fontFamily: "Plus Jakarta Sans",
        fontWeight: fontWeight ?? FontWeight.w600);
  }

  static TextStyle plusJakartaBold(BuildContext context,
      {double? fontSize,
      Color? color,
      final TextAlign? textAlign,
      FontStyle? fontStyle,
      double height = 1.4,
      FontWeight fontWeight = FontWeight.bold,
      double? letterSpacing}) {
    return TextStyle(
        letterSpacing: letterSpacing ?? 0,
        fontSize: (fontSize ?? 14.0.sp),
        color: color ?? AppColors.blackColor,
        fontFamily: "plus jakarta bold",
        height: height,
        fontStyle: fontStyle,
        fontWeight: fontWeight);
  }
}