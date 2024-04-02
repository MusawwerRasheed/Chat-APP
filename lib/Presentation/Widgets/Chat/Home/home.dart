import 'dart:math';

import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';
import 'package:chat_app/Data/DataSource/Resources/color.dart';
import 'package:chat_app/Data/DataSource/Resources/extensions.dart';
import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Presentation/Common/custom_image.dart';
import 'package:chat_app/Presentation/Common/custom_text.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatCubit/OnlineStatus/online_status_lastseen_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/Components/messages_list_tile.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/HomeMessages/HomeMessagesCubit/home_messages_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/HomeMessages/HomeMessagesCubit/home_messages_state.dart';
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
    context.read<HomeMessagesCubit>().getHomeMessages();
    context
        .read<UsersCubit>()
        .getUsers('', FirebaseAuth.instance.currentUser!.uid);
    context
        .read<OnlineStatusCubit>()
        .updateOlineStatusLastSeen(true, Timestamp.now());
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
        PopupMenuItem(
          child: CustomText(customText: 'logout'),
          value: 'logout',
        ),
      ],
    ).then((selectedValue) {
      if (selectedValue != null) {
        switch (selectedValue) {
          case 'logout':
            context
                .read<OnlineStatusCubit>()
                .updateOlineStatusLastSeen(false, Timestamp.now());

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
                                  itemBuilder: (context, suggestion) {
                                    // In your original code, you were iterating over users for each suggestion, which is incorrect.
                                    // You should directly display the suggestion passed here.
                                    if (suggestion is UserModel) {
                                      return ListTile(
                                        leading: CustomImageAvatar(
                                          isAssetImage: false,
                                          isForSearch: true,
                                          imagePath: suggestion.imageUrl,
                                        ),
                                        title: CustomText(
                                          customText: suggestion.displayName!,
                                          textStyle: Styles.plusJakartaBold(
                                              context,
                                              fontSize: 15),
                                        ),
                                      );
                                    }
                                    // Handle other cases if needed
                                    return ListTile(
                                        title: Text(suggestion.toString()));
                                  },
                                  suggestionsCallback: (pattern) {
                                    List<UserModel> matches = state.users
                                        .where((user) => user.displayName!
                                            .toLowerCase()
                                            .startsWith(pattern.toLowerCase()))
                                        .toList();
                                    return matches;
                                  },
                                  onSelected: (suggestion) {
                                    if (suggestion is UserModel) {
                                      context.read<UsersCubit>().getUsers(
                                          suggestion.displayName!,
                                          FirebaseAuth
                                              .instance.currentUser!.uid);
                                      FirestoreServices().checkChatroom(
                                        context,
                                        FirebaseAuth.instance.currentUser!.uid,
                                        suggestion.uid!,
                                      );
                                    }
                                  },
                                ),
                              );
                            } else {
                              context.read<UsersCubit>().getUsers(
                                    "",
                                    FirebaseAuth.instance.currentUser!.uid,
                                  );
                              return SizedBox(
                                width: 230,
                                child: Text('Loading...'),
                              );
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
                    30.y,
                    CustomText(
                      customText: 'Messages',
                      textStyle: Styles.plusJakartaSans(
                        context,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                    BlocBuilder<HomeMessagesCubit, HomeMessagesStates>(
                      builder: (context, state) {
                        if (state is LoadingHomeMessagesState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state is LoadedHomeMessageSate) {
                          // print('home messages loaded');

                          return Container(
                            height: 500,
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                final homeMessage = state.homeMessages[index];

                                // //  print(' Testing >>>>> ');
                                //  print(homeMessage.lastSeen);
                                //  print(homeMessage.lastMessage);
                                return GestureDetector(
                                  onTap: () {
                                    FirestoreServices().checkChatroom(
                                      context,
                                      FirebaseAuth.instance.currentUser!.uid,
                                      homeMessage.uid!,
                                    );
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: AppColors.white,
                                          boxShadow: [
                                            BoxShadow(
                                                offset:
                                                    Offset.fromDirection(9, 0),
                                                spreadRadius: 0.1,
                                                blurRadius: 1,
                                                color: AppColors.grey),
                                          ],
                                        ),
                                        height: 80,
                                        width: 320,
                                        child: MessagesListTile(
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CustomImageAvatar(
                                              imagePath: homeMessage.imageUrl,
                                              isAssetImage: false,
                                              isForSearch: false,
                                            ),
                                          ),
                                          title: CustomText(
                                              customText:
                                                  homeMessage.displayName!),
                                          subTitle: Row(
                                            children: [
                                              Visibility(
                                                visible: homeMessage.senderId ==
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                    ? true
                                                    : false,
                                                child: Icon(
                                                  Icons.done_all_rounded,
                                                  color:
                                                      homeMessage.seen == true
                                                          ? AppColors.blue
                                                          : AppColors.grey,
                                                ),
                                              ),
                                              10.x,
                                              CustomText(overflow: TextOverflow.ellipsis,
                                                  customText: homeMessage
                                                              .latestMessageType ==
                                                          'text'
                                                      ? homeMessage
                                                              .lastMessage ??
                                                          'asd'
                                                      : 'image'),
                                            ],
                                          ),
                                          trailing: Column(
                                            children: [
                                              CustomText(
                                                  customText: HomeController
                                                          .formatMessageSend(
                                                              homeMessage
                                                                      .timestamp ??
                                                                  Timestamp
                                                                      .now()) ??
                                                      ''),
                                              10.y,
                                              homeMessage.isOnline == true
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: Container(
                                                        height: 10,
                                                        width: 10,
                                                        color:
                                                            Colors.green[300],
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40),
                                                      child: Container(
                                                        height: 10,
                                                        width: 10,
                                                        color: AppColors.grey,
                                                      ),
                                                    ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 20);
                              },
                              itemCount: state.homeMessages.length,
                            ),
                          );
                        } else {
                          return  Center(
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
