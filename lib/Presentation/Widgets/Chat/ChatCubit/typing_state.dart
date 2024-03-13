import 'package:chat_app/Domain/Models/users_model.dart';

abstract class TypingState {}

class TypingInitialState extends TypingState {}

class TypingLoadedState extends TypingState {
  final bool? istyping;
  final String? otherUserId;
  TypingLoadedState(this.istyping, this.otherUserId);
}

class TypingErrorState extends TypingState {
  String error;
  TypingErrorState(this.error);
}
