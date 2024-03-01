import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
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
              ? 
              Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.blue, // You can set any desired color
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      user.displayName != null && user.displayName!.isNotEmpty
                          ? user.displayName![0].toUpperCase()
                          : "",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ):
              
              
               ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    user.imageUrl!,
                    width: 40.w,
                    height: 40.h,
                  ),
               ), 
          const SizedBox(
            width: 15,
          ),
          SizedBox(
            width: 160.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName!,
                  style: Styles.plusJakartaSans(
                    context,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Latest Message'!,
                  style: Styles.plusJakartaSans(
                    context,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 60,
          ),
        ],
      ),
    );
  }
}
