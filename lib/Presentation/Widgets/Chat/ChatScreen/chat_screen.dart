import 'dart:async';
import 'dart:io';
import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';
import 'package:chat_app/Data/DataSource/Resources/extensions.dart';
import 'package:chat_app/Data/Repository/ChatRepository/chat_repository.dart';
import 'package:chat_app/Data/DataSource/Resources/color.dart';
import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Data/Repository/ChatRepository/is_typing_repository.dart';
import 'package:chat_app/Data/Repository/OnlineStatusRepository/online_status_repo.dart';
import 'package:chat_app/Domain/Models/chat_model.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Common/custom_image.dart';
import 'package:chat_app/Presentation/Common/custom_text.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/Components/custom_chat_text_field.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/Components/custom_list_tile.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/Controller/chat_screen.controller.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/Components/custom_appbar.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Users/ChatUsersCubit/chat_users_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  final String? chatRoomId;
  final UserModel? otherUser;

  ChatScreen({
    Key? key,
    this.chatRoomId,
    this.otherUser,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  TextEditingController inputController = TextEditingController();
  ValueNotifier<bool> isStreamEmpty = ValueNotifier<bool>(false);
  ValueNotifier<List<ChatModel>> chatMessagesNotifier =
      ValueNotifier<List<ChatModel>>([]);
  ScrollController scrollController = ScrollController();
  late ValueNotifier<bool> isTypingNotifier;
  late ValueNotifier<String> lastSeenNotifier;
  late ValueNotifier<bool> onlineStatusNotifier;
  late StreamSubscription<bool> typingSubscription;
  late StreamSubscription<bool> onlineStatusSubscription;
  late StreamSubscription<String> lastSeenSubscription;
  // List<String> imagespaths = [];
  List<String> imagePaths = [];
  List<Widget> widgetsList = [];
  @override
  void initState() {
    super.initState();
    initChatStream();
    print(widget.chatRoomId);

    isTypingNotifier = ValueNotifier<bool>(false);
    onlineStatusNotifier = ValueNotifier<bool>(false);
    lastSeenNotifier = ValueNotifier<String>('');
    typingSubscription = IsTypingRepository()
        .typingStream(widget.otherUser!.uid!)
        .listen((event) {
      isTypingNotifier.value = event;
    });

    onlineStatusSubscription = OnlineStatusRepo()
        .onlineStatusStream(widget.otherUser!.uid!)
        .listen((event) {
      onlineStatusNotifier.value = event;
    });

    lastSeenSubscription = OnlineStatusRepo()
        .lastSeenStream(widget.otherUser!.uid!)
        .listen((event) {
      lastSeenNotifier.value = event;
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.minScrollExtent) {
        setState(() {
          isBottomContainerVisible = false;
        });
      } else {
        setState(() {
          isBottomContainerVisible = true;
        });
      }
    });
  }

  bool isBottomContainerVisible = false;

  void initChatStream() async {
    try {
      final chatStream = ChatRepository().getChat(widget.chatRoomId!);
      chatStream.listen((chatMessages) {
        chatMessagesNotifier.value = chatMessages;
        if (chatMessagesNotifier.value.isEmpty) {
          isStreamEmpty.value = true;
        } else {
          isStreamEmpty.value = false;
        }
      });
    } catch (e) {
      print('Error initializing chat stream: $e');
    }
  }

  void updateTypingStatus(bool isTyping) {
    IsTypingRepository()
        .updateTypingStatus(FirebaseAuth.instance.currentUser!.uid, isTyping);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppbar(
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                widget.otherUser!.imageUrl == ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          color: Colors.blue[400],
                          width: 32,
                          height: 32,
                          child: Center(
                              child: CustomText(
                            customText: widget.otherUser!.displayName != null &&
                                    widget.otherUser!.displayName!.isNotEmpty
                                ? widget.otherUser!.displayName![0]
                                    .toUpperCase()
                                : "",
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          width: 40,
                          height: 40,
                          color: AppColors.blackColor,
                          child: CustomImage(
                            isAssetImage: false,
                            imageUrl: widget.otherUser!.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                5.x,
                Container(
                  width: 40,
                  child: CustomText(
                    customText: widget.otherUser!.displayName!.trim(),
                    textStyle: Styles.plusJakartaSans(context),
                  ),
                ),
                onlineStatusNotifier.value == true
                    ? ValueListenableBuilder<bool>(
                        valueListenable: onlineStatusNotifier,
                        builder: (context, online, _) {
                          return online
                              ? Container(
                                  margin: EdgeInsets.only(right: 4),
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      color: AppColors.Green,
                                      borderRadius: BorderRadius.circular(50)),
                                )
                              : const SizedBox.shrink();
                        },
                      )
                    : ValueListenableBuilder<String>(
                        valueListenable: lastSeenNotifier,
                        builder: (context, lastSeen, _) {
                          return CustomText(
                            customText: lastSeen,
                            textStyle: Styles.smallPlusJakartaSans(context,
                                fontSize: 12),
                          );
                        },
                      ),
              ],
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isTypingNotifier,
              builder: (context, typing, _) {
                return typing
                    ? CustomText(
                        customText: 'Typing •••',
                        textStyle: Styles.plusJakartaSans(context,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.blackColor),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ValueListenableBuilder<List<ChatModel>>(
                  valueListenable: chatMessagesNotifier,
                  builder: (context, chatMessages, _) {
                    return ListView.builder(
                      controller: scrollController,
                      reverse: true,
                      itemCount: chatMessages.length,
                      itemBuilder: (context, index) {
                        var message = chatMessages[index];
                        return Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 5),
                          child: CustomListTile(message: message),
                        );
                      },
                    );
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10, bottom: 20),
                      height: 51.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent!,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomChatTextField(
                        onChangedFunction: (text) {
                          if (text.isNotEmpty) {
                            updateTypingStatus(true);
                          } else {
                            updateTypingStatus(false);
                          }
                        },
                        inputColor: Colors.black,
                        fontSize: 12,
                        iconColor: Colors.grey,
                        suffix:
                            const Icon(Icons.image, color: AppColors.lightGrey),
                        suffixFunction: () async {
                          // Call pickImages and wait for the result
                          List<String> newImagePaths =
                              await ChatScreenController().pickImages(context);

                          // Add the new paths to the existing list
                          imagePaths.addAll(newImagePaths);

                          // Show the AlertDialog with the updated image paths
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Container(
                                  height: 200,
                                  width: 200,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      for (String path in imagePaths)
                                        Builder(
                                          builder: (BuildContext context) {
                                            print(
                                                'Trying to load image: $path');
                                            return Image.file(File(path));
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );

                          // Clear the list for the next use
                          setState(() {
                            imagePaths = [];
                          });
                        },
                        inputController: inputController,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (inputController.text.isNotEmpty) {
                        FirestoreServices().sendMessage(
                          widget.chatRoomId,
                          inputController.text,
                          widget.otherUser?.uid,
                          context,
                          isStreamEmpty.value,
                        );
                        context.read<ChatUsersCubit>().getChatUsers();
                        initChatStream();
                        inputController.clear();
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          bottom: 20, left: 10, right: 10),
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppColors.blue,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 500,
            left: 280,
            child: GestureDetector(
              onTap: () {
                // ChatScreenController().scrollToBottom();
              },
              child: Visibility(
                visible: isBottomContainerVisible,
                child: Container(
                  color: Colors.transparent,
                  height: 50,
                  width: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    height: 25,
                    width: 25,
                    child: const Icon(
                      Icons.arrow_downward,
                      color: AppColors.blackColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  updateImagePaths() {
    imagePaths = [];
  }

  @override
  void dispose() {
    chatMessagesNotifier.dispose();
    scrollController.dispose();
    typingSubscription.cancel();
    super.dispose();
  }
}
