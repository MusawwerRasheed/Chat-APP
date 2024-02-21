import 'dart:convert';

class Users {
    final String? displayName;
    final String? email;
    final String? imageUrl;
    final String? uid;

    Users({
        this.displayName,
        this.email,
        this.imageUrl,
        this.uid,
    });

    Users copyWith({
        String? displayName,
        String? email,
        String? imageUrl,
        String? uid,
    }) => 
        Users(
            displayName: displayName ?? this.displayName,
            email: email ?? this.email,
            imageUrl: imageUrl ?? this.imageUrl,
            uid: uid ?? this.uid,
        );

    factory Users.fromRawJson(String str) => Users.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Users.fromJson(Map<String, dynamic> json) => Users(
        displayName: json["displayName"],
        email: json["email"],
        imageUrl: json["imageUrl"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "displayName": displayName,
        "email": email,
        "imageUrl": imageUrl,
        "uid": uid,
    };
}
