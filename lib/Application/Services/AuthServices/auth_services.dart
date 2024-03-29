import 'package:chat_app/Application/Services/AuthServices/auth_exceptions.dart';
import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Result<T> {
  final T? value;
  final String? error;

  Result(this.value, this.error);
}

class Auth {
  static Future loginWithEmail(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(FirebaseAuth.instance.currentUser);
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      print(AuthExceptionHandler.handleLoginException(e));
      String error = AuthExceptionHandler.handleLoginException(e);
      return error;
    }
  }

  static Future registerWithEmail(
      Map<String, dynamic> registrationData) async {
    try {
      String email = registrationData['email'];
      String password = registrationData['password'];

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userName = registrationData['email'].split('@').first;

      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        displayName: userName,
        imageUrl: '',
      );
      await FirestoreServices.storeUserdata(userModel);
      print('>>>>>>><<<<<>>><<<<>>'); 
      print(userModel); 
      print('<<>><<><<><<<>9999999999999');
      return userModel;
    } catch (e) {
      String authExceptions = AuthExceptionHandler.handleLoginException(e);
      return authExceptions;
    }
  }



  static Future<UserModel?> googleSignin() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final GoogleSignIn gSignin = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await gSignin.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await auth.signInWithCredential(credential);

        UserModel userModel = UserModel(
          uid: authResult.user?.uid,
          displayName: authResult.user?.displayName,
          imageUrl: authResult.user?.photoURL,
          
        );
        await FirestoreServices.storeUserdata(userModel);
        return userModel;
      } else {
        return null;
      }
    } catch (e) {
      String authError = AuthExceptionHandler.handleLoginException(e);
      throw (authError);
    }
  }
}
