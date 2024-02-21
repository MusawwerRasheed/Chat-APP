import 'package:chat_app/Presentation/Widgets/Auth/LoginCubit/login_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
     
List<BlocProvider> appProviders = [
BlocProvider<LoginCubit>(create: (context) => LoginCubit()),

];