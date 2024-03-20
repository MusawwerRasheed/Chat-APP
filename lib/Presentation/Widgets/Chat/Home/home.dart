import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';
import 'package:chat_app/Data/DataSource/Resources/color.dart';
import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Presentation/Common/custom_image.dart';
import 'package:chat_app/Presentation/Common/custom_text.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatCubit/online_status_lastseen_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Users/ChatUsersCubit/chat_users.state.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Users/ChatUsersCubit/chat_users_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/Components/custom_image_avatar.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/Controller/home_controller.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Users/UsersCubit/users_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Users/UsersCubit/users_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
 

class Home extends StatefulWidget {
  final User? currentUser;
  final UserModel? userModel;

  Home({Key? key, this.currentUser, this.userModel}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final User? currentUser;
  late final ValueNotifier<String> searchValueNotifier;
  late final TextEditingController userSearchController;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    searchValueNotifier = ValueNotifier<String>('');
    userSearchController = TextEditingController();
    context.read<ChatUsersCubit>().getChatUsers();
    context.read<UsersCubit>().getUsers('', FirebaseAuth.instance.currentUser!.uid);
    context.read<OnlineStatusCubit>().updateOlineStatusLastSeen(true, Timestamp.now());
  }
 
   
  buildPopupMenu() {
    showMenu(
      context: context,
      position: RelativeRect.fromDirectional(
          textDirection: TextDirection.ltr,
          start: 200,
          top: 100,
          end: 50,
          bottom: 50),
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
            context.read<OnlineStatusCubit>().updateOlineStatusLastSeen(false, Timestamp.now());
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
          SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        BlocBuilder<UsersCubit, UsersState>(
                          builder: (context, state) {
                            if (state is UsersLoadedState) {
                              return Container(
                                width: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 1.6,
                                  ),
                                ),
                                child: TypeAheadField(
                                  autoFlipDirection: false,
                                  debounceDuration:
                                      const Duration(milliseconds: 500),
                                  itemBuilder: (context, suggestion) =>
                                      ListTile(
                                    leading: SizedBox(
                                      width: 200,
                                      height: 100,
                                      child: CustomImageAvatar(
                                        isForSearch: true,
                                        user: state.users.firstWhere(
                                          (user) =>
                                              user.displayName == suggestion,
                                        ),
                                      ),
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    List<String> matches = [];
                                    for (var user in state.users) {
                                      if (user.displayName!
                                          .toLowerCase()
                                          .startsWith(pattern.toLowerCase())) {
                                        matches.add(user.displayName!);
                                      }
                                    }
                                    return matches;
                                  },
                                  onSelected: (String value) {
                                    context.read<UsersCubit>().getUsers(value, FirebaseAuth.instance.currentUser!.uid);
                                    var selectedUser = state.users.firstWhere(
                                      (user) => user.displayName == value,
                                    );
                                    if (selectedUser != null) {
                                      FirestoreServices().checkChatroom(
                                        context,
                                        FirebaseAuth.instance.currentUser!.uid,
                                        selectedUser,
                                      );
                                    }
                                  },
                                ),
                              );
                            } else {
                              context.read<UsersCubit>().getUsers("", FirebaseAuth.instance.currentUser!.uid);
                              return  SizedBox(
                                  width: 230.w,
                                   child: Text('loading... '));
                            }
                          },
                        ),
                        const SizedBox(width: 40),
                        GestureDetector(
                          onTap: buildPopupMenu,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Container(
                              height: 40,
                              width: 40,
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
                    const SizedBox(height: 10),
                    const SizedBox(height: 20),
                    CustomText(
                      customText: 'Messages',
                      textStyle: Styles.plusJakartaSans(
                        context,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                    BlocBuilder<ChatUsersCubit, ChatUsersState>(
                      builder: (context, state) {
                        if (state is ChatUsersLoadingState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state is ChatUsersLoadedState) {
                          return Container(
                            height: 500,
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
                                  child: CustomImageAvatar(
                                    user: user,
                                    isForSearch: false,
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(height: 20);
                              },
                              itemCount: state.users.length,
                            ),
                          );
                        } else {
                          return const Center(
                              child: CustomText(customText: 'No Messages Yet'));
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



  @override
  void dispose() {
    super.dispose();
    searchValueNotifier.dispose();
    userSearchController.dispose();
  }
}
