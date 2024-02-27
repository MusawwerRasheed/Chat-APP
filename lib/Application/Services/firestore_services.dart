import 'package:chat_app/Domain/Models/chat_model.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quick_router/quick_router.dart';

class FirestoreServices {
  final currentUser = FirebaseAuth.instance.currentUser!;

  static Future storeUserdata(UserModel userModel) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel!.uid)
          .set(userModel.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> GetChatusers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chatrooms')
          .where('users', arrayContains: currentUser.uid)
          .get();

      List<String> userIds = querySnapshot.docs.map((doc) {
        List<dynamic>? users = (doc.data() as Map<String, dynamic>)['users'];
        if (users != null && users.isNotEmpty) {
          return users.firstWhere((userId) => userId != currentUser.uid)
              as String;
        }
        return '';
      }).toList();

      QuerySnapshot usersQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds)
          .get();

      List<UserModel> users = usersQuerySnapshot.docs.map((user) {
        return UserModel.fromJson(user.data() as Map<String, dynamic>);
      }).toList();
      return users;
    } catch (e) {
      throw (e);
    }
  }

  Future<void> checkChatroom(
      BuildContext context, String userId, UserModel otherUser) async {
    final QuerySnapshot chatrooms = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('users', arrayContainsAny: [userId, otherUser.uid]).get();

    if (chatrooms.docs.isNotEmpty) {
      String chatRoomId = chatrooms.docs.first.id;

      context.to(ChatScreen(chatRoomId: chatRoomId, otherUser: otherUser));
    } else {
      String chatRoomId = generateChatRoomId(userId, otherUser.uid!);

      context.to(ChatScreen(chatRoomId: chatRoomId, otherUser: otherUser));
    }
  }

  Future<List<UserModel>> searchUsers(String query) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<DocumentSnapshot> allUsers = querySnapshot.docs.toList();

    List<DocumentSnapshot> filteredUsers = allUsers
        .where((user) => user.id != FirebaseAuth.instance.currentUser?.uid)
        .toList();

    List<UserModel> users = filteredUsers.map((userDoc) {
      return UserModel.fromSnapshot(userDoc);
    }).where((user) {
      String displayName = user.displayName ?? "";
      return displayName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return users;
  }

  Future<void> createChatRoom(String userId, String otherUserId) async {
    try {
      String chatRoomId = generateChatRoomId(userId, otherUserId);

      await FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(chatRoomId)
          .set({
        'users': [userId, otherUserId],
        'createdAt': DateTime.now(),
      });

      await updateChatRoomIdsForUsers(userId, otherUserId, chatRoomId);
    } catch (e) {
      print('Error creating chatroom: $e');
    }
  }

  String generateChatRoomId(String userId, String otherUserId) {
    List<String> userIds = [userId, otherUserId];
    userIds.sort();
    return '${userIds[0]}_${userIds[1]}';
  }

  Future<void> updateChatRoomIdsForUsers(
      String userId, String otherUserId, String chatRoomId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'chatRoomIds': FieldValue.arrayUnion([chatRoomId]),
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserId)
          .update({
        'chatRoomIds': FieldValue.arrayUnion([chatRoomId]),
      });
    } catch (e) {
      print('Error updating chat room IDs for users: $e');
    }
  }

 

Future<void> sendMessage(String chatRoomId, String messageText) async {
  try {
    FirebaseFirestore.instance.collection('messages').add(
      ChatModel(
        chatroomId: chatRoomId,
        senderId: FirebaseAuth.instance.currentUser!.uid, 
        text: messageText,
        timestamp: DateTime.now(),  
      ).toJson(),
    );
  } catch (e) {
    print("Error sending message: $e");
  }
}


Stream<List<ChatModel>> getChat(String chatRoomId) async* {
  try {
    final Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream =
        FirebaseFirestore.instance
            .collection('messages')
            .where('chatroomId', isEqualTo: chatRoomId)
            .orderBy('timestamp', descending: true)
            .snapshots();

    await for (QuerySnapshot<Map<String, dynamic>> chatSnapshot
        in chatsStream) {
      List<ChatModel> chats = chatSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();

        // Check if 'timestamp' is a String, and convert it to DateTime if needed
        dynamic timestamp = data['timestamp'];
        if (timestamp is Timestamp) {
          timestamp = timestamp.toDate();
        } else if (timestamp is String) {
          timestamp = DateTime.tryParse(timestamp);
        } else {
          // Handle other cases as needed
        }

        return ChatModel.fromJson(data..['timestamp'] = timestamp.toString());
      }).toList();
      yield chats;
    }
  } catch (e) {
    print('Error fetching chat: $e');
    throw e;
  }
}
  
 
 
 }
