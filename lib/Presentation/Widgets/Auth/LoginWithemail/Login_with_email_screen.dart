import 'package:chat_app/Data/DataSource/Resources/assets.dart';
import 'package:chat_app/Data/DataSource/Resources/validator.dart';
import 'package:chat_app/Presentation/Common/custom_button.dart';
import 'package:chat_app/Presentation/Common/custom_textfield.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithemail/login_with_email_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithemail/login_with_email_states.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final _formKey = GlobalKey<FormState>();

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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                CustomTextField(
                  validatorValue: (value) {
                    if (value == '' || value!.isEmpty) {
                      return 'please enter a value';
                    }
                    if (!Validate().isEmailValid(value!)) {
                      return 'please enter correct email';
                    }
                  },
                  controller: _emailController,
                  label: 'Enter Email',
                  hintText: 'Email',
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  validatorValue: (value) {
                    if (value!.isEmpty) {
                      return 'please enter a value ';
                    }

                    if (value.length < 6) {
                      return 'password should be greater than 6 digits';
                    }
                  },
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
                BlocConsumer<LoginWithEmailCubit, LoginWithEmailState>(
                  listener: (context, state) {
                    if (state is LoadedLoginwithEmailState) {
                      context.pushReplacement(Home(
                        context: context,
                        currentUser: FirebaseAuth.instance.currentUser,
                      ));
                    }
                  },
                  builder: (context, state) {
                    return SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loginWithEmail() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      context.read<LoginWithEmailCubit>().loginWithEmail(email, password);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
