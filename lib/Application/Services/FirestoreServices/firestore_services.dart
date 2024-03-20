import 'dart:async';
import 'package:chat_app/Domain/Models/chat_model.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_quick_router/quick_router.dart';

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
      print('inside get chat users');
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('chatrooms')
          .where('users', arrayContains: FirebaseAuth.instance.currentUser!.uid)
          .get();

      List<String> userIds = [];
      print(querySnapshot.docs.length);

      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? chatroomData =
            doc.data() as Map<String, dynamic>?;

        if (chatroomData != null) {
          List<dynamic>? users = chatroomData['users'];

          if (users != null && users.isNotEmpty) {
            String otherUsersIds = users.firstWhere(
              (userId) => userId != FirebaseAuth.instance.currentUser!.uid,
              orElse: () => '',
            );

            if (otherUsersIds.isNotEmpty) {
              var chatExists = querySnapshot.docs.any((chat) =>
                  (chat.data() as Map<String, dynamic>?)?['users']
                          ?.contains(FirebaseAuth.instance.currentUser!.uid) ==
                      true &&
                  (chat.data() as Map<String, dynamic>?)?['users']
                          ?.contains(otherUsersIds) ==
                      true);

              if (chatExists) {
                userIds.add(otherUsersIds);
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

      print(users.length.toString());
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
      await context.to(ChatScreen(
        chatRoomId: chatRoomIds,
        otherUser: otherUser,
      ));
    } catch (e, stackTrace) {
      print('Error in checkChatroom: $e');
      print(stackTrace);
    }
  }

  Future<List<UserModel>> searchUsers(String query, String currentUid) async {
    print('inside search users');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(
          'uid',
          isNotEqualTo: currentUid,
        )
        .get();

    print(querySnapshot.docs.length);
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

  Future<void> sendMessage(String? chatRoomId, String? messageText,
      String? otherUserId, BuildContext? context, bool? isStreamEmpty) async {
    try {
      if (isStreamEmpty!) {
        print('Stream is empty, creating new chat room...');
        String chatroomid = await createChatRoom(
            FirebaseAuth.instance.currentUser!.uid, otherUserId!);
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

  Future<void> updateOnlineLastSeen(
      bool onlineStatus, Timestamp lastSeen) async {
    try {
      print('inside the updating oinle seen ???????????????????');
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'isOnline': onlineStatus, 'lastSeen': lastSeen});
    } catch (e) {
      throw (e);
    }
  }

  Future<void> updateTypingStatus(String userId, bool typingStatus) async {
    try {
      print('inside isTyping services');
      print(typingStatus);
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'isTyping': typingStatus}).then((_) {
        print('isTyping status updated successfully');
      }).catchError((error) {
        print('Failed to update isTyping status: $error');
      });
    } catch (e) {
      print('<><><> ERROR <><><><>< inside is typing');
      throw e;
    }
  }












  Stream<bool> getOnlineStatus(String otherUserId) {
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc(otherUserId);
      return docRef
          .snapshots()
          .map((snapshot) {
            if (snapshot.exists) {
              Map<String, dynamic> data =
                  snapshot.data() as Map<String, dynamic>;
              return data['isOnline'] ?? false;
            } else
              return false;
          })
          .distinct()
          .cast<bool>();
    } catch (e) {
      print('error in online status services');
      return Stream<bool>.empty();
    }
  }




  Stream<bool> getTypingStream(String otherUserId) {
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc(otherUserId);

      return docRef
          .snapshots()
          .map((snapshot) {
            if (snapshot.exists) {
              Map<String, dynamic> data =
                  snapshot.data() as Map<String, dynamic>;

              return data['isTyping'] ?? false;
            } else {
              return false;
            }
          })
          .distinct()
          .cast<bool>();
    } catch (e) {
      print('Error getting typing status: $e');
      return Stream<bool>.empty();
    }
  }




Stream<String> getLastSeen(String otherUserId) {
  try {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(otherUserId);
    return docRef
        .snapshots()
        .map((snapshot) {
          if (snapshot.exists) {
            Map<String, dynamic> data =
                snapshot.data() as Map<String, dynamic>;
            Timestamp lastSeen = data['lastSeen'] ?? Timestamp.now();
            return _formatLastSeen(lastSeen);
          } else {
            return 'Last seen: never';
          }
        })
        .distinct()
        .cast<String>();
  } catch (e) {
    print('error in online status services');
    return Stream<String>.empty();
  }
}

String _formatLastSeen(Timestamp timestamp) {
  Duration difference = Timestamp.now().toDate().difference(timestamp.toDate());
  if (difference.inSeconds < 60) {
    return 'Online';
  } else if (difference.inMinutes < 60) {
    return 'Last seen: ${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return 'Last seen: ${difference.inHours}h ago';
  } else if(difference.inDays<10){
    return 'Last seen: ${difference.inDays}D ago';
  }
   {
    return 'Last seen: ${timestamp.toDate()}';
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



class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}





 
 
