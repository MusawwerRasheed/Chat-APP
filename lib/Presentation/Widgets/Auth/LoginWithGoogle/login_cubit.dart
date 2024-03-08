import 'package:bloc/bloc.dart';
import 'package:chat_app/Data/Repository/AuthRepository/auth_repository.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  Future<void> login() async {
    emit(LoginLoadingState());
    try {
      UserModel? user = await AuthRepository.getUser();
      print('>>>>>>>> $user.displayName');
      emit(LoginLoadedState(user: user!));
    } catch (e) {
      emit(LoginErrorState(e.toString()));
      rethrow;
    }
  }
}
