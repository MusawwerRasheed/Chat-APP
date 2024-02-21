import 'dart:convert';

class Message {
    final String? chatroomId;
    final String? senderId;
    final String? text;
    final String? uid;
    final DateTime? timestamp;

    Message({
        this.chatroomId,
        this.senderId,
        this.text,
        this.uid,
        this.timestamp,
    });

    Message copyWith({
        String? chatroomId,
        String? senderId,
        String? text,
        String? uid,
        DateTime? timestamp,
    }) => 
        Message(
            chatroomId: chatroomId ?? this.chatroomId,
            senderId: senderId ?? this.senderId,
            text: text ?? this.text,
            uid: uid ?? this.uid,
            timestamp: timestamp ?? this.timestamp,
        );

    factory Message.fromRawJson(String str) => Message.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        chatroomId: json["chatroomId"],
        senderId: json["senderId"],
        text: json["text"],
        uid: json["uid"],
        timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    );

    Map<String, dynamic> toJson() => {
        "chatroomId": chatroomId,
        "senderId": senderId,
        "text": text,
        "uid": uid,
        "timestamp": timestamp?.toIso8601String(),
    };
}
