import 'package:chat_app/Data/Repository/DataSource/Resources/assets.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginCubit/login_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginCubit/login_state.dart';
import 'package:chat_app/Presentation/Widgets/Chat/RecentChats/recent_chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quick_router/quick_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            Assets.background!,
            height: 800,
            fit: BoxFit.fill,
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(Assets.logo!),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                 
    context.read<LoginCubit>().login();
                  },
                  child: Container(
                    height: 30,
                    width: 120,
                    child: Row(
                      children: [
                        Text('Sign in with '),
                        Image.asset(
                          Assets.googlelogo!,
                          height: 40,
                          width: 40,
                        ),
                      ],
                    ),
                  )),
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
              builder: (context) => RecentChats(user: state.user!,),
            ),
          );
        }
      },
      builder: (BuildContext context, LoginStates state) {
        if (state is LoginLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is LoginErrorState) {
          return Center(
            child: Text(state.error ?? 'An error occurred'),
          );
        }
        return SizedBox.shrink();
      },
    ),
        ],
      
      ),
      
    );
 
  }

  
    
  
}
