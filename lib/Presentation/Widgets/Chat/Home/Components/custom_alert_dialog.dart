import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';
import 'package:chat_app/Data/DataSource/Resources/extensions.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Common/custom_image.dart';
import 'package:chat_app/Presentation/Common/custom_text.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Users/UsersCubit/users_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Users/UsersCubit/users_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 200.h,
        width: 200.w,
        child: BlocConsumer<UsersCubit, UsersState>(
          builder: (context, state) {
            if (state is UsersLoadedState) {
              return ListView.builder(
                itemCount: state.users.length,
                itemBuilder: (context, index) {
                  final UserModel user = state.users[index];
                  print(FirebaseAuth.instance.currentUser!.uid);
                  return GestureDetector(
                    onTap: () {
                      FirestoreServices().checkChatroom(context,
                          FirebaseAuth.instance.currentUser!.uid, user);
                    },
                    child: ListTile(
                      title: Row(
                        children: [
                          user.imageUrl == ''
                              ? Container(
                                  width: 30.w,
                                  height: 30.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Center(
                                      child: CustomText(
                                    customText: user.displayName != null &&
                                            user.displayName!.isNotEmpty
                                        ? user.displayName![0].toUpperCase()
                                        : "",
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CustomImage(
                                    isAssetImage: false,
                                    imageUrl: user.imageUrl!,
                                    width: 30.w,
                                    height: 30.h,
                                  )),
                          6.x, 
                          CustomText(customText: user.displayName ?? ''),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
          listener: (BuildContext context, UsersState state) {},
        ),
      ),
    );
  }
}
