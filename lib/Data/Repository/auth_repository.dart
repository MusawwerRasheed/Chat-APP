import 'package:chat_app/Application/Services/auth_services.dart';
 

class AuthRepository {

  
static  Future getUser() async {
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


static  Future loginWithEmail( Map<String,dynamic> loginCredentials) async {
    try {
      return await Auth.loginWithEmail(loginCredentials).then(
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


static  Future registerWithEmail(Map<String,dynamic> registerationData) async {
    try {
      return await Auth.registerWithEmail(registerationData).then(
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