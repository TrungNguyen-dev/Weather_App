import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/assets/icons.dart';
import 'package:weather_app/assets/image_assets.dart';
import 'package:weather_app/utils/extension/string.dart';

bool isShow = false;

class BottomSheetApp extends StatefulWidget {
  final String? iconBottomSheet;
  final Widget child;
  final Function()? onClose;

  const BottomSheetApp({
    Key? key,
    this.iconBottomSheet,
    required this.child,
    this.onClose,
  }) : super(key: key);

  static Future show(
    BuildContext context, {
    required String iconBottomSheet,
    required Widget child,
    Function()? onClose,
    bool isDismissible = true,
  }) async {
    if (isShow) null;
    isShow = true;
    final response = await showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      elevation: 0,
      barrierColor: const Color(0x338c8c8c),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BottomSheetApp(
          iconBottomSheet: iconBottomSheet,
          onClose: onClose,
          child: child,
        );
      },
    );
    isShow = false;
    return response;
  }

  @override
  State<BottomSheetApp> createState() => _BottomSheetAppState();
}

class _BottomSheetAppState extends State<BottomSheetApp> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.w).copyWith(top: 55.h),
          margin: EdgeInsets.only(
            top: 40.sp,
          ),
          child: widget.child,
        ),
        if (widget.iconBottomSheet.isNotNullOrEmpty)
          ImageAssets.svgAssets(
            widget.iconBottomSheet ?? '',
            width: 80.sp,
            height: 80.sp,
            fit: BoxFit.contain,
          ),
        if (widget.onClose != null)
          Positioned(
            right: 0,
            child: Container(
              padding: EdgeInsets.only(top: 55.h, right: 20.w),
              child: InkWell(
                onTap: widget.onClose,
                child: ImageAssets.svgAssets(
                  SVGIcons.icClose,
                  width: 24.sp,
                  height: 24.sp,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
