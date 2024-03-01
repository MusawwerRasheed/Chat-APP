import 'package:chat_app/Data/Repository/auth_repository.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Widgets/Auth/RegisterWIthEmail/register_with_email_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterWithEmailCubit extends Cubit<RegisterWithEmailState> {
  RegisterWithEmailCubit() : super(InitialRegisterWithEmailState());

  Future<void> registerWithEmail(Map<String, dynamic> registerationData) async {
    emit(InitialRegisterWithEmailState());

    try {
      UserModel user =
          await AuthRepository.registerWithEmail(registerationData);
 
    emit(LoadedRegisterwithEmailState(user));
          
    } catch (e) {
      print('error in registration cubit $e');
      throw (e);
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
