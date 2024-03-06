 import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';
 

class UsersRepository {
  Future searchUsers(String query) async {
    try {
      return await FirestoreServices().searchUsers(query).then(
        (value) {
           
          return value;

        },
      ).catchError((e) {
        throw e;
      });
    } catch (e) {
      print('Error in Users repository $e');
      rethrow;
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