import 'dart:async';
import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageSeenCubit extends Cubit {
  MessageSeenCubit() : super(());

  Future<void> updateOlineStatusLastSeen(bool seen) async {
    try {
      print('  inside updating seen $seen');
      FirestoreServices().updateMessageSeen(seen);
    } catch (e) {
      print('error in online status cubit');
    }
  }
}
