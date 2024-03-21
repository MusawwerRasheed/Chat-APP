import 'package:chat_app/Data/DataSource/Resources/extensions.dart';
import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Common/custom_image.dart';
import 'package:chat_app/Presentation/Common/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomImageAvatar extends StatelessWidget {
  final bool? isForSearch;
  const CustomImageAvatar({
    super.key,
    required this.user,
    this.isForSearch,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        user.imageUrl == ''
            ? Container(
                width: isForSearch == true ? 30 : 50.w,
                height: isForSearch == true ? 30 : 50.h,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: CustomText(
                    customText:
                        user.displayName != null && user.displayName!.isNotEmpty
                            ? user.displayName![0].toUpperCase()
                            : "",
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: isForSearch == true ? 10 : 17,
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
                  width: isForSearch! ? 30 : 53.w,
                  height: isForSearch == true ? 30 : 53.h,
                ),
              ),
        10.x,
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              customText: user.displayName!,
              textStyle: Styles.plusJakartaSans(
                context,
                fontSize: isForSearch == true ? 13 : 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            isForSearch == false
                ? CustomText(
                    customText: '',
                    textStyle: Styles.plusJakartaSans(
                      context,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }
}
