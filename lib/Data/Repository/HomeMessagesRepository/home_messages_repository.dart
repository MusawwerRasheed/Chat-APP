import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';
import 'package:chat_app/Domain/Models/home_messages_model.dart';

class HomeMessagesRepository {
  static Stream<List<HomeMessagesModel>> getHomeMessages() {
    try {
 
      var messages = FirestoreServices.gethomeMessages();

  print('ainside mess');
       print(messages);
      return messages;
    } catch (e) {
      print('error in home messages repository');
      throw e;
    }
  }
}
