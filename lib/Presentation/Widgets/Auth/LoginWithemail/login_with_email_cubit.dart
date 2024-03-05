 
import 'package:chat_app/Data/Repository/auth_repository.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithemail/login_with_email_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginWithEmailCubit extends Cubit<LoginWithEmailState> {
  LoginWithEmailCubit() : super(InitialLoginWithEmailState());

  Future loginWithEmail(String email, String password) async {
  
    try {
       AuthRepository.loginWithEmail(email, password).then((value) => 
       
        (value !=null )? 
        emit(LoadedLoginwithEmailState(value)):
        emit(ErrorLoginWithEmailState())       
              );

        
    } catch (e) {
      print('Error in Login with Email Cubit $e');
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
