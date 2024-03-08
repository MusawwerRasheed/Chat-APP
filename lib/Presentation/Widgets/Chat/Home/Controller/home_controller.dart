import 'package:chat_app/Presentation/Common/custom_text.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithGoogle/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (error) {
      print('Error signing out: $error');
    }
  }

  buildPopupMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: <PopupMenuEntry>[
        const PopupMenuItem(
          child: CustomText(
            customText: 'Logout',
          ),
          value: 'logout',
        ),
      ],
    ).then((selectedValue) {
      if (selectedValue != null) {
        switch (selectedValue) {
          case 'logout':
            HomeController().signOut(context);
            break;
        }
      }
    });
  }
}
