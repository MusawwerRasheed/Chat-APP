import 'dart:convert';

class Chatroom {
    final List<String>? users;

    Chatroom({
        this.users,
    });

    Chatroom copyWith({
        List<String>? users,
    }) => 
        Chatroom(
            users: users ?? this.users,
        );

    factory Chatroom.fromRawJson(String str) => Chatroom.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Chatroom.fromJson(Map<String, dynamic> json) => Chatroom(
        users: json["users"] == null ? [] : List<String>.from(json["users"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "users": users == null ? [] : List<dynamic>.from(users!.map((x) => x)),
    };
}
