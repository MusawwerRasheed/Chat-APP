import 'package:chat_app/Data/Repository/users_repository.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/ChatUsersCubit/chat_users.state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

 

class ChatUsersCubit extends Cubit<ChatUsersState> {
  ChatUsersCubit() : super(ChatUsersInitialState());

  Future<void> getChatUsers() async {
    emit(ChatUsersInitialState());

    try {
      List<UserModel> chatUsers = await UsersRepository().getChatUsers();
      emit(ChatUsersLoadedState(chatUsers));
    } catch (e) {
      emit(ChatUsersErrorState(error: e.toString()));
      print('Error in ChatUsers cubit: $e');
    }
  }
}
