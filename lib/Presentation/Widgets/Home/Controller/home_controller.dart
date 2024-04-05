import 'package:chat_app/Presentation/Widgets/Auth/LoginWithGoogle/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quick_router/quick_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class HomeController {
  String getFirst(String? email) {
    return email!.split('')[0];
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      context.to(LoginScreen());
    } catch (error) {
      print('Error signing out: $error');
    }
  }

  static String formatLastSeen(Timestamp timestamp) {
    Duration difference =
        Timestamp.now().toDate().difference(timestamp.toDate());
    if (difference.inSeconds < 05) {
      return 'Online';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 10) {
      return '${difference.inDays}D ago';
    }
    {
      return '${timestamp.toDate()}';
    }
  }

  static String formatMessageSend(Timestamp timestamp) {
    Duration difference =
        Timestamp.now().toDate().difference(timestamp.toDate());
    if (difference.inSeconds < 10) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 10) {
      return '${difference.inDays}D ago';
    }

    {
      return '${timestamp.toDate()}';
    }
  }
}
