import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String? chatroomId;
  final String? senderId;
  final String? text;
  final String? uid;
  final String? type;
  final bool? seen;
  final Timestamp? timestamp;

  ChatModel({
    this.chatroomId,
    this.senderId,
    this.seen,
    this.text,
    this.uid,
    this.type,
    this.timestamp,
  });

  ChatModel copyWith({
    String? chatroomId,
    String? senderId,
    String? text,
    String? uid,
    Timestamp? timestamp,
  }) =>
      ChatModel(
        chatroomId: chatroomId ?? this.chatroomId,
        senderId: senderId ?? this.senderId,
        text: text ?? this.text,
        uid: uid ?? this.uid,
        timestamp: timestamp ?? this.timestamp,
      );

  factory ChatModel.fromRawJson(String str) =>
      ChatModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        chatroomId: json["chatroomId"],
        senderId: json["senderId"],
        text: json["text"],
        uid: json["uid"],
        type: json["type"],
        seen: json['seen'],
        timestamp: json["timestamp"] ,
      );

  Map<String, dynamic> toJson() => {
        "chatroomId": chatroomId,
        "senderId": senderId,
        "text": text,
        "uid": uid,
        "type": type,
        "seen": seen,
        "timestamp": FieldValue.serverTimestamp(),
      };
}
