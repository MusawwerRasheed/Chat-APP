import 'package:chat_app/Data/DataSource/Resources/assets.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithGoogle/login_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithGoogle/login_state.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithemail/Login_with_email_screen.dart';
import 'package:chat_app/Presentation/Widgets/Auth/RegisterWIthEmail/register_with_email_screen.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quick_router/quick_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            Assets.background!,
            height: 800.h,
            fit: BoxFit.fill,
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              Assets.logo!,
              height: 200.h, // Adjust the height as needed
            ),
            SizedBox(height: 20.h),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<LoginCubit>().login();
                },
                style: ElevatedButton.styleFrom(
                  elevation: 2, // Adjust elevation as needed
                  minimumSize: Size(200.w, 50.h), // Adjust size as needed
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Sign in/up with  '),
                    Image.asset(
                      Assets.googlelogo!,
                      height: 30.h,
                      width: 30.w,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.to(RegisterWithEmail());
                },
                style: ElevatedButton.styleFrom(
                  elevation: 2, // Adjust elevation as needed
                  minimumSize: Size(200.w, 50.h), // Adjust size as needed
                ),
                child: Text('Sign up with Email'),
              ),
            ),
            SizedBox(height: 10.h),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.to(LoginWithEmail());
                },
                style: ElevatedButton.styleFrom(
                  elevation: 2, // Adjust elevation as needed
                  minimumSize: Size(200.w, 50.h), // Adjust size as needed
                ),
                child: Text('Sign in with Email'),
              ),
            ),
          ]),
          BlocConsumer<LoginCubit, LoginStates>(
            listener: (BuildContext context, LoginStates state) {
              print('state is $state');
              if (state is LoginLoadedState) {
                print('State is loaded >>  $state');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(
                      userModel: state.user,
                      currentUser: FirebaseAuth.instance.currentUser,
                    ),
                  ),
                );
              } else if (state is LoginErrorState) {
                setState(() {
                  _showError = true;
                });
                Future.delayed(Duration(seconds: 2), () {
                  setState(() {
                    _showError = false;
                  });
                });
              }
            },
            builder: (BuildContext context, LoginStates state) {
              if (state is LoginLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SizedBox.shrink();
            },
          ),
          if (_showError)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: AlertDialog(
                  content: Container(
                    height: 40,
                    child: const Center(
                      child: Text("No user selected"),
                    ),
                  ),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
