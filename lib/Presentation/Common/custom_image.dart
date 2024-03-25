import 'package:chat_app/Data/DataSource/Resources/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomImage extends StatelessWidget {
  final String? imageUrl;
  final String? imageType;
  final bool isAssetImage;
  final double? height;
  final double? width;
  final BoxFit? fit;
  
  const CustomImage({

    required this.isAssetImage,
    this.fit,
    this.width,
    this.imageType,
    this.imageUrl,
    this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    
    return isAssetImage
        ? Image.asset(
            imageUrl ?? Assets.background!,
            height: height ?? 800.h,
            fit: fit ?? BoxFit.fill,
            width: width,
          )
        :
         Image.network(
            imageUrl ?? '',
            height: height ?? 800.h,
            fit: fit ?? BoxFit.fill,
            width: width,
          );
  }
}
