import 'package:chat_app/Domain/Models/users_model.dart';

abstract class RegisterWithEmailState {}

class InitialRegisterWithEmailState extends RegisterWithEmailState {}

class LoadingRegisterWithEmailState extends RegisterWithEmailState {}

class LoadedRegisterwithEmailState extends RegisterWithEmailState {
  UserModel user;
  LoadedRegisterwithEmailState(this.user);
}

class ErrorRegisterWithEmailState extends RegisterWithEmailState {
final String? error; 
ErrorRegisterWithEmailState(this.error);


}
