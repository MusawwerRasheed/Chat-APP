import 'package:chat_app/Presentation/Widgets/Auth/LoginWithGoogle/login_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithemail/login_with_email_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Auth/RegisterWIthEmail/register_with_email_cubit.dart';

import 'package:chat_app/Presentation/Widgets/Chat/ChatCubit/MessageSeen/message_seen_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatCubit/OnlineStatus/online_status_lastseen_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/Components/CustomAppbar/AppbarCubit/appbar_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/HomeMessages/HomeMessagesCubit/home_messages_cubit.dart';

import 'package:chat_app/Presentation/Widgets/Chat/Users/UsersCubit/users_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<BlocProvider> appProviders = [
  BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
  BlocProvider<MessageSeenCubit>(create: (context) => MessageSeenCubit()),
  BlocProvider<HomeMessagesCubit>(create: (context) => HomeMessagesCubit()),
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
