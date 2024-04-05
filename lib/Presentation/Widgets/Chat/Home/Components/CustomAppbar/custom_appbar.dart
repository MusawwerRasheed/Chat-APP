 
import 'package:flutter/material.dart';
class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {

  final Color? backgroundcolor;
  final Widget? leading;
  final bool? autoImply;
  final Widget? title;
  final bool? titleCentered;
  final Widget widget;

   const CustomAppbar({
    Key? key,
    required this.widget,
    this.titleCentered,
    this.leading,
    this.title,
    this.backgroundcolor,
    this.autoImply,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundcolor ?? Colors.white,
      leading: leading ??
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Icon(Icons.arrow_back),
              ),
            ),
          ),
      automaticallyImplyLeading: autoImply ?? false,
      centerTitle: titleCentered ?? true,
      title: SizedBox(
        child: widget),
    );
  }
 
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
