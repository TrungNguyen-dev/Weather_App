import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/assets/icons.dart';
import 'package:weather_app/assets/image_assets.dart';

enum DialogStyle {
  success,
  failure,
}

extension DialogStyleEtx on DialogStyle {
  Widget get dialogIcon {
    switch (this) {
      case DialogStyle.success:
        return ImageAssets.svgAssets(
          SVGIcons.icSuccess,
          height: 34.sp,
          width: 34.sp,
          fit: BoxFit.contain,
        );
      default:
        return ImageAssets.svgAssets(
          SVGIcons.icFailure,
          height: 34.sp,
          width: 34.sp,
          fit: BoxFit.contain,
        );
    }
  }
}
