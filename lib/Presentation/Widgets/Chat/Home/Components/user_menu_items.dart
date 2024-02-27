 
import 'package:flutter/material.dart';

class UserMenuItem extends StatelessWidget {
  final String displayName;
  final String photoUrl;
  final VoidCallback onTap;

  const UserMenuItem({
    required this.displayName,
    required this.photoUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(photoUrl),
        ),
        title: Text(displayName),
      ),
    );
  }
}
