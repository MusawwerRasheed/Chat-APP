import 'package:chat_app/Data/Repository/UsersRepository/users_repository.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/Controller/Users/Controller/users_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersCubit extends Cubit<UsersState> {
  
 

  UsersCubit() : super(UsersInitialState());

  Future<void> getUsers(String query, String currentUid) async {
    emit(UsersInitialState());

    try {
      List<UserModel> users = await UsersRepository().searchUsers(query, currentUid );
        

      emit(UsersLoadedState(users));

    } catch (e) {
      emit(UsersErrorState(error: e.toString()));
      print('error in users cubit');
    }
  }
 
}
