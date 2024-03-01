import 'package:chat_app/Application/Providers/app_providers.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithGoogle/login_screen.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiBlocProvider(providers: appProviders, child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
 return ScreenUtilInit(

minTextAdapt: true,
splitScreenMode: true,
useInheritedMediaQuery: true,
builder: (context, build){
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Chat NOw',
    home: FirebaseAuth.instance.currentUser !=null? 
    Home(currentUser: FirebaseAuth.instance.currentUser!,):LoginScreen(), 
  );
},

 );


   
  }
}
