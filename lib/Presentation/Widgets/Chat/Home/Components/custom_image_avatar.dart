import 'package:chat_app/Application/Services/ConnectivityServices/connectivity_service.dart';
import 'package:flutter/material.dart';

class CustomImageAvatar extends StatefulWidget {
  String? imagePath;
  bool? isAssetImage;
  bool? isForSearch;

  CustomImageAvatar({
    Key? key,
    this.imagePath,
    this.isForSearch,
    this.isAssetImage,
  }) : super(key: key);

  @override
  State<CustomImageAvatar> createState() => _CustomImageAvatarState();
}

class _CustomImageAvatarState extends State<CustomImageAvatar> {
  late ValueNotifier<bool> isConnected;

  @override
  void initState() {
    super.initState();
    isConnected = ValueNotifier(false);
    checkConnectivity();
  }

  @override
  void dispose() {
    isConnected.dispose();
    super.dispose();
  }

  void checkConnectivity() {
    AppConnectivity().connectionChanged().then((value) {
      setState(() {
        isConnected.value = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(90),
      child: isConnected.value == false
          ? Container(
              child: Icon(
                Icons.person,
                size: widget.isForSearch! ? 35 : 50,
                semanticLabel: 'No net available',
                shadows: [
                  Shadow(
                      offset: Offset.zero, blurRadius: 2, color: Colors.green)
                ],
              ),
            )
          : Container(
              height: widget.isForSearch! ? 35 : 50,
              width: widget.isForSearch! ? 35 : 50,
              child: widget.isAssetImage!
                  ? Image.asset(widget.imagePath!)
                  : widget.imagePath == null ||
                          widget.imagePath!.isEmpty ||
                          widget.imagePath == ''
                      ? Icon(Icons.person)
                      : Image.network(widget.imagePath!),
            ),
    );
  }
}
