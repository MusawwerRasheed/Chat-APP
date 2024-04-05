import 'package:flutter/material.dart';
 

class MessagesListTile extends StatefulWidget {


  final Widget? leading;
  final Widget? title;
  final Widget? subTitle;
  final Widget? trailing;
  final bool? isThreeLines;
  final ListTileStyle? style;


  const MessagesListTile({
    super.key,
    this.leading,
    this.title,
    this.isThreeLines,
    this.style,
    this.subTitle,
    this.trailing,
  });

  @override

  State<MessagesListTile> createState() => _MessagesListTileState();
}

class _MessagesListTileState extends State<MessagesListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.leading ?? const Icon(Icons.person),
      title: widget.title ??  const Text('a'),
      subtitle: widget.subTitle ?? Text('a'),
      trailing: widget.trailing?? Text('a'),
      isThreeLine: widget.isThreeLines?? false,
      style: widget.style ??  ListTileStyle.list,
    );
  }
}
