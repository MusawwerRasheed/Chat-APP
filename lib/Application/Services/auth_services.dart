import 'package:chat_app/Application/Services/auth_exceptions.dart';
import 'package:chat_app/Application/Services/firestore_services.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart'; // Import PlatformException

class Auth {
  static Future googleSignin() async {
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
      }
    } catch (e) {
      return AuthExceptionHandler.handleException(e);
    }
  }
}
