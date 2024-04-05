 
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/Controller/OnlineStatus/online_status_lastseen_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart'; 
import 'package:flutter_bloc/flutter_bloc.dart';  
 

class AppLifecycleObserver with WidgetsBindingObserver {
  final BuildContext context;

  AppLifecycleObserver({
    required this.context,
  }) {
    
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        context.read<OnlineStatusCubit>().updateOlineStatusLastSeen(true,Timestamp.now()); 
        break;

      case AppLifecycleState.paused: 
        context.read<OnlineStatusCubit>().updateOlineStatusLastSeen(false,Timestamp.now()); 
         
        break;

      case AppLifecycleState.detached:
      context.read<OnlineStatusCubit>().updateOlineStatusLastSeen(false,Timestamp.now()); 
        break;

      default:
        break;
    }
  }
 
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
  }
}
