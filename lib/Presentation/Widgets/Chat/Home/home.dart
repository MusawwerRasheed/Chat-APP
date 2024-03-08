import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';
import 'package:chat_app/Data/DataSource/Resources/color.dart';
import 'package:chat_app/Data/DataSource/Resources/extensions.dart';
import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Presentation/Common/custom_image.dart';
import 'package:chat_app/Presentation/Common/custom_text.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Users/ChatUsersCubit/chat_users.state.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Users/ChatUsersCubit/chat_users_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/Components/custom_alert_dialog.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/Components/custom_image_avatar.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/Controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Users/UsersCubit/users_cubit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

 

class Home extends StatefulWidget {
  final User? currentUser;
  final BuildContext? context;
  final UserModel? userModel;

  Home({Key? key, this.context, this.currentUser, this.userModel})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final currentUser = FirebaseAuth.instance.currentUser;
  ValueNotifier<String> searchValueNotifier = ValueNotifier<String>('');
  TextEditingController userSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<ChatUsersCubit>().getChatUsers();
  }

  void _buildPopupMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromSize(
        Rect.fromCircle(center: Offset.zero, radius: 100), // Update this as needed
        Size(0, 0),
      ),
      items: <PopupMenuEntry>[
        const PopupMenuItem(
          child: CustomText(customText: 'logout'),
          value: 'logout',
        ),
      ],
    ).then((selectedValue) {
      if (selectedValue != null) {
        switch (selectedValue) {
          case 'logout':
            HomeController().signOut(context);
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          30.y,
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocConsumer<ChatUsersCubit, ChatUsersState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if(state is ChatUsersLoadedState){
                        return TypeAheadField<String>(
                          itemBuilder: (context, suggestion) => ListTile(
                            title: Text(suggestion),
                          ),
                          suggestionsCallback: (pattern) {
                            List<String> matches = [];
                            final chatUsersCubit = context.read<ChatUsersCubit>();
                            for (var user in state.users) {
                              if (user.displayName!.toLowerCase().startsWith(pattern.toLowerCase())) {
                                matches.add(user.displayName!);
                              }
                            }
                            return matches;
                          }, onSelected: (String value) {  },
                            
                        );

 }



                 return Container();     },
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _buildPopupMenu,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40.r),
                            child: Container(
                              height: 40.h,
                              width: 40.w,
                              color: AppColors.blackColor,
                              child: widget.currentUser?.photoURL != null
                                  ? CustomImage(
                                      isAssetImage: false,
                                      imageUrl: widget.currentUser!.photoURL!,
                                    )
                                  : Center(
                                      child: CustomText(
                                        customText: HomeController().getFirst(
                                            widget.currentUser?.email ?? 'A@'),
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    20.y,
                    CustomText(
                      customText: 'Messages',
                      textStyle: Styles.plusJakartaSans(
                        context,
                        fontSize: 20.h,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                    BlocConsumer<ChatUsersCubit, ChatUsersState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is ChatUsersLoadingState) {
                          return Center(child: const CircularProgressIndicator());
                        }
                        if (state is ChatUsersLoadedState) {
                          return Container(
                            height: 500.h,
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                final user = state.users[index];
                                return GestureDetector(
                                  onTap: () {
                                    FirestoreServices().checkChatroom(
                                      context,
                                      currentUser!.uid,
                                      user,
                                    );
                                  },
                                  child: CustomImageAvatar(user: user),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(height: 20.h);
                              },
                              itemCount: state.users.length,
                            ),
                          );
                        } else {
                          return const Center(child: CustomText(customText: 'No Messages Yet'));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void searchUsers(String value) {
    searchValueNotifier.value = userSearchController.text;
    context.read<UsersCubit>().getUsers(value);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchValueNotifier.dispose();
    userSearchController.dispose();
  }
}
