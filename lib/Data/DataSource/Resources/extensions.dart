import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension CustomSizedBox on num {
  SizedBox get x => SizedBox(width: w);
  SizedBox get y => SizedBox(height: h);
 
 
 }
