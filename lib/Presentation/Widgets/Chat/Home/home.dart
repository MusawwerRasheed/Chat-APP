import 'package:chat_app/Application/Services/firestore_services.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatCubit/chat_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatCubit/chat_state.dart';
import 'package:chat_app/Presentation/Widgets/Chat/ChatScreen/chat_screen.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/ChatUsersCubit/chat_users.state.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/ChatUsersCubit/chat_users_cubit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quick_router/quick_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chat_app/Data/Repository/DataSource/Resources/assets.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Widgets/Auth/login_screen.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/UsersCubit/users_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/UsersCubit/users_state.dart';

class Home extends StatefulWidget {
  final User? currentUser;
  final UserModel? userModel;
  Home({Key? key, this.currentUser, this.userModel}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final currentUser = FirebaseAuth.instance.currentUser;

  ValueNotifier<String> searchValueNotifier = ValueNotifier<String>('');

  TextEditingController userSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    context.read<ChatUsersCubit>().getChatUsers();
  }

  void _buildPopupMenu() {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
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
                              onChanged: searchUsers,
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
                          onTap: _buildPopupMenu,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: Container(
                              height: 40,
                              width: 40,
                              color: Colors.red,
                              child: Image.network(widget
                                      .currentUser?.photoURL ??
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
                    BlocConsumer<ChatUsersCubit, ChatUsersState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is ChatUsersLoadedState) {
                          return SizedBox(
                            height: 380,
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                final user = state.users[index];
                                print(user.displayName!);
                                return GestureDetector(
                                  onTap: () {
                                    FirestoreServices().checkChatroom(
                                        context, currentUser!.uid, user!);
                                  },
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Image.network(
                                            user.imageUrl!,
                                            width: 40,
                                            height: 40,
                                          )),
                                      const SizedBox(
                                        width: 15,
                                      ),

                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.displayName!,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Latest Message'!,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 60,
                                      ),
                                      Column(
                                        children: [
                                          Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                            ),
                                            child: const Center(
                                                child: Text('1',
                                                    style: TextStyle(
                                                        color: Colors.white))),
                                          ),
                                          const Text(
                                            '10.00',
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          )
                                        ],
                                      )
                                      // Your UI for each user
                                    ],
                                  ),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 20);
                              },
                              itemCount: state
                                  .users.length, // Using state.users.length
                            ),
                          );
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
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

  void searchUsers(String value) {
    
 print('inside seraching >>>>>>>>>>>>>>>>>>>>'); 
    searchValueNotifier.value = userSearchController.text;
    context.read<UsersCubit>().getUsers(searchValueNotifier.value);
 
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 200,
            width: 200,
            child: BlocBuilder<UsersCubit, UsersState>(
              builder: (context, state) {
                if (state is UsersLoadedState) {
                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return GestureDetector(
                         onTap: () {
                                    FirestoreServices().checkChatroom(
                                        context, currentUser!.uid, user);
                                  },
                        child: ListTile(
                          title: Row(
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(
                                    user.imageUrl!,
                                    width: 30,
                                    height: 30,
                                  )),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                user.displayName ?? "",
                                style: TextStyle(),
                              ),
                            ],
                          ),
                                             
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        );
      },
    );
  }
}
