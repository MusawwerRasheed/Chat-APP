import 'package:chat_app/Application/Services/auth_services.dart';
import 'package:chat_app/Application/Services/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      return await FirestoreServices().GetChatusers().then(
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