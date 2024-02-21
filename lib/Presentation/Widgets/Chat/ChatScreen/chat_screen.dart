import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String? chatRoomId;
  final DocumentSnapshot otherUser;

  ChatScreen({Key? key, required this.chatRoomId, required this.otherUser})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 243, 243),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 245, 243, 243),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 238, 238, 238),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: SizedBox(
          child: Row(
            children: [
              Text(
                widget.otherUser['displayName']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 20,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  width: 40,
                  height: 40,
                  color: Colors.red,
                  child: Image.network(
                    widget.otherUser['imageUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('chatroomId', isEqualTo: widget.chatRoomId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView(
                  reverse: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Container(
                          margin: data['uid'] == widget.otherUser.id
                              ? EdgeInsets.only(right: 120)
                              : EdgeInsets.only(left: 120),
                          padding: EdgeInsets.only(left: 10, top: 8),
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: data['uid'] == widget.otherUser.id
                                ? Colors.blue
                                : Color.fromARGB(255, 189, 185, 174),
                          ),
                          child: Text(
                            data['text'],
                            style: TextStyle(color: Colors.white),
                          )),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 20, left: 30),
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Message',
                      hintStyle: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 8, 8, 8),
                      ),
                      prefixIcon: Icon(
                        Icons.face_outlined,
                        color: Colors.grey[500],
                      ),
                      border: InputBorder.none,
                    ),
                    controller: inputController,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (inputController.text.isNotEmpty) {
                    sendMessage(inputController.text);
                    inputController.clear();
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blue,
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void sendMessage(String messageText) {
    try {
      FirebaseFirestore.instance.collection('messages').add({
        'uid': widget.otherUser.id,
        'chatroomId': widget.chatRoomId,
        'senderId': FirebaseAuth.instance.currentUser!.uid,
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }
}
