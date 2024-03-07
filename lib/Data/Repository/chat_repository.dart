 import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';
 import 'package:chat_app/Domain/Models/chat_model.dart';

class ChatRepository {
  Stream<List<ChatModel>> getChat(String chatRoomId) {
    try {
      return FirestoreServices().getChat(chatRoomId);
    } catch (e) {
      print('Error in Chat repository  get chat $e');
     throw e;  
    }
  }
}
