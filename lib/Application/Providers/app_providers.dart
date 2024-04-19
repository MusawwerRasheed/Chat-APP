import 'package:chat_app/Presentation/Widgets/Auth/LoginWithGoogle/Controller/login_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithemail/Controller/login_with_email_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Auth/RegisterWIthEmail/Controller/register_with_email_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/Controller/MessageSeen/message_seen_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/Controller/OnlineStatus/online_status_lastseen_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Home/Components/CustomAppbar/Controller/appbar_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Home/Components/UsersSearchBar/Controller/Users/Controller/users_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

 
List<BlocProvider> appProviders = [
  BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
  BlocProvider<MessageSeenCubit>(create: (context) => MessageSeenCubit()),
  // BlocProvider<HomeMessagesCubit>(create: (context) => HomeMessagesCubit()),
  BlocProvider<AppbarCubit>(create:(context)=> AppbarCubit() ),
  BlocProvider<UsersCubit>(create: (context) => UsersCubit()),
  BlocProvider<LoginWithEmailCubit>(
    create: (context) => LoginWithEmailCubit(),
  ),
  BlocProvider<RegisterWithEmailCubit>(
    create: (context) => RegisterWithEmailCubit(),
  ),
  BlocProvider<OnlineStatusCubit>(
    create: (context) => OnlineStatusCubit(),
  ),
];
