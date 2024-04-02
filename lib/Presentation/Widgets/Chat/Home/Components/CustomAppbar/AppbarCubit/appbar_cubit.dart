import 'package:chat_app/Data/Repository/ChatRepository/appbar_data_repository.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/Components/CustomAppbar/AppbarCubit/appbar_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppbarCubit extends Cubit<AppbarState> {
  AppbarCubit() : super(AppbarInitialState());

  Future<void> getAppbarData(String otherUid) async {
    try {
      final userModel = await AppbarRepository().getAppbarData(otherUid);
      print('inside app bar cubit'); 
      emit(AppbarLoadedState(userModel));
    } catch (e) {
      emit(AppbarErrorState("Error fetching appbar data: $e"));
    }
  }
}
