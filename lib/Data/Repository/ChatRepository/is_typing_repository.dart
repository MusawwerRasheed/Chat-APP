import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';

class IsTypingRepository {
  IsTypingRepository();

  Stream<bool> listenTyping(String userId) {
    try {
      return FirestoreServices().isTyping(userId);
    } catch (e) {
      print('Error in istyping repository   $e');
      throw e;
    }
  }
}
