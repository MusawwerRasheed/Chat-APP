import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthExceptionHandler {
  static String handleLoginException(dynamic e) {
    String errorText = '';
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          errorText = 'No user found for provided credentials.';
          break;
        case 'wrong-password':
          errorText = 'Wrong password provided for this user.';
          break;
        default:
          errorText = 'FirebaseAuthException: ${e.message}';
      }
    } else if (e is PlatformException) {
      switch (e.code) {
        default:
          errorText = 'PlatformException: ${e.message}';
      }
    } else {
      errorText = 'An error occurred: $e';
    }

    return errorText;
  }
}
