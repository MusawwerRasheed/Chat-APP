

import 'package:chat_app/Application/Services/firestore_services.dart';
import 'package:chat_app/Data/DataSource/Resources/color.dart';
import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/ChatUsersCubit/chat_users.state.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/ChatUsersCubit/chat_users_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/UsersCubit/users_state.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chat_app/Data/DataSource/Resources/assets.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Widgets/Auth/LoginWithGoogle/login_screen.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/UsersCubit/users_cubit.dart';
 

 
class Home extends StatefulWidget {
  final User? currentUser;
  final BuildContext? context;
  final UserModel? userModel;
  
  Home({Key? key, this.context, this.currentUser, this.userModel}) : super(key: key);

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
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: TextField(
                              onChanged: searchUsers,
                              controller: userSearchController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0.r),
                                ),
                                prefixIcon: Image.asset(Assets.search!),
                                hintText: 'Search',
                                hintStyle: Styles.plusJakartaSans(context, color: AppColors.grey),
                                suffixIcon: Image.asset(Assets.filter!),
                                iconColor: AppColors.grey,
                                prefixIconColor: AppColors.grey,
                                suffixIconColor: AppColors.blue,
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
                              height: 40.h,
                              width: 40,
                              color: AppColors.blackColor,
                              child: widget.currentUser?.photoURL != null
                                ? Image.network(widget.currentUser!.photoURL!)
                                : Center(
                                    child: Text(
                                      _getInitials(widget.currentUser?.email ?? ""),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Messages',
                      style: Styles.plusJakartaSans(
                        context,
                        fontSize: 20.h,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackColor,
                      ),
                    ),
                    BlocConsumer<ChatUsersCubit, ChatUsersState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is ChatUsersLoadedState) {
<<<<<<< HEAD
                          return Container(
                            height: 380.h,
=======
                          return SizedBox(
                            height: 380,
>>>>>>> bb410cfab04688b8ed36a4be4ce28243e6bad463
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                final user = state.users[index];
                                print(user.displayName!);
                                return GestureDetector(
                                  onTap: () {
                                    FirestoreServices().checkChatroom(
                                      context, currentUser!.uid, user!
                                    );
                                  },
                                  child: Container(
                                    height: 50.h,
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(30),
                                          child: Image.network(
                                            user.imageUrl!,
                                            width: 40.w,
                                            height: 40.h,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        SizedBox(
                                          width: 160.w,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                user.displayName!,
                                                style: Styles.plusJakartaSans(
                                                  context,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Text(
                                                'Latest Message'!,
                                                style: Styles.plusJakartaSans(
                                                  context,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 60,
                                        ),
                                        // Column(
                                        //   children: [
                                        //     Container(
                                        //       height: 20.h,
                                        //       width: 20.w,
                                        //       decoration: BoxDecoration(
                                        //         color: AppColors.blue,
                                        //         borderRadius: BorderRadius.circular(40.r),
                                        //       ),
                                        //       child: Center(
                                        //         child: Text(
                                        //           '1',
                                        //           style: Styles.plusJakartaSans(
                                        //             context,fontSize: 12, 
                                        //             color: AppColors.white, 
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     Text(
                                        //       '10.00',
                                        //       style: Styles.plusJakartaSans(
                                        //         context,
                                        //         fontSize: 12
                                        //       ),
                                        //     )
                                        //   ],
                                        // )



                                        
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (BuildContext context, int index) {
                                return const SizedBox(height: 20);
                              },
                              itemCount: state.users.length,
                            ),
                          );
                        } else {
                          return const Center(child: SizedBox(child: Text('No Messages yet'),));
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
    print('inside searching >>>>>>>>>>>>>>>>>>>>');
    searchValueNotifier.value = userSearchController.text;
    context.read<UsersCubit>().getUsers(value);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 200.h,
            width: 200.w,
            child: BlocConsumer<UsersCubit, UsersState>(
              builder: (context, state) {
                if (state is UsersLoadedState) {
                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final UserModel user = state.users[index];
                     print(FirebaseAuth.instance.currentUser!.uid);
                      return GestureDetector(
                        onTap: () {
                          FirestoreServices().checkChatroom(context, FirebaseAuth.instance.currentUser!.uid , user);
                        },
                        child: ListTile(
  title: Row(
    children: [
      user.imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                user.imageUrl!,
                width: 30.w,
                height: 30.h,
              ),
            )
          : Container(
              width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: Colors.blue, // You can set any desired color
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  user.displayName != null && user.displayName!.isNotEmpty
                      ? user.displayName![0].toUpperCase()
                      : "",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
      const SizedBox(
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
              listener: (BuildContext context, UsersState state) {},
            ),
          ),
        );
      },
    );
  }

  String _getInitials(String? email) {
    if (email == null || email.isEmpty) {
      return "";
    }

    List<String> nameSplit = email.split('@');
    if (nameSplit.isEmpty) {
      return "";
    }

    String initials = "";
    List<String> parts = nameSplit[0].split(RegExp(r"\s+"));
    if (parts.isNotEmpty) {
      initials = parts[0][0].toUpperCase();
      if (parts.length > 1) {
        initials += parts[1][0].toUpperCase();
      }
    }
    return initials;
  }
}



