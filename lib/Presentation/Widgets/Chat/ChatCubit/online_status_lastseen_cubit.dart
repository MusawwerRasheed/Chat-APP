import 'dart:async';
import 'package:chat_app/Data/Repository/OnlineStatusRepository/online_status_repo.dart';
import 'package:chat_app/Domain/Models/chat_model.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatCubit/online_status_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

 
class OnlineStatusCubit extends Cubit<OnlineStatusLastSeenState> {
  
  OnlineStatusCubit() : super(OnlineInitialState());

  Future<void> updateOlineStatusLastSeen(bool isOnline, Timestamp lastSeen) async {

    emit(OnlineInitialState());

    try {
OnlineStatusRepo().updateOnlineStatusLastSeen(isOnline,lastSeen); 
      
  } catch (e) {
       
      print('error in online status cubit');
    }
  }
 
}




// class OnlineStatusCubit extends Cubit<OnlineStatusCubit> {

//   OnlineStatusCubit() : super(OnlineInitialState() as OnlineStatusCubit);

//   Future<void> updateOnlineStatusLastSeen(
//       bool onlineStatus, Timestamp lastSeen) async {
//     try {
//       OnlineStatusRepo().updateOnlineStatusLastSeen(onlineStatus, lastSeen);
//     } catch (e) {
//       throw e;
//     }
//   }

   
// }
