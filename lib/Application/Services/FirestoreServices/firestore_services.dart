import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:chat_app/Domain/Models/chat_model.dart';
import 'package:chat_app/Domain/Models/home_messages_model.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quick_router/quick_router.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:rxdart/rxdart.dart';
import 'package:logger/logger.dart';

class FirestoreServices {
  static HomeMessagesModel homeMessage = HomeMessagesModel();
  static final currentUser = FirebaseAuth.instance.currentUser!;
  static Future<QuerySnapshot<Map<String, dynamic>>> globalchatroomsSnapshot =
      FirebaseFirestore.instance.collection('chatrooms').get();

  static Future<UserModel> getAppbarData(String otherUid) async {
    print('inside getting appbar data');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: otherUid)
        .get();

    if (querySnapshot.docs.isEmpty) {
      throw Exception('No user found with uid: $otherUid');
    }

    var userData = querySnapshot.docs.first.data();
    UserModel user = UserModel.fromJson(userData as Map<String, dynamic>);
    return user;
  }

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

  // static Stream chatroomsStream() async* {
  //   List<String> chatroomidswith_ = [];
  //   List<String> chatroomids = [];
  //   List<String> otherUsersids = [];
  //   String currentUser = FirebaseAuth.instance.currentUser!.uid;

  //   try {
  //     final chatrooms = FirebaseFirestore.instance
  //         .collection('chatrooms')
  //         .where('users', arrayContains: currentUser)
  //         .snapshots();

  //     await for (final chatroom in chatrooms) {
  //       for (final doc in chatroom.docs) {
  //         chatroomidswith_.add(doc.id);
  //       }

  //       for (String chatroomid in chatroomidswith_) {
  //         List<String> chatroomstemp = chatroomid.split('_');
  //         chatroomids.addAll(chatroomstemp);
  //       }

  //       otherUsersids.addAll(chatroomids);
  //       otherUsersids.removeWhere((element) => element == currentUser);

  //       yield otherUsersids;
  //       // yield chatroomidswith_;
  //     }
  //   } catch (e) {
  //     print('error occured in chatrooms stream:  $e');
  //     throw e;
  //   }
  // }

  // static Stream usersDataStream() async* {
  //   try {
  //     List<String> otherUsers = [];
  //     List<HomeMessagesModel> homeMessagesList = [];
  //     List<Map<String, dynamic>> usersDataList = [];

  //     chatroomsStream().listen((event) async {
  //       otherUsers.addAll(event);

  //       final otherUsersSnaps = FirebaseFirestore.instance
  //           .collection('users')
  //           .where(FieldPath.documentId, whereIn: otherUsers)
  //           .snapshots();

  //       await for (final userdocs in otherUsersSnaps) {
  //         for (final user in userdocs.docs) {
  //           usersDataList.add(user.data());

  //           log(usersDataList.toString());
  //         }
  //       }
  //     });
  //   } catch (e) {
  //     log(e.toString() + "error in stream of Users data ");
  //   }
  // }

  Future<void> checkChatroom(
      BuildContext context, String userId, String otherUid) async {
    try {
      List<String> users = [userId, otherUid];
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
        if (roomUsers.contains(otherUid)) {
          chatRoomId = room.id;
          break;
        }
      }

      String chatRoomIds = generateChatRoomId(userId, otherUid!);
      print('>>>>>>>>>>>>>>>>>>>>>>>>>>> $chatRoomId');
      await context.to(ChatScreen(
        chatRoomId: chatRoomIds,
        otherUserId: otherUid,
      ));
    } catch (e, stackTrace) {
      print('Error in checkChatroom: $e');
      print(stackTrace);
    }
  }

  Future<List<UserModel>> searchUsers(String query, String currentUid) async {
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

  Future<void> sendMessage({
    String? chatRoomId,
    String? messageText,
    String? otherUserId,
    BuildContext? context,
    bool? isStreamEmpty,
    List<String>? imagePaths,
  }) async {
    try {
      String messageType =
          (imagePaths != null && imagePaths.isNotEmpty) ? 'image' : 'text';

      if (isStreamEmpty ?? false) {
        String chatroomId = await createChatRoom(
          FirebaseAuth.instance.currentUser!.uid,
          otherUserId!,
        );

        print('New chatroom created with ID: $chatroomId');

        String textMessage = messageText ?? '';

        List<String> imageUrls = [];
        if (imagePaths != null &&
            imagePaths.isNotEmpty &&
            messageType == 'image') {
          imageUrls = await _uploadImages(imagePaths);
        }

        String finalMessage = _constructMessageText(textMessage, imageUrls);
        print('Final Message: $finalMessage');

        FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(chatRoomId)
            .collection('chats')
            .add(
              ChatModel(
                chatroomId: chatroomId,
                senderId: FirebaseAuth.instance.currentUser!.uid,
                text: finalMessage,
                type: messageType,
                timestamp: null,
                seen: false,
                uid: otherUserId,
              ).toJson(),
            );

        await FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(chatRoomId)
            .set({
          'lastMessage': ChatModel(
            chatroomId: chatroomId,
            senderId: FirebaseAuth.instance.currentUser!.uid,
            text: finalMessage,
            type: messageType,
            timestamp: null,
            seen: false,
            uid: otherUserId,
          ).toJson(),
        }, SetOptions(merge: true));

        print('Message sent to new chat room.');
      } else {
        print('Stream is not empty, sending message to existing chat room...');

        String textMessage = messageText ?? '';

        List<String> imageUrls = [];
        if (imagePaths != null &&
            imagePaths.isNotEmpty &&
            messageType == 'image') {
          imageUrls = await _uploadImages(imagePaths);
        }

        String finalMessage = _constructMessageText(textMessage, imageUrls);

        FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(chatRoomId)
            .collection('chats')
            .add(
              ChatModel(
                chatroomId: chatRoomId,
                senderId: FirebaseAuth.instance.currentUser!.uid,
                text: finalMessage,
                type: messageType,
                timestamp: null,
                seen: false,
                uid: otherUserId,
              ).toJson(),
            );

        await FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(chatRoomId)
            .set({
          'lastMessage': ChatModel(
            chatroomId: chatRoomId,
            senderId: FirebaseAuth.instance.currentUser!.uid,
            text: finalMessage,
            type: messageType,
            timestamp: null,
            seen: false,
            uid: otherUserId,
          ).toJson(),
        }, SetOptions(merge: true));
        print('Message sent to existing chat room.');
      }
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  Future<List<String>> _uploadImages(List<String> imagePaths) async {
    List<String> imageUrls = [];

    try {
      List<firebase_storage.UploadTask> uploadTasks = [];

      for (String imagePath in imagePaths) {
        File imageFile = File(imagePath);
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        firebase_storage.Reference reference = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/$fileName.jpg');

        firebase_storage.UploadTask uploadTask = reference.putFile(imageFile);
        uploadTasks.add(uploadTask);
      }

      await Future.wait(uploadTasks);

      for (firebase_storage.UploadTask task in uploadTasks) {
        firebase_storage.TaskSnapshot snapshot = await task;
        String imageUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(imageUrl);
      }
    } catch (e) {
      print('Error uploading images: $e');
    }
    return imageUrls;
  }

  String _constructMessageText(String text, List<String> imageUrls) {
    print('inside constructing message');
    print(imageUrls);
    String finalMessage = text;
    if (imageUrls.isNotEmpty) {
      String concatenatedUrls = imageUrls.join(', ');
      print(concatenatedUrls);
      finalMessage += '\n\n$concatenatedUrls';
    }
    print('final message');
    print(finalMessage);
    return finalMessage;
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

  Future<void> updateMessageSeen(bool seen) async {
    try {
      print('inside the Message seen  >>>??? $seen');
      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        QuerySnapshot messages = await FirebaseFirestore.instance
            .collection('messages')
            .where('uid', isEqualTo: currentUser.uid)
            .get();

        for (DocumentSnapshot message in messages.docs) {
          await message.reference.update({'seen': seen});
        }
        print('success');
      } else {
        print('Current user is null');
      }
    } catch (e) {
      throw e;
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
      print('<><><><> ERROR <><><><>< inside is typing');
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
    Duration difference =
        Timestamp.now().toDate().difference(timestamp.toDate());
    if (difference.inSeconds < 60) {
      return 'Online';
    } else if (difference.inMinutes < 60) {
      return 'Last seen: ${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return 'Last seen: ${difference.inHours}h ago';
    } else if (difference.inDays < 10) {
      return 'Last seen: ${difference.inDays}D ago';
    }
    {
      return 'Last seen: ${timestamp.toDate()}';
    }
  }

  Stream<List<ChatModel>> getChat(String chatRoomId) async* {
    try {
      log('in get chat service $chatRoomId');
      final Stream<QuerySnapshot<Map<String, dynamic>>> chatsStream =
          FirebaseFirestore.instance
              .collection('chatrooms')
              .doc(chatRoomId)
              .collection('chats')
              .orderBy('timestamp', descending: true)
              .snapshots();

      await for (QuerySnapshot<Map<String, dynamic>> chatSnapshot
          in chatsStream) {
        List<ChatModel> chats = chatSnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();

          log('this executes');
          dynamic timestamp = data['timestamp'];
          if (timestamp is Timestamp) {
            timestamp = timestamp.toDate();
          } else if (timestamp is String) {
            timestamp = DateTime.tryParse(timestamp);
          } else {}
          return ChatModel.fromJson(data..['timestamp']);
        }).toList();
        log(chats.length.toString());
        yield chats;
      }
    } catch (e) {
      print('Error fetching chat: $e');
      throw e;
    }
  }

  static Stream<List<HomeMessagesModel>> homeMessagesStream() {
    log('inside the homemessagestream');

    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    
    final chatroomsSnapshots = FirebaseFirestore.instance
        .collection('chatrooms')
        .where("users", arrayContains: currentUser)
        .snapshots();
  
    // final usersSnapshots = FirebaseFirestore.instance
    //     .collection('users')
    //     .where('uid', isNotEqualTo: currentUser)
    //     .snapshots();
    final usersSnapshots  = FirebaseFirestore.instance.collection('users').snapshots();
    
    return Rx.combineLatest2<QuerySnapshot<Map<String, dynamic>>,
        QuerySnapshot<Map<String, dynamic>>, List<HomeMessagesModel>>(
      chatroomsSnapshots,
      usersSnapshots,
      (QuerySnapshot<Map<String, dynamic>> chatroomsSnap,
          QuerySnapshot<Map<String, dynamic>> usersSnap) {
        final List<HomeMessagesModel> homeMessages = [];

        for (final doc in chatroomsSnap.docs) {
          final lastMessageData =
              doc.data()['lastMessage'] as Map<String, dynamic>?;

          if (lastMessageData != null) {
            final lastMessageText = lastMessageData['text'] ?? '';
            final lastMessageSeen = lastMessageData['seen'] ?? false;
            final lastMessageTimestamp =
                lastMessageData['timestamp'] ?? Timestamp.now();
            final otherUserId = lastMessageData['uid'];
            final lastMessageType = lastMessageData['type'];
            final chatroomId = lastMessageData['chatroomId'];
            final userData = usersSnap.docs
                .firstWhere((userDoc) => userDoc.id == otherUserId);
            if (userData != null) {
              final displayName = userData['displayName'] ?? '';
              final imageUrl = userData['imageUrl'] ?? '';
              final isOnline = userData['isOnline'] ?? true;
              log(displayName);

              homeMessages.add(HomeMessagesModel(
                text: lastMessageText,
                seen: lastMessageSeen,
                timestamp: lastMessageTimestamp,
                displayName: displayName,
                imageUrl: imageUrl,
                isOnline: isOnline,
                uid: otherUserId,
                chatroomId: chatroomId,
              ));
            }
          }
        } 

    log('execution');
    return homeMessages;

      },
    );
  }
}

//todo

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
