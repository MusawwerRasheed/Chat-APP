import 'package:chat_app/Data/DataSource/Resources/color.dart';
import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Domain/Models/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomListTIle extends StatelessWidget {
  const CustomListTIle({
    super.key,
    required this.message,
  });

  final ChatModel message;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Container(
        margin: message.senderId ==
                FirebaseAuth.instance.currentUser!.uid
            ? EdgeInsets.only(right: 120)
            : EdgeInsets.only(left: 120),
        padding: EdgeInsets.only(left: 10, top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: message.senderId ==
                  FirebaseAuth.instance.currentUser!.uid
              ? AppColors.blue
              : AppColors.grey,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            message.text!,
            style: Styles.plusJakartaSans(
              context,
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}