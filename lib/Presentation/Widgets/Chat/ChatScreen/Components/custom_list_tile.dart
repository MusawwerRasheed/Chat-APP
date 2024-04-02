import 'package:chat_app/Data/DataSource/Resources/color.dart';
import 'package:chat_app/Data/DataSource/Resources/extensions.dart';
import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Domain/Models/chat_model.dart';
import 'package:chat_app/Presentation/Common/custom_text.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/Controller/chat_screen.controller.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/Controller/home_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile({
    super.key,
    required this.message,
  });

  final ChatModel message;
  final String currentUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment:
            message.senderId != FirebaseAuth.instance.currentUser!.uid
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 190),
                margin:
                    message.senderId != FirebaseAuth.instance.currentUser!.uid
                        ? EdgeInsets.only(
                            right: 120.sp, left: 5, bottom: 20, top: 15)
                        : EdgeInsets.only(
                            left: 150.sp, right: 3, bottom: 23, top: 15),
                padding: EdgeInsets.only(
                  left: 10.sp,
                  top: 8.sp,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color:
                      message.senderId == FirebaseAuth.instance.currentUser!.uid
                          ? AppColors.blue
                          : AppColors.lightGrey,
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 10.sp,
                    right: 10,
                  ),
                  child: CustomText(
                    customText: message.text!,
                    textStyle: Styles.plusJakartaSans(
                      context,
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right:
                    message.senderId == FirebaseAuth.instance.currentUser!.uid
                        ? 5
                        : null,
                left: message.senderId == FirebaseAuth.instance.currentUser!.uid
                    ? null
                    : 10,
                child: Row(
                  children: [
                    CustomText(
                        textStyle:
                            Styles.smallPlusJakartaSans(context, fontSize: 11,color: AppColors.blackColor ,  fontWeight: FontWeight.w200),
                        customText: HomeController.formatMessageSend(
                            message.timestamp!)),
                    10 .x,
                    Visibility(
                        visible: message.senderId == currentUid ? true : false,
                        child: Icon(
                          Icons.done_all,
                          color:
                              message.seen! ? AppColors.blue : AppColors.grey,
                        )),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
