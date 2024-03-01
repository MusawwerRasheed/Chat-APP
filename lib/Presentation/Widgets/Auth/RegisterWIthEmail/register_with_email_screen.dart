import 'package:chat_app/Data/DataSource/Resources/assets.dart';
import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Data/DataSource/Resources/validator.dart';
import 'package:chat_app/Presentation/Common/custom_button.dart';
import 'package:chat_app/Presentation/Common/custom_textfield.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithemail/login_with_email_states.dart';
import 'package:chat_app/Presentation/Widgets/Auth/RegisterWIthEmail/register_with_email_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Auth/RegisterWIthEmail/register_with_email_states.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

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

                // validator: ,
                
                controller: _fullNameController,
                label: 'Enter Your name',
                hintText: 'Full Name',
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _emailController,
                label: 'Enter Your Email',
                hintText: 'email',
                
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                controller: _passwordController,
                label: 'Enter Password',
                hintText: 'Password',

                // validator:   

                obscure: true,
              ),
              const SizedBox(height: 24.0),
              CustomButton(buttonText: 'Register', buttonFunction: _register),
              BlocConsumer<RegisterWithEmailCubit, RegisterWithEmailState>(
                listener: (context, state) {
                  if (state is LoadedRegisterwithEmailState) {
                   
                    final userModel = state.user;
                    context.to(Home(userModel: userModel, currentUser: FirebaseAuth.instance.currentUser,));
                    print('Registration successful: $userModel');
                  } else if (state is ErrorRegisterWithEmailState) {
                    
                    print('Error occurred during registration');
                  }
                },
                builder: (context, state) {
                  if (state is InitialRegisterWithEmailState) {
                 
                    // return CircularProgressIndicator();
                  }
              
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _register() {
    String fullName = _fullNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    Map<String, dynamic> registrationData = {
      'email': email,
      'password': password,
    };

    context.read<RegisterWithEmailCubit>().registerWithEmail(registrationData);

    print('Full Name: $fullName');
    print('Email: $email');
    print('Password: $password');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
