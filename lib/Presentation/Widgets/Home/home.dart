import 'dart:developer';
import 'package:chat_app/Application/Services/AppLifeCycleObserver/app_life_cycles.dart';
import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';
import 'package:chat_app/Data/DataSource/Resources/color.dart';
import 'package:chat_app/Data/DataSource/Resources/extensions.dart';
import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Data/Repository/HomeMessagesRepository/home_messages_repository.dart';
import 'package:chat_app/Domain/Models/home_messages_model.dart';
import 'package:chat_app/Presentation/Common/custom_image.dart';
import 'package:chat_app/Presentation/Common/custom_text.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/Controller/OnlineStatus/online_status_lastseen_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Home/Components/UsersSearchBar/Controller/Users/Controller/users_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Home/Components/UsersSearchBar/Controller/Users/Controller/users_state.dart';
import 'package:chat_app/Presentation/Widgets/Home/Components/custom_image_avatar.dart';
import 'package:chat_app/Presentation/Widgets/Home/Components/messages_list_tile.dart';
import 'package:chat_app/Presentation/Widgets/Home/Controller/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
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
  HomeMessagesRepository homeMessasges = HomeMessagesRepository();

  @override
  void initState() {
    super.initState();
    homeMessasges.getHomeMessages();

    AppLifecycleObserver appLifecycleObserver =
        AppLifecycleObserver(context: context);
    currentUser = FirebaseAuth.instance.currentUser;
    searchValueNotifier = ValueNotifier<String>('');
    userSearchController = TextEditingController();

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
          const SizedBox(height: 30),
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
                              return const SizedBox(
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
                    ValueListenableBuilder<List<HomeMessagesModel>>(
                      valueListenable: homeMessasges.homeMessageNotifier,
                      builder: (context, homeMessages, _) {
                        if (homeMessages.isEmpty) {
                          return Center(
                            child: CustomText(customText: 'No Messages Yet'),
                          );
                        }

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  HomeMessagesModel homeMessage =
                                      homeMessages[index]; 
                                      
                                      // log(homeMessage.count.toString()+ '    '+'count');
                                      // log(homeMessage.isOnline.toString()+ '    '+'isOnline');
                                      // log(homeMessage.isTyping.toString()+ '    '+'istyping');
                                      // log(homeMessage.seen.toString()+ '    '+'seen');
                                      // log(homeMessage.timestamp.toString()+ '    '+'time stamp');
                                      // log(homeMessage.chatUid.toString()+ '    '+'chatuid');
                                      // log(homeMessage.chatroomId.toString()+ '    '+'chatroomId');
                                      // log(homeMessage.displayName.toString()+ '    '+'displayName');
                                      // log(homeMessage.email.toString()+ '    '+'email');
                                      // log(homeMessage.lastMessage.toString()+ '    '+' last message');
                                      // log(homeMessage.latestMessageType.toString()+ '    '+'latest message type');
                                      // log(homeMessage.senderId.toString()+ '    '+'sender id');
                                      // log(homeMessage.text.toString()+ '    '+'text');
                                      // log(homeMessage.type.toString()+ '    '+'type');
                                      // log(homeMessage.uid.toString()+ '    '+'uid');
                                      
                                  bool isCurrentUserMessage = homeMessage
                                          .senderId ==
                                      FirebaseAuth.instance.currentUser!.uid;

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
                                                color: AppColors.grey,
                                              ),
                                            ],
                                          ),
                                          height: 80,
                                          width: 330,
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
                                            title: Row(
                                              children: [
                                                CustomText(
                                                  textStyle:
                                                      Styles.plusJakartaBold(
                                                    context,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                  customText:
                                                      homeMessage.displayName!,
                                                ),
                                                SizedBox(width: 7),
                                                if (homeMessage.isOnline ==
                                                    true)
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Container(
                                                      height: 10,
                                                      width: 10,
                                                      color: Colors.green[300],
                                                    ),
                                                  )
                                                else
                                                  ClipRRect(
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
                                            subTitle: Row(
                                              children: [
                                                Visibility(
                                                  visible: isCurrentUserMessage,
                                                  child: Icon(
                                                    Icons.done_all_rounded,
                                                    color:
                                                        homeMessage.seen == true
                                                            ? AppColors.blue
                                                            : AppColors.grey,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                SizedBox(
                                                  width: 120,
                                                  child: CustomText(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      customText:
                                                          homeMessage.text!),
                                                ),
                                              ],
                                            ),
                                            trailing: Column(
                                              children: [
                                                CustomText(
                                                  customText: HomeController
                                                          .formatMessageSend(
                                                        homeMessage.timestamp ??
                                                            Timestamp.now(),
                                                      ) ??
                                                      '',
                                                ),
                                                SizedBox(height: 10),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Visibility(
                                                    visible:
                                                        false, // Replace with your logic
                                                    child: Container(
                                                      child: Center(
                                                        child: CustomText(
                                                          customText: '2',
                                                          textStyle: Styles
                                                              .largePlusJakartaSans(
                                                            context,
                                                            color:
                                                                AppColors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ),
                                                      height: 20,
                                                      width: 20,
                                                      color: Colors.blueAccent,
                                                    ),
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
                                  return SizedBox(height: 20);
                                },
                                itemCount: homeMessages.length,
                              ),
                            ],
                          ),
                        );
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
    homeMessasges.homeMessageNotifier.dispose();
  }
}
