import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreenController {
  final ScrollController? scrollController;

  ChatScreenController({
    this.scrollController,
  });

  Future<List<String>> pickImages(BuildContext context) async {
    List<XFile>? pickedFiles = [];
    try {
      pickedFiles = await ImagePicker().pickMultiImage(
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
    } catch (e) {
      print("Error picking images: $e");
    }

    List<String> imagePaths = [];

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      for (XFile pickedFile in pickedFiles) {
        File imageFile = File(pickedFile.path);
        imagePaths.add(imageFile.path);
      }

      print('Image paths after picking: $imagePaths');
    }

    return imagePaths;
  }

  void scrollToBottom() {
    scrollController!.animateTo(
      scrollController!.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutQuint,
    );
  }
 

}















// class ChatScreenController {
//   final ScrollController? scrollController;

//   ChatScreenController({
//     this.scrollController,
//   });

//   List<String> imagePaths = [];

//   Future<void> pickImages(BuildContext context) async {
//     List<XFile>? pickedFiles = [];
//     try {
//       pickedFiles = await ImagePicker().pickMultiImage(
//         maxWidth: 800,
//         maxHeight: 800,
//         imageQuality: 85,
//       );
//     } catch (e) {
//       print("Error picking images: $e");
//     }

//     if (pickedFiles != null && pickedFiles.isNotEmpty) {
//       for (XFile pickedFile in pickedFiles) {
//         File imageFile = File(pickedFile.path);
//         imagePaths.add(imageFile.path);
//       }

//       print('after this new');
//       print(imagePaths);
//       print('working bro');
//       if (imagePaths.isNotEmpty) {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => ChatScreen(
//               imagePaths: imagePaths,
//             ),
//           ),
//         );
//       }
//     }
//   }

//   // void scrollToBottom() {
//   //   scrollController!.animateTo(
//   //     scrollController!.position.maxScrollExtent,
//   //     duration: const Duration(milliseconds: 500),
//   //     curve: Curves.easeInOutQuint,
//   //   );
//   // }

// }
