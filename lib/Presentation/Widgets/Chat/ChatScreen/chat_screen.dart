import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';
import 'package:chat_app/Data/DataSource/Resources/extensions.dart';
import 'package:chat_app/Data/Repository/ChatRepository/chat_repository.dart';
import 'package:chat_app/Data/DataSource/Resources/color.dart';
import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Domain/Models/chat_model.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Common/custom_image.dart';
import 'package:chat_app/Presentation/Common/custom_text.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/Components/custom_chat_text_field.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/Components/custom_list_tile.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/Components/custom_appbar.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Users/ChatUsersCubit/chat_users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  final String? chatRoomId;
  final UserModel? otherUser;

  const ChatScreen({Key? key, this.chatRoomId, this.otherUser})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController inputController = TextEditingController();
  ValueNotifier<bool> isStreamEmpty = ValueNotifier<bool>(false);
  ValueNotifier<List<ChatModel>> chatMessagesNotifier =
      ValueNotifier<List<ChatModel>>([]);

  @override
  void initState() {
    super.initState();
    initChatStream();

    print(widget.chatRoomId);
  }

  void initChatStream() async {
    try {
      final chatStream = ChatRepository().getChat(widget.chatRoomId!);
      chatStream.listen((chatMessages) {
        chatMessagesNotifier.value = chatMessages;
        print('?????>>>>');
        print(chatMessagesNotifier.value);
        print(isStreamEmpty.value);

        if (chatMessagesNotifier.value.isEmpty) {
          isStreamEmpty.value = true;
          print(isStreamEmpty);
        } else {
          isStreamEmpty.value = false;
          print(isStreamEmpty.value);
        }
      });
    } catch (e) {
      print('Error initializing chat stream: $e');
    }
  }

  @override
  void dispose() {
    chatMessagesNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppbar(widget:  Row(
              children: [
                CustomText(
                  customText: widget.otherUser!.displayName!,
                  textStyle: Styles.plusJakartaSans(context),
                ),
                20.x,
                widget.otherUser!.imageUrl == ''
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          color: Colors.blue[400],
                          width: 40,
                          height: 40,
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
                      )
              ],
            ),
      
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ValueListenableBuilder<List<ChatModel>>(
              valueListenable: chatMessagesNotifier,
              builder: (context, chatMessages, _) {
                return ListView.builder(
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
                  margin: EdgeInsets.only(left: 10, bottom: 20),
                  height: 51.h,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CustomChatTextField(inputController: inputController),
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
                        isStreamEmpty.value);
                    context.read<ChatUsersCubit>().getChatUsers();
                    initChatStream();
                    inputController.clear();
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
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
    );
  }
}

