import 'dart:async';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatCubit/typing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TypingCubit extends Cubit<TypingState> {
  TypingCubit() : super(TypingInitialState());

  Future emitTyping(String istyping, String otherUserId) async {
    emit(TypingInitialState());
    boolfunc() {
      if (istyping.toLowerCase() == 'true') {
        return true;
      }
    }

    if (boolfunc()!) {
      emit(TypingLoadedState(true, otherUserId));
    }
  }
}
