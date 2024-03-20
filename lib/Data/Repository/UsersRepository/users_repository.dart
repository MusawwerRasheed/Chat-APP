 import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';
 

class UsersRepository {
  Future searchUsers(String query, String currentUid) async {
    try {
      return await FirestoreServices().searchUsers(query, currentUid ).then(
        (value) {
           return value;
        },
      ).catchError((e) {
        return e;
      });
    } catch (e) {
      print('Error in Users repository $e');
      return e;
    }
  }

  

Future getChatUsers() async {
    try {
      return await FirestoreServices().getChatusers().then(
        (value) {
          return value;
        },
      ).catchError((e) {
        throw e;
      });
    } catch (e) {
      print('Error in chat Users repository $e');
      rethrow;
    }
  }

  
}