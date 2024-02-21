import 'package:chat_app/Application/Providers/app_providers.dart';
import 'package:chat_app/Presentation/Widgets/Auth/login_screen.dart';
import 'package:chat_app/Presentation/Widgets/Chat/RecentChats/recent_chats.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiBlocProvider(providers: appProviders, child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat Now',
      home: FirebaseAuth.instance.currentUser != null
          ? RecentChats(user: FirebaseAuth.instance.currentUser!)
          : LoginScreen(),
    );
  }
}
