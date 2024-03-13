 
import 'package:chat_app/Data/Repository/UsersRepository/users_repository.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Users/ChatUsersCubit/chat_users.state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatUsersCubit extends Cubit<ChatUsersState> {
  ChatUsersCubit() : super(ChatUsersInitialState());

  Future<void> 
  getChatUsers() async {
 await Future.delayed(Duration.zero);  
 emit(ChatUsersLoadingState()); 
    try {
      List<UserModel> chatUsers = await UsersRepository().getChatUsers();
      if (chatUsers.isNotEmpty) {
        emit(ChatUsersLoadedState(chatUsers));
      }
      else{
        emit(ChatUsersErrorState(error: 'chat users error'));
      }
    } catch (e) {
      emit(ChatUsersErrorState(error: e.toString()));
      print('Error in ChatUsers cubit: $e');
    }
  }
}
