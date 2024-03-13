import 'package:flutter/material.dart';

class ChatScreenController {
  final ScrollController? scrollController;

  ChatScreenController(this.scrollController);

  void scrollToBottom() {
    scrollController!.animateTo(
      scrollController!.position.minScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutQuint,
    );
  }
}
