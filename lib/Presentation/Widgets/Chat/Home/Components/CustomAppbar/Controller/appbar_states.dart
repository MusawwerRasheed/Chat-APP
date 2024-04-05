import 'package:chat_app/Domain/Models/users_model.dart';

abstract class AppbarState {}

class AppbarInitialState extends AppbarState {}

class AppbarLoadingState extends AppbarState {}

class AppbarLoadedState extends AppbarState {
  UserModel user;
  AppbarLoadedState(this.user);
}

class AppbarErrorState extends AppbarState {
  String error;
  AppbarErrorState(this.error);
}
