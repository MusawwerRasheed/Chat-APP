import 'package:chat_app/Presentation/Widgets/Auth/LoginCubit/login_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatCubit/chat_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/ChatUsersCubit/chat_users_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/UsersCubit/users_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
     
List<BlocProvider> appProviders = [
BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
BlocProvider<ChatUsersCubit>(create: (context) => ChatUsersCubit()),
BlocProvider<UsersCubit>(create: (context) => UsersCubit()),
// BlocProvider<ChatCubit>(create:(context)=>ChatCubit()), 
];