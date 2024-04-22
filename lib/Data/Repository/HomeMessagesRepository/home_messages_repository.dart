import 'dart:developer';
import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';
import 'package:chat_app/Domain/Models/home_messages_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
 

class HomeMessagesRepository {
  static final HomeMessagesRepository _instance =
      HomeMessagesRepository._internal();

  factory HomeMessagesRepository() {
    return _instance;
  }

  HomeMessagesRepository._internal();
 
   ValueNotifier<List<HomeMessagesModel>> homeMessageNotifier = ValueNotifier([]);

  void getHomeMessages() {
    log('home messages repo called');
    FirestoreServices.homeMessagesStream().listen((event) {
        homeMessageNotifier.value = event;
     });
   
   }
}
