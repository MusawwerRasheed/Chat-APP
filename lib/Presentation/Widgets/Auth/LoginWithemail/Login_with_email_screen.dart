import 'package:chat_app/Data/DataSource/Resources/assets.dart';
import 'package:chat_app/Data/DataSource/Resources/color.dart';
import 'package:chat_app/Data/DataSource/Resources/validator.dart';
import 'package:chat_app/Presentation/Common/custom_button.dart';
import 'package:chat_app/Presentation/Common/custom_textfield.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithemail/Controller/login_with_email_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithemail/Controller/login_with_email_states.dart';
import 'package:chat_app/Presentation/Widgets/Home/Components/CustomAppbar/custom_appbar.dart';
import 'package:chat_app/Presentation/Widgets/Home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

class LoginWithEmail extends StatefulWidget {
  const LoginWithEmail({Key? key}) : super(key: key);

  @override
  State<LoginWithEmail> createState() => _LoginWithEmailState();
}

class _LoginWithEmailState extends State<LoginWithEmail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        widget: Container(
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
                SizedBox(height: 20),
                CustomTextField(
                  validatorValue: (value) {
                    if (value == '' || value!.isEmpty) {
                      return 'please enter a value';
                    }
                    if (!Validate().isEmailValid(value)) {
                      return 'please enter correct email';
                    }
                  },
                  controller: _emailController,
                  label: 'Enter Email',
                  hintText: 'Email',
                ),
                SizedBox(height: 16),
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
                SizedBox(height: 16),
                CustomButton(
                  buttonText: 'Login',
                  buttonFunction: _loginWithEmail,
                ),
                BlocConsumer<LoginWithEmailCubit, LoginWithEmailState>(
                  listener: (context, state) {
                    if (state is LoadedLoginwithEmailState) {
                      print('>>>>> ????? >>>>>> Loaded state');
                      Timer(Duration(milliseconds: 100), () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(
                              currentUser: FirebaseAuth.instance.currentUser,
                            ),
                          ),
                          (route) => false,
                        );
                      });
                    } else if (state is ErrorLoginWithEmailState) {
                      print(">>>>>>>>>>>>>> ??? >>>>>  ERROR LOGGING IN");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: AppColors.red,
                          content: Text(state.error),
                        ),
                      );
                      // Set _isLoading back to false on error
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingLoginWithEmailState) {
                      return Padding(
                        padding: const EdgeInsets.only(top : 20.0),
                        child: CircularProgressIndicator(),
                      );
                    }
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
      setState(() {
        _isLoading = true;
      });
      context
          .read<LoginWithEmailCubit>()
          .loginWithEmail(_emailController.text, _passwordController.text);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
