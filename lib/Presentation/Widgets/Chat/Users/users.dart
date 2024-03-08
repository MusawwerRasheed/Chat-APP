import 'package:chat_app/Presentation/Common/custom_text.dart';
import 'package:flutter/material.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Center(
            child: CustomText(customText: 'List of users'),
          )
        ],
      ),
    );
  }
}
