import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UsersState {}

class UsersInitialState extends UsersState {}

class UsersLoadedState extends UsersState {
  final List<UserModel> users;
  UsersLoadedState(this.users);
}

class UsersErrorState extends UsersState {
  final String error;

  UsersErrorState({required this.error});
}
