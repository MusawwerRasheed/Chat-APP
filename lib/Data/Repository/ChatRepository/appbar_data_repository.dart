import 'package:chat_app/Application/Services/FirestoreServices/firestore_services.dart';
import 'package:chat_app/Domain/Models/users_model.dart';

class AppbarRepository {
  Future<UserModel> getAppbarData(String otherUid) async {
    try {
      UserModel value = await FirestoreServices.getAppbarData(otherUid);
      return value;
    } catch (e) {
      print("Error fetching appbar data: $e");
      throw e;
    }
  }
}
