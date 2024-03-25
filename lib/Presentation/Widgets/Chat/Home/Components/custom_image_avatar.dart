import 'package:chat_app/Application/Services/ConnectivityServices/connectivity_service.dart';
import 'package:chat_app/Data/DataSource/Resources/assets.dart';
import 'package:chat_app/Domain/Models/users_model.dart';
import 'package:chat_app/Presentation/Common/custom_image.dart';
import 'package:chat_app/Presentation/Common/custom_text.dart';
import 'package:flutter/material.dart';
 

 

class CustomImageAvatar extends StatefulWidget {
  final bool? isForSearch;
  final UserModel user;

  CustomImageAvatar({
    Key? key,
    required this.user,
    this.isForSearch,
  }) : super(key: key);

  @override
  State<CustomImageAvatar> createState() => _CustomImageAvatarState();
}

class _CustomImageAvatarState extends State<CustomImageAvatar> {
  ValueNotifier<bool> isConnected = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    checkConnectivity();
  }

  checkConnectivity() {
    print('>>>>');
    print('first here ');
    print(isConnected.value);

    AppConnectivity().connectionChanged().then(
      (value) => setState(() {
        isConnected.value = value;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget.user.imageUrl!.isEmpty || !isConnected.value
            ? Container(
                width: widget.isForSearch == true ? 30 : 50,
                height: widget.isForSearch == true ? 30 : 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: CustomText(
                    customText: widget.user.displayName != null &&
                            widget.user.displayName!.isNotEmpty
                        ? widget.user.displayName![0].toUpperCase()
                        : "",
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: widget.isForSearch == true ? 10 : 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: ValueListenableBuilder<bool>(
                valueListenable: isConnected,
                builder: (context, connected, child) {
                  return connected 
                      ? CustomImage(
                          isAssetImage: false,
                          imageUrl: widget.user.imageUrl,
                          width: widget.isForSearch! ? 30 : 53,
                          height: widget.isForSearch == true ? 30 : 53,
                        )
                      : CustomImage(
                          isAssetImage: true,
                          imageUrl: Assets.googlelogo,
                          width: widget.isForSearch! ? 30 : 53,
                          height: widget.isForSearch == true ? 30 : 53,
                        );
                },
              ),
            ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                customText: widget.user.displayName ?? "",
                textStyle: TextStyle(
                  fontSize: widget.isForSearch == true ? 13 : 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.isForSearch == false)
                const CustomText(
                  customText: '',
                  textStyle: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                )
              else
                Container(),
            ],
          ),
        ),
      ],
    );
  }
}
