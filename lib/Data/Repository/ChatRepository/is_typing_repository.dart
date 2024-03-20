import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';

class IsTypingRepository {
  IsTypingRepository();

  Future updateTypingStatus(String userId, bool istyping) {
    try {
      //
      // Debouncer(milliseconds: 500 ).run(() {
      //
      //
      //
      // });
      return FirestoreServices().updateTypingStatus(userId, istyping);
    } catch (e) {
      print('Error in istyping repository   $e');
      throw e;
    }
  }

  Stream<bool> typingStream(String otherUserId) {
    try {
      return FirestoreServices().getTypingStream(otherUserId);
    } catch (e) {
      throw (e);
    }
  }
}
