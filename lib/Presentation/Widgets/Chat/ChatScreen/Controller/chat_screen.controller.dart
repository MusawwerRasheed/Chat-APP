import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
 

class ChatScreenController {
  final ScrollController? scrollController;
  File? imageFile;

  ChatScreenController({this.scrollController, this.imageFile});

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      
      print("Image path: ${pickedFile.path}");
    }
  }

  void scrollToBottom() {
    scrollController!.animateTo(
      scrollController!.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutQuint,
    );
  }
}

 