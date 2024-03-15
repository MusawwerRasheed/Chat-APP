import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';

class IsTypingRepository {
  IsTypingRepository();

  Stream<bool> listenTyping(String userId, bool istyping ) {
    try {
    
      
      return FirestoreServices().isTyping(userId, istyping);
    } catch (e) {
      print('Error in istyping repository   $e');
      throw e;
    }
  }

  void updateTyping(String s, bool isTyping) {}
}
