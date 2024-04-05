import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginLoadedState extends LoginStates {
  UserModel user ; 
  LoginLoadedState({required this.user});
}

class LoginErrorState extends LoginStates {
  final String? error;
  LoginErrorState(this.error);
}
