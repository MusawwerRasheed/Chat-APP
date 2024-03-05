import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginWithEmailState {}

class InitialLoginWithEmailState extends LoginWithEmailState {}

class LoadedLoginwithEmailState extends LoginWithEmailState {
  final User? user;
  LoadedLoginwithEmailState(
    this.user,
  );
}

class ErrorLoginWithEmailState extends LoginWithEmailState {}
