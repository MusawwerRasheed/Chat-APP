import 'package:chat_app/Application/Services/firestore_services.dart';
import 'package:chat_app/Data/Repository/chat_repository.dart';
import 'package:chat_app/Data/DataSource/Resources/color.dart';
import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Domain/Models/chat_model.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/Components/custom_chat_text_field.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/Components/custom_list_tile.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/ChatUsersCubit/chat_users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  final String? chatRoomId;
  final UserModel? otherUser;

  const ChatScreen(
      {Key? key, required this.chatRoomId, required this.otherUser})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController inputController = TextEditingController();

  ValueNotifier<List<ChatModel>> chatMessagesNotifier =
      ValueNotifier<List<ChatModel>>([]);

  @override
  void initState() {
    super.initState();
    initChatStream();
  }

  void initChatStream() async {
    try {
      final chatStream = ChatRepository().getChat(widget.chatRoomId!);
      chatStream.listen((chatMessages) {
        chatMessagesNotifier.value = chatMessages;
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
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: SizedBox(
          child: Row(
            children: [
              Text(
                widget.otherUser!.displayName!,
                style: Styles.plusJakartaSans(context),
              ),
              const SizedBox(
                width: 20,
              ),
              widget.otherUser!.imageUrl == ''
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        color: Colors.blue[400],
                        width: 40,
                        height: 40,
                        child: Center(
                          child: Text(
                            widget.otherUser!.displayName != null &&
                                    widget.otherUser!.displayName!.isNotEmpty
                                ? widget.otherUser!.displayName![0]
                                    .toUpperCase()
                                : "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        width: 40,
                        height: 40,
                        color: AppColors.blackColor,
                        child: Image.network(
                          widget.otherUser!.imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
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
                    return CustomListTIle(message: message);
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  // margin: EdgeInsets.only(bottom: 20, left: 30),
                  height: 60,
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
                    sendMessage(inputController.text, widget.chatRoomId!);
                    context.read<ChatUsersCubit>().getChatUsers();
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

  void sendMessage(String messageText, String chatRoomId) {
    FirestoreServices().sendMessage(chatRoomId, messageText);
  }
}




