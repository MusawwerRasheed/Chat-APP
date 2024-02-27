import 'dart:async';

import 'package:chat_app/Data/Repository/chat_repository.dart';
import 'package:chat_app/Domain/Models/chat_model.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatCubit/chat_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
  
 
//  class ChatCubit extends Cubit<ChatState> {
 

//   ChatCubit() : super(ChatInitialState());

//   Future<void> getChat(String chatRoomId) async {
//     emit(ChatInitialState());
//     try {
//       Stream<QuerySnapshot<Map<String, dynamic>>> chatStream =
//           await ChatRepository().getChat(chatRoomId);
//       chatStream.listen((chatsSnapshot) {
//         List<ChatModel> chats = chatsSnapshot.docs.map((doc) {
//           return ChatModel.fromJson(doc.data());
//         }).toList();
//         emit(ChatLoadedState(chatStream));
//       });
//     } catch (e) {
//       emit(ChatErrorState(e.toString()));
//       throw e;
//     }
//   }

//   @override
//   Future<void> close() {
//     return super.close();
//   }
// }

 
 

 