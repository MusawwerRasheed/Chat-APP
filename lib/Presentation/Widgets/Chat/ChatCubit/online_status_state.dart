import 'package:chat_app/Domain/Models/users_model.dart';

abstract class OnlineStatusLastSeenState {}

class OnlineInitialState extends OnlineStatusLastSeenState {}

class OnlineStatusLoadedState extends OnlineStatusLastSeenState { 
}

class OnlineStatusErrorState extends OnlineStatusLastSeenState {
  
 }
