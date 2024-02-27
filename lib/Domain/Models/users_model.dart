import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel {

     UserModel({
        this.displayName,
        this.email,
        this.imageUrl,
        this.uid,
   
    });
 
    final String? displayName;
    final String? email;
    final String? imageUrl;
    final String? uid;
  


    UserModel copyWith({
        String? displayName,
        String? email,
        String? imageUrl,
        String? uid,
        DateTime? creationDate,
    }) => 
        UserModel(
            displayName: displayName ?? this.displayName,
            email: email ?? this.email,
            imageUrl: imageUrl ?? this.imageUrl,
            uid: uid ?? this.uid,
       
        );

    factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
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
    
     
     factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      displayName: data['displayName'] ?? "",
      imageUrl: data['imageUrl'] ?? "",
    );
  } 

 

}
