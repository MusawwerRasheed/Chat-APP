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
    return await Auth.loginWithEmail(email: email, password: password)
        .then((value) {
      return value;
    });
  }


  static Future registerWithEmail(
      Map<String, dynamic> registerationData) async {
    return await Auth.registerWithEmail(registerationData).then(
      (value) {
 return value ; 
      },
    );
  }
}
