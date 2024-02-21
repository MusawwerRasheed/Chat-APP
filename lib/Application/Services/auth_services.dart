import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  static Future<User?> googleSignin() async {
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
        final User? user = authResult.user;
        FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
          'uid': user!.uid,
        'displayName': user!.displayName, 
        'email':user!.email,
        'imageUrl':user!.photoURL,
        });
        return user;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
