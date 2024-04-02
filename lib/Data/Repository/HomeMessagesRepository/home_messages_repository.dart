import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';

class HomeMessagesRepository {
  static Future getHomeMessages() async {
    try {
    
      var messages = await FirestoreServices.gethomeMessages();
      // print('>>>>>>>>>> repo 2'); 
      return messages;
    } catch (e) {
      print('error in home messages repository');
      throw e;
    }
  }
}

