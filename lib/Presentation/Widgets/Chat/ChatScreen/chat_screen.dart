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
  bool isLoadingImage = false;
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
  List<String> imagePaths = [];
  List<String> imagesRecieved = [];
  List<Widget> widgetsList = [];
  @override
  @override
  void initState() {
    super.initState();
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
      final isAtBottom = scrollController.position.pixels ==
          scrollController.position.minScrollExtent;

      if (isAtBottom) {
        setState(() {
          isBottomContainerVisible = false;
        });
      } else {
        setState(() {
          isBottomContainerVisible = true;
        });
      }
    });

    initChatStream();
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

  final _debouncer = Debouncer(milliseconds: 500);

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
                        if (message.type == 'text' && message.type != null) {
                          return CustomListTile(message: message);
                        } else {
                          return FutureBuilder<List<String>>(
                            future: deconcatinateAsync(message.text),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<String>> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                List<String>? newImagePaths = snapshot.data;
                                if (newImagePaths != null &&
                                    newImagePaths.isNotEmpty) {
                                  return Container(
                                    margin: message.senderId ==
                                            FirebaseAuth
                                                .instance.currentUser!.uid
                                        ? const EdgeInsets.only(
                                            left: 90, top: 10, bottom: 10)
                                        : const EdgeInsets.only(
                                            right: 90, top: 10, bottom: 10),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: message.senderId == 
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                          ? AppColors.blue
                                          : AppColors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: newImagePaths.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            newImagePaths.length > 1 ? 2 : 1,
                                        crossAxisSpacing: 5.0,
                                        mainAxisSpacing: 5.0,
                                      ),
                                      itemBuilder: (context, index) {
                                        if (index == newImagePaths.length - 1 &&
                                            isLoadingImage) {
                                          return CircularProgressIndicator();
                                        } else {
                                          return GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return Dialog(
                                                    child: Image.network(
                                                      newImagePaths[index],
                                                      fit: BoxFit.fill,
                                                      width: 00,
                                                      height: 500,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                    offset: Offset(0, 3),
                                                  ),
                                                ],
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  newImagePaths[index],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              }
                            },
                          );
                        }
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
                          updateTypingStatus(true);
                          _debouncer.run(() {
                            updateTypingStatus(false);
                          });
                        },
                        inputColor: Colors.black,
                        fontSize: 12,
                        iconColor: Colors.grey,
                        suffix:
                            const Icon(Icons.image, color: AppColors.lightGrey),
                        suffixFunction: () {
                          ChatScreenController()
                              .pickImages(context)
                              .then((value) {
                            List<String> newImages = [];

                            for (var imagePath in value) {
                              if (!imagePaths.contains(imagePath)) {
                                newImages.add(imagePath);
                                imagePaths.clear();
                              }
                            }

                            imagePaths.addAll(newImages);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Center(
                                  child: Container(
                                    height: 400,
                                    width: 250,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: GridView.builder(
                                            scrollDirection: Axis.horizontal,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                            ),
                                            itemCount: imagePaths.length,
                                            itemBuilder: (context, index) {
                                              return Image.file(
                                                  File(imagePaths[index]));
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          left: 70,
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                              shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(90),
                                                ),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                AppColors.blue,
                                              ),
                                            ),
                                            onPressed: () {
                                              FirestoreServices().sendMessage(
                                                chatRoomId: widget.chatRoomId,
                                                otherUserId:
                                                    widget.otherUser?.uid,
                                                context: context,
                                                imagePaths: imagePaths,
                                                isStreamEmpty:
                                                    isStreamEmpty.value,
                                              );
                                              context
                                                  .read<ChatUsersCubit>()
                                                  .getChatUsers();
                                              initChatStream();
                                              inputController.clear();
                                              Navigator.pop(context);
                                            },
                                            child: const Icon(
                                              Icons.send,
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
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
                          chatRoomId: widget.chatRoomId,
                          messageText:
                              inputController.text, // Pass the text message
                          otherUserId: widget.otherUser?.uid,
                          context: context,
                          isStreamEmpty: isStreamEmpty.value,
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
                ChatScreenController(scrollController: scrollController)
                    .scrollToBottom();
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
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    height: 25,
                    width: 25,
                    child: const Icon(
                      Icons.arrow_downward,
                      color: AppColors.white,
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

  @override
  void dispose() {
    chatMessagesNotifier.dispose();
    scrollController.dispose();
    typingSubscription.cancel();
    super.dispose();
  }

  void someOtherFunction() {
    print('hey it works');
  }

  Future<List<String>> deconcatinateAsync(String? contatinatedString) async {
    if (contatinatedString == null) {
      return [];
    }

    List<String> paths =
        contatinatedString.split(',').map((path) => path.trim()).toList();

    return paths;
  }
}
