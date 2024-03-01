import 'package:chat_app/Data/DataSource/Resources/assets.dart';
import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Presentation/Common/custom_button.dart';
import 'package:chat_app/Presentation/Common/custom_textfield.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithemail/login_with_email_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithemail/login_with_email_states.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quick_router/quick_router.dart';

class LoginWithEmail extends StatefulWidget {
  const LoginWithEmail({Key? key}) : super(key: key);

  @override
  State<LoginWithEmail> createState() => _LoginWithEmailState();
}

class _LoginWithEmailState extends State<LoginWithEmail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _loginWithEmail() {
    String email = _emailController.text;
    String password = _passwordController.text;
    Map<String, dynamic> loginCredentials = {
      'email': email,
      'password': password
    };

    context.read<LoginWithEmailCubit>().loginWithEmail(loginCredentials);

    final User? user = FirebaseAuth.instance.currentUser;

    if (FirebaseAuth.instance.currentUser != null) {
      context.to(Home(
        currentUser: user,
      ));
    } else {
      AlertDialog(
        content: Container(
          height: 40,
          child: const Center(
            child: Text("No user selected"),
          ),
        ),
        backgroundColor: Colors.red[300],
      );
    }

    print('Email: $email');
    print('Password: $password');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              repeat: ImageRepeat.repeatY,
              image: AssetImage(
                Assets.logo!,
              ),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              CustomTextField(
                controller: _emailController,
                label: 'Enter Email',
                hintText: 'Email',
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _passwordController,
                label: 'Enter Password',
                hintText: 'Password',
                obscure: true,
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                buttonText: 'Login',
                buttonFunction: _loginWithEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
