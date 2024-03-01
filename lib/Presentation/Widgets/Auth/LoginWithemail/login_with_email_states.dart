import 'package:chat_app/Domain/Models/users_model.dart';

abstract class LoginWithEmailState {}

class InitialLoginWithEmailState extends LoginWithEmailState {}

class LoadedLoginwithEmailState extends LoginWithEmailState {
  final UserModel user;
  LoadedLoginwithEmailState(
    this.user,
  );
}

class ErrorLoginWithEmailState extends LoginWithEmailState {}
