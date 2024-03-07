import 'package:chat_app/Application/Services/AuthServices/auth_services.dart';

class AuthRepository {
  static Future getUser() async {
    try {
      return await Auth.googleSignin().then(
        (value) {
          return value;
        },
      ).catchError((e) {
        return e;
      });
    } catch (e) {
      print('error in auth Repo getUser $e');
      return e;
    }
  }

  static Future loginWithEmail(String email, String password) async {
    try {
      return await Auth.loginWithEmail(email: email, password: password)
          .then((value) {
        return value;
      });
    } catch (e) {
      print('123 Error in auth repository loginWithEmail $e');
      return e;
    }
  }

  static Future registerWithEmail(
      Map<String, dynamic> registerationData) async {
    try {
      return await Auth.registerWithEmail(registerationData).then(
        (value) {
          return value;
        },
      ).catchError((e) {
        return e;
      });
    } catch (e) {
      print('Error in auth repository registerwith email $e');
      return e;
    }
  }
}
