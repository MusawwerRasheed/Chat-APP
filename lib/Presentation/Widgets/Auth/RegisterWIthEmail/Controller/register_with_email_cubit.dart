import 'package:chat_app/Data/Repository/AuthRepository/auth_repository.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Widgets/Auth/RegisterWIthEmail/Controller/register_with_email_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterWithEmailCubit extends Cubit<RegisterWithEmailState> {
  RegisterWithEmailCubit() : super(InitialRegisterWithEmailState());

  Future<void> registerWithEmail(Map<String, dynamic> registerationData) async {
    emit(LoadingRegisterWithEmailState());

    UserModel user = await AuthRepository.registerWithEmail(registerationData).then((value) {
      if (value is! String) {
        emit(LoadedRegisterwithEmailState(value));
      } else {
        emit(ErrorRegisterWithEmailState(value));
      }
      return value;
    });

  }

  @override
  Future<void> close() {
    return super.close();
  }
}
