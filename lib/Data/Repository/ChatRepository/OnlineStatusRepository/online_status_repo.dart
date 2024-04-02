import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnlineStatusRepo {
  OnlineStatusRepo();

  Future updateOnlineStatusLastSeen(bool onlineStatus, Timestamp lastSeen) {
    try {
      return FirestoreServices().updateOnlineLastSeen(onlineStatus, lastSeen);
    } catch (e) {
      print('Error in istyping repository   $e');
      throw e;
    }
  }

  Stream<bool> onlineStatusStream(String otherUserId) {
    try {
      return FirestoreServices().getOnlineStatus(otherUserId);
    } catch (e) {
      throw (e);
    }
  }

  Stream<String> lastSeenStream(String otherUserId){

    try{
      return FirestoreServices().getLastSeen(otherUserId);
    } catch(e){
      throw(e); 
    }
   }
}
