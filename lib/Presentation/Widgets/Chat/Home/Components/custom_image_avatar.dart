import 'package:chat_app/Data/DataSource/Resources/extensions.dart';
import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Common/custom_image.dart';
import 'package:chat_app/Presentation/Common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomImageAvatar extends StatelessWidget {
  const CustomImageAvatar({
    super.key,
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      child: Row(
        children: [
          user.imageUrl == ''
              ? Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: CustomText(
                      customText: user.displayName != null &&
                              user.displayName!.isNotEmpty
                          ? user.displayName![0].toUpperCase()
                          : "",
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CustomImage(
                    isAssetImage: false,
                    imageUrl: user.imageUrl,
                    width: 49.w,
                    height: 40.h,
                  ),
                ),
          15.x,
          SizedBox(
            width: 160.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  customText: user.displayName!,
                  textStyle: Styles.plusJakartaSans(
                    context,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CustomText(
                  customText: 'Latest Message'!,
                  textStyle: Styles.plusJakartaSans(
                    context,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          30.x,
        ],
      ),
    );
  }
}
