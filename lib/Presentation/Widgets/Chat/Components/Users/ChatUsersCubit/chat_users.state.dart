import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatUsersState {}

class ChatUsersInitialState extends ChatUsersState {}


class ChatUsersLoadingState extends ChatUsersState {}


class ChatUsersLoadedState extends ChatUsersState {
  final List<UserModel> users;
  ChatUsersLoadedState(this.users);
}

class ChatUsersErrorState extends ChatUsersState {
  final String error;

  ChatUsersErrorState({required this.error});
}
