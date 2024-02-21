import 'package:chat_app/Data/Repository/DataSource/Resources/assets.dart';
import 'package:chat_app/Domain/Models/chatroom_model.dart';
import 'package:chat_app/Presentation/Widgets/Auth/login_screen.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/chat_screen.dart';
import 'package:chat_app/Presentation/Widgets/Chat/RecentChats/Components/user_menu_items.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RecentChats extends StatefulWidget {
  final User user;

  RecentChats({Key? key, required this.user}) : super(key: key);

  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  TextEditingController userSearchController = TextEditingController();
  final ValueNotifier<List<DocumentSnapshot>> _filteredUsers =
      ValueNotifier<List<DocumentSnapshot>>([]);
  final ValueNotifier<List<DocumentSnapshot>> _users =
      ValueNotifier<List<DocumentSnapshot>>([]);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<DocumentSnapshot> allUsers = querySnapshot.docs.toList();

    List<DocumentSnapshot> filteredUsers =
        allUsers.where((user) => user.id != currentUser?.uid).toList();

    _users.value = filteredUsers;
    _filteredUsers.value = allUsers;
  }

  Future<List<DocumentSnapshot>> filterRecent(User user) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('users', arrayContains: user.uid)
        .get();

    List<String> userIds = querySnapshot.docs.map((doc) {
      List<dynamic>? users = (doc.data() as Map<String, dynamic>)['users'];
      if (users != null && users.isNotEmpty) {
        return users.firstWhere((userId) => userId != user.uid) as String;
      }
      return '';
    }).toList();

    QuerySnapshot usersQuerySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .get();

    List<DocumentSnapshot> filteredRecentUsers = usersQuerySnapshot.docs;

    return filteredRecentUsers;
  }

  void _filterUsers(String query) {
    List<DocumentSnapshot> filteredUsers = _users.value.where((user) {
      String displayName = user['displayName'];
      return displayName.toLowerCase().contains(query.toLowerCase());
    }).toList();

    _filteredUsers.value = filteredUsers;

    _buildPopupMenu();
  }

  void _buildPopupMenu() {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(70, 100, 70, 150),
      items: _filteredUsers.value.map((user) {
        final DocumentSnapshot userall = user;
        final displayName = user['displayName'] ?? '';
        final photoUrl = user['imageUrl'] ?? '';
        return PopupMenuItem(
          child: UserMenuItem(
            displayName: displayName,
            photoUrl: photoUrl,
            onTap: () async {
              final currentUserId = widget.user.uid;
              final otherUserId = user.id;

              final chatRoomId = generateChatRoomId(currentUserId, otherUserId);
              final chatRoomSnapshot = await FirebaseFirestore.instance
                  .collection('chatrooms')
                  .doc(chatRoomId)
                  .get();

              if (chatRoomSnapshot.exists) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      chatRoomId: chatRoomId,
                      otherUser: userall,
                    ),
                  ),
                );
              } else {
                await createChatRoom(currentUserId, otherUserId);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      chatRoomId: chatRoomId,
                      otherUser: userall,
                    ),
                  ),
                );
              }
            },
          ),
        );
      }).toList(),
    );
  }

  Future<void> createChatRoom(String userId, String otherUserId) async {
    try {
      String chatRoomId = generateChatRoomId(userId, otherUserId);

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
    }
  }

  String generateChatRoomId(String userId, String otherUserId) {
    List<String> userIds = [userId, otherUserId]..sort();

    return '${userIds[0]}_${userIds[1]}';
  }

  Future<void> updateChatRoomIdsForUsers(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 208, 234, 255),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              onChanged: _filterUsers,
                              controller: userSearchController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Image.asset(Assets.search!),
                                hintText: 'Search',
                                hintStyle: const TextStyle(color: Colors.grey),
                                suffixIcon: Image.asset(Assets.filter!),
                                iconColor: Colors.grey,
                                prefixIconColor: Colors.grey,
                                suffixIconColor: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            showMenu(
                              context: context,
                              position:
                                  const RelativeRect.fromLTRB(100, 100, 0, 0),
                              items: <PopupMenuEntry>[
                                const PopupMenuItem(
                                  child: Text('logout'),
                                  value: 'logout',
                                ),
                              ],
                            ).then((selectedValue) {
                              if (selectedValue != null) {
                                switch (selectedValue) {
                                  case 'logout':
                                    _signOut();
                                    break;
                                }
                              }
                            });
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Container(
                              height: 40,
                              width: 40,
                              color: Colors.red,
                              child: Image.network(widget.user.photoURL ??
                                  'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?size=338&ext=jpg&ga=GA1.1.1700460183.1708387200&semt=ais'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Messages',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      height: 380,
                      child: FutureBuilder<List<DocumentSnapshot>>(
                        future:
                            filterRecent(FirebaseAuth.instance.currentUser!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          List<DocumentSnapshot>? recentChatrooms =
                              snapshot.data;
                          if (recentChatrooms == null ||
                              recentChatrooms.isEmpty) {
                            return Center(child: Text('No recent chatrooms'));
                          }

                          return ListView.separated(
                            itemBuilder: (context, index) {
                              final user = recentChatrooms[index];
                              return GestureDetector(
                                onTap: () async {
                                  final currentUserId = widget.user.uid;
                                  final otherUserId = user.id;

                                  final chatRoomId = generateChatRoomId(currentUserId, otherUserId);
                                  final chatRoomSnapshot = await FirebaseFirestore.instance
                                      .collection('chatrooms')
                                      .doc(chatRoomId)
                                      .get();

                                  if (chatRoomSnapshot.exists) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          chatRoomId: chatRoomId,
                                          otherUser: user,
                                        ),
                                      ),
                                    );
                                  } else {
                                    await createChatRoom(currentUserId, otherUserId);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                          chatRoomId: chatRoomId,
                                          otherUser: user,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        user['imageUrl'] ?? '',
                                        height: 60,
                                        width: 60,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user['displayName'] ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const Text('Last Message')
                                      ],
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          width: 25,
                                          height: 25,
                                          child: const Center(
                                            child: Text(
                                              '1',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        const Text('10.00')
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return const SizedBox(height: 20);
                            },
                            itemCount: recentChatrooms.length,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (error) {
      print('Error signing out: $error');
    }
  }
}
