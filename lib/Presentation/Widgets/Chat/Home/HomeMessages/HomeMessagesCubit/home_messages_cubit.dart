import 'package:chat_app/Data/Repository/HomeMessagesRepository/home_messages_repository.dart';
import 'package:chat_app/Domain/Models/home_messages_model.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/HomeMessages/HomeMessagesCubit/home_messages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeMessagesCubit extends Cubit<HomeMessagesStates> {
  HomeMessagesCubit() : super(InitialHomeMessagesState());

  Future<void> getHomeMessages() async {
    emit(InitialHomeMessagesState());

    try {
      
      
      List<HomeMessagesModel> homeMessages =
          await HomeMessagesRepository.getHomeMessages();
      
      print(homeMessages.length);
    
      emit(LoadedHomeMessageSate(homeMessages));
    } catch (e) {
      emit(ErrorHomeMessageState(e.toString()));
      print('error in home messages cubit');
    }
  }
}
