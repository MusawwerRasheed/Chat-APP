import 'package:chat_app/Domain/Models/chat_model.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter/material.dart';

class FirestoreServices {
  static final currentUser = FirebaseAuth.instance.currentUser!;

  static Future<QuerySnapshot<Map<String, dynamic>>> globalchatroomsSnapshot =
      FirebaseFirestore.instance.collection('chatrooms').get();

  static Future<void> storeUserdata(UserModel? userModel) async {
    try {
      if (userModel != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userModel.uid)
            .set(userModel.toJson());
      } else {
        throw Exception("User model is null");
      }
    } catch (e) {
      print('Error storing user data: $e');
      throw e;
    }
  }

  Future<List<UserModel>> getChatusers() async {
    try {
      print('inside get chat users ');
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chatrooms')
          .where('users', arrayContains: currentUser.uid)
          .get();

      List<String> userIds = [];

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null) {
          List<dynamic>? users = data['users'];
          if (users != null && users.isNotEmpty) {
            String otherUserId = users.firstWhere(
                (userId) => userId != currentUser.uid,
                orElse: () => '');
            if (otherUserId.isNotEmpty) {
              var chatExists = querySnapshot.docs.any((chat) =>
                  (chat.data() as Map<String, dynamic>?)?['users']
                          ?.contains(currentUser.uid) ==
                      true &&
                  (chat.data() as Map<String, dynamic>?)?['users']
                          ?.contains(otherUserId) ==
                      true);
              if (chatExists) {
                userIds.add(otherUserId);
              }
            }
          }
        }
      });

      QuerySnapshot usersQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds)
          .get();

      List<UserModel> users = usersQuerySnapshot.docs.map((user) {
        return UserModel.fromJson(user.data() as Map<String, dynamic>);
      }).toList();
      return users;
    } catch (e) {
      print('Error getting chat users: $e');
      throw e;
    }
  }

  Future<void> checkChatroom(
      BuildContext context, String userId, UserModel otherUser) async {
    try {
      List<String> users = [userId, otherUser.uid!];
      final QuerySnapshot chatroomsSnapshot = await FirebaseFirestore.instance
          .collection('chatrooms')
          .where('users', arrayContainsAny: users)
          .get();

      List<QueryDocumentSnapshot> chatrooms = chatroomsSnapshot.docs;
      String? chatRoomId;

      for (var room in chatrooms) {
        Map<String, dynamic>? roomData = room.data() as Map<String, dynamic>?;
        if (roomData == null) {
          continue;
        }
        List<dynamic> roomUsers = roomData['users'];
        if (roomUsers.contains(otherUser.uid)) {
          chatRoomId = room.id;
          break;
        }
      }

      String chatRoomIds = generateChatRoomId(userId, otherUser.uid!);
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>> $chatRoomId');
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ChatScreen(chatRoomId: chatRoomIds, otherUser: otherUser),
        ),
      );
    } catch (e, stackTrace) {
      print('Error in checkChatroom: $e');
      print(stackTrace);
    }
  }

  Future<List<UserModel>> searchUsers(String query) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(
          'uid',
          isNotEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .get();

    List<DocumentSnapshot> allUsers = querySnapshot.docs.toList();

    List<UserModel> users = allUsers.map((userDoc) {
      return UserModel.fromSnapshot(userDoc);
    }).where((user) {
      String displayName = user.displayName ?? "";
      return displayName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    return users;
  }

  static Future<String> createChatRoom(
      String userId, String otherUserId) async {
    String chatRoomId = generateChatRoomId(userId, otherUserId);

    try {
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
      throw e;
    }

    return chatRoomId;
  }

  static String generateChatRoomId(String userId, String otherUserId) {
    List<String> userIds = [userId, otherUserId];
    userIds.sort();
    return '${userIds[0]}_${userIds[1]}';
  }

  static Future<void> updateChatRoomIdsForUsers(
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

Future<void> sendMessage(String? chatRoomId, String? messageText, String? otherUserId, BuildContext? context, bool? isStreamEmpty) async {
  print('inside the send message ????> >>> >> ');
  print('Chat Room ID: $chatRoomId');
  print('Is Stream Empty: $isStreamEmpty');

  try {
    if (isStreamEmpty!) {
      print('Stream is empty, creating new chat room...');
      String chatroomid = await createChatRoom(currentUser.uid, otherUserId!);
      print('New chatroom created with ID: $chatroomid');

      FirebaseFirestore.instance.collection('messages').add(
        ChatModel(
          chatroomId: chatroomid,
          senderId: FirebaseAuth.instance.currentUser!.uid,
          text: messageText,
          timestamp: DateTime.now(),
          uid: otherUserId,
        ).toJson(),
      );
      print('Message sent to new chat room.');
    } else {
      print('Stream is not empty, sending message to existing chat room...');
      FirebaseFirestore.instance.collection('messages').add(
        ChatModel(
          chatroomId: chatRoomId,
          senderId: FirebaseAuth.instance.currentUser!.uid,
          text: messageText,
          timestamp: DateTime.now(),
          uid: otherUserId,
        ).toJson(),
      );
      print('Message sent to existing chat room.');
    }
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

          dynamic timestamp = data['timestamp'];
          if (timestamp is Timestamp) {
            timestamp = timestamp.toDate();
          } else if (timestamp is String) {
            timestamp = DateTime.tryParse(timestamp);
          } else {}

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
