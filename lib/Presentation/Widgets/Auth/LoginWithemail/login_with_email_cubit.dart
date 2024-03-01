 
import 'package:chat_app/Data/Repository/auth_repository.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithemail/login_with_email_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWithEmailCubit extends Cubit<LoginWithEmailState> {
  LoginWithEmailCubit() : super(InitialLoginWithEmailState());

  Future<void> loginWithEmail(Map<String, dynamic> loginCredentials) async {
  
    try {
       AuthRepository.loginWithEmail(loginCredentials);
 
    } catch (e) {
      print('Error in Login with Email Cubit $e');
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
