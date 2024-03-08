import 'package:chat_app/Data/Repository/AuthRepository/auth_repository.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithemail/login_with_email_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWithEmailCubit extends Cubit<LoginWithEmailState> {
  LoginWithEmailCubit() : super(InitialLoginWithEmailState());

  Future loginWithEmail(String email, String password) async {
    emit(LoadingLoginWithEmailState());

    AuthRepository.loginWithEmail(email, password).then((value) {
      if (value is! String ) {
        emit(LoadedLoginwithEmailState(value));
      } else {
        emit(ErrorLoginWithEmailState(value));
        print('In cubit'); 
      }
    });
  }
}
