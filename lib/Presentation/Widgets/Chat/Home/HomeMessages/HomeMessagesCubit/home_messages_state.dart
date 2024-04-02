import 'package:chat_app/Domain/Models/home_messages_model.dart';

abstract class HomeMessagesStates {}

class InitialHomeMessagesState extends HomeMessagesStates {}

class LoadingHomeMessagesState extends HomeMessagesStates {}

class LoadedHomeMessageSate extends HomeMessagesStates {
  List<HomeMessagesModel> homeMessages;
  LoadedHomeMessageSate(this.homeMessages);
}

class ErrorHomeMessageState extends HomeMessagesStates {
  String? error;
  ErrorHomeMessageState(this.error);
}
