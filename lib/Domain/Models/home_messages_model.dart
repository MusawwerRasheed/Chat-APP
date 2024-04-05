import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeMessagesModel {
  final String? displayName;
  final String? email;
  final String? imageUrl;
  final String? uid;
  final bool? isTyping;
  final bool? isOnline;
  final Timestamp? lastSeen;
  final String? chatroomId;
  final String? senderId;
  final String? text;
  final String? chatUid;
  final String? type;
  final bool? seen;
  final int? count;
  final String? lastMessage;
  final String? latestMessageType;
  final Timestamp? timestamp;

  HomeMessagesModel({
    this.displayName,
    this.email,
    this.imageUrl,
    this.uid,
    this.isTyping,
    this.count,
    this.isOnline,
    this.lastSeen,
    this.chatroomId,
    this.senderId,
    this.text,
    this.chatUid,
    this.type,
    this.seen,
    this.lastMessage,
    this.latestMessageType,
    this.timestamp,
  });

  factory HomeMessagesModel.fromRawJson(String str) =>
      HomeMessagesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HomeMessagesModel.fromJson(Map<String, dynamic> json) =>
      HomeMessagesModel(
        displayName: json["displayName"],
        email: json["email"],
        imageUrl: json["imageUrl"],
        uid: json["uid"],
        isTyping: json["isTyping"],
        isOnline: json["isOnline"],
        lastSeen: json["lastSeen"],
        chatroomId: json["chatroomId"],
        senderId: json["senderId"],
        text: json["text"],
        chatUid: json["chatUid"],
        type: json["type"],
        seen: json['seen'],
        count: json['count'],
        lastMessage: json['lastMessage'],
        latestMessageType: json['lastMessageType'],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "email": email,
        "imageUrl": imageUrl,
        "uid": uid,
        "isTyping": isTyping,
        "isOnline": isOnline,
        "lastSeen": lastSeen,
        "chatroomId": chatroomId,
        "senderId": senderId,
        "text": text,
        "count": count,
        "chatUid": chatUid,
        "type": type,
        "seen": seen,
        "lastMessage": lastMessage,
        "lastMessageType": latestMessageType,
        "timestamp": timestamp,
      };
}
