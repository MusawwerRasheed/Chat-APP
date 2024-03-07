import 'package:chat_app/Data/DataSource/Resources/color.dart';
import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Domain/Models/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.message,
  });

  final ChatModel message;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment:
            message.senderId == FirebaseAuth.instance.currentUser!.uid
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 190),
            margin: message.senderId == FirebaseAuth.instance.currentUser!.uid
                ? EdgeInsets.only(right: 120.sp)
                : EdgeInsets.only(left: 150.sp),
            padding: EdgeInsets.only(left: 10.sp, top: 8.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: message.senderId == FirebaseAuth.instance.currentUser!.uid
                  ? AppColors.blue
                  : AppColors.lightGrey,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 10.sp,
                right: 10,
              ),
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
        ],
      ),
    );
  }
}
