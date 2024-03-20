import 'package:chat_app/Data/DataSource/Resources/assets.dart';
import 'package:chat_app/Data/DataSource/Resources/extensions.dart';
import 'package:chat_app/Data/DataSource/Resources/validator.dart';
import 'package:chat_app/Presentation/Common/custom_button.dart';
import 'package:chat_app/Presentation/Common/custom_textfield.dart';
import 'package:chat_app/Presentation/Widgets/Auth/RegisterWIthEmail/register_with_email_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Auth/RegisterWIthEmail/register_with_email_states.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/Components/custom_appbar.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quick_router/quick_router.dart';

class RegisterWithEmail extends StatefulWidget {
  const RegisterWithEmail({Key? key}) : super(key: key);

  @override
  State<RegisterWithEmail> createState() => _RegisterWithEmailState();
}

class _RegisterWithEmailState extends State<RegisterWithEmail> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        widget: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              repeat: ImageRepeat.repeatY,
              fit: BoxFit.contain,
              image: AssetImage(Assets.logo!),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                20.y,
                CustomTextField(
                  validatorValue: (value) {
                    if (value == '' || value!.isEmpty) {
                      return 'please enter a value';
                    }
                  },
                  controller: _fullNameController,
                  label: 'Enter Your name',
                  hintText: 'Full Name',
                ),
                16.y,
                CustomTextField(
                  validatorValue: (value) {
                    if (value == '' || value!.isEmpty) {
                      return 'please enter value ';
                    }
                    if (!Validate().isEmailValid(value)) {
                      return 'please enter right format email';
                    }
                  },
                  controller: _emailController,
                  label: 'Enter Your Email',
                  hintText: 'email',
                ),
                16.y,
                CustomTextField(
                  validatorValue: (value) {
                    if (value == '' || value!.isEmpty) {
                      return 'please enter value ';
                    }
                    if (value.length < 6) {
                      return 'password must be 6 digts';
                    }
                  },
                  controller: _passwordController,
                  label: 'Enter Password',
                  hintText: 'Password',
                  obscure: true,
                ),
                24.y,
                CustomButton(buttonText: 'Register', buttonFunction: _register),
                BlocConsumer<RegisterWithEmailCubit, RegisterWithEmailState>(
                  listener: (context, state) {
                    if (state is LoadedRegisterwithEmailState) {
                      print('(((((((((((((((((((( ))))))))))))))))))))');
                      print(state); 
                      final userModel = state.user;
                      print(userModel.displayName);

                      context.pushReplacement(Home(
                        userModel: userModel,
                        currentUser: FirebaseAuth.instance.currentUser,
                      ));
                      print('Registration successful: $userModel');
                    } else if (state is ErrorRegisterWithEmailState) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.error!)));
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingRegisterWithEmailState) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Validate validate = Validate();

  void _register() {
    if (_formKey.currentState!.validate()) {
      String fullName = _fullNameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;

      Map<String, dynamic> registrationData = {
        'email': email,
        'password': password,
      };

      context
          .read<RegisterWithEmailCubit>()
          .registerWithEmail(registrationData);

      print('Full Name: $fullName');
      print('Email: $email');
      print('Password: $password');
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
