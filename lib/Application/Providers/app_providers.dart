import 'package:chat_app/Presentation/Widgets/Auth/LoginWithGoogle/login_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithemail/login_with_email_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Auth/RegisterWIthEmail/register_with_email_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Auth/RegisterWIthEmail/register_with_email_screen.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatCubit/chat_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/ChatUsersCubit/chat_users_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/UsersCubit/users_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
     
List<BlocProvider> appProviders = [
BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
BlocProvider<ChatUsersCubit>(create: (context) => ChatUsersCubit()),
BlocProvider<UsersCubit>(create: (context) => UsersCubit()),
BlocProvider<LoginWithEmailCubit>(create: (context) => LoginWithEmailCubit(),),
BlocProvider<RegisterWithEmailCubit>(create: (context)=> RegisterWithEmailCubit(),),   
];