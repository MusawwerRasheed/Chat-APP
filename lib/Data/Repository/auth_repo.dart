import 'package:chat_app/Application/Services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
 

class AuthRepository {
  Future<User?> getUser() async {
    try {
      return await Auth.googleSignin().then(
        (value) {
          return value;
        },
      ).catchError((e) {
        throw e;
      });
    } catch (e) {
      print('Error in auth repository $e');
      rethrow;
    }
  }
}