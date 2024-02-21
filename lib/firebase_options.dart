// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
 
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBE7hZdqDcLopIXvs8iGFWo0e2CXRZXeGY',
    appId: '1:858671795518:web:b642fad7d4a2d8c3a5706f',
    messagingSenderId: '858671795518',
    projectId: 'chatapp-eefc7',
    authDomain: 'chatapp-eefc7.firebaseapp.com',
    storageBucket: 'chatapp-eefc7.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYbJDbZwnsHuiHhap7hRRsgf7aoizCMWU',
    appId: '1:858671795518:android:ffb2f20dc99d1bc9a5706f',
    messagingSenderId: '858671795518',
    projectId: 'chatapp-eefc7',
    storageBucket: 'chatapp-eefc7.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAwiw1EH939UjU5XG03UFgMJSnsVsx6vkQ',
    appId: '1:858671795518:ios:bc784f845bb8061ba5706f',
    messagingSenderId: '858671795518',
    projectId: 'chatapp-eefc7',
    storageBucket: 'chatapp-eefc7.appspot.com',
    iosBundleId: 'com.example.chatApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAwiw1EH939UjU5XG03UFgMJSnsVsx6vkQ',
    appId: '1:858671795518:ios:9dbf26ce84318027a5706f',
    messagingSenderId: '858671795518',
    projectId: 'chatapp-eefc7',
    storageBucket: 'chatapp-eefc7.appspot.com',
    iosBundleId: 'com.example.chatApp.RunnerTests',
  );
}
