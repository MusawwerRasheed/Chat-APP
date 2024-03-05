import 'package:chat_app/Application/Services/firestore_services.dart';
import 'package:chat_app/Data/DataSource/Resources/color.dart';
import 'package:chat_app/Data/DataSource/Resources/styles.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/ChatUsersCubit/chat_users.state.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/ChatUsersCubit/chat_users_cubit.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/Components/custom_alert_dialog.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/Components/custom_image_avatar.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Home/Controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:chat_app/Data/DataSource/Resources/assets.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Widgets/Chat/Components/Users/UsersCubit/users_cubit.dart';



class Home extends StatefulWidget {
  final User? currentUser;
  final BuildContext? context;
  final UserModel? userModel;

  Home({Key? key, this.context, this.currentUser, this.userModel})
      : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
            HomeController().signOut(context);
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
                                    borderRadius: BorderRadius.circular(50)),
                                prefixIcon: Image.asset(Assets.search!),
                                hintText: 'Search Users',
                                hintStyle: Styles.plusJakartaSans(
                                  context,
                                  color: AppColors.grey,
                                ),
                                prefixIconColor: AppColors.grey,
                                suffixIconColor: AppColors.grey,
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
                                        HomeController().getFirst(
                                            widget.currentUser?.email ?? 'A@'),
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
                      listener: (context, state) {
                        if (state is ChatUsersLoadedState) {}
                      },
                      builder: (context, state) {
                        if (state is ChatUsersLoadedState) {
                          return Container(
                            height: 500.h,
                            child: ListView.separated(
                              itemBuilder: (context, index) {
                                final user = state.users[index];
                                print(user.displayName!);
                                return GestureDetector(
                                  onTap: () {
                                    FirestoreServices().checkChatroom(
                                        context, currentUser!.uid, user!);
                                  },
                                  child: CustomImageAvatar(user: user),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(height: 20);
                              },
                              itemCount: state.users.length,
                            ),
                          );
                        } else {
                          return const Center(
                              child: SizedBox(
                            child: Text('No Messages yet'),
                          ));
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

  void searchUsers(String value) {
    searchValueNotifier.value = userSearchController.text;
    context.read<UsersCubit>().getUsers(value);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlertDialog();
      },
    );
  }

@override
void dispose(){
  super.dispose(); 
}

}

 
 