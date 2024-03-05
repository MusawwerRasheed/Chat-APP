import 'package:chat_app/Data/DataSource/Resources/assets.dart';
import 'package:chat_app/Data/DataSource/Resources/validator.dart';
import 'package:chat_app/Presentation/Common/custom_button.dart';
import 'package:chat_app/Presentation/Common/custom_textfield.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithemail/login_with_email_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithemail/login_with_email_states.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/home.dart';
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
              BlocConsumer<LoginWithEmailCubit, LoginWithEmailState>(
                 listener: ( context,   state) {

                    if(state is LoadedLoginwithEmailState){
                      context.to(Home());
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
    );
  }

  Validate validate = Validate();

  void _loginWithEmail() {
    if (validate.validateLogin(
        context, _emailController.text, _passwordController.text)) {
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
