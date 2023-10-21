import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/assets/style.dart';
import 'package:weather_app/utils/extension/string.dart';
import 'package:weather_app/utils/utils.dart';

import 'dialog_enum.dart';

bool isShowSuccess = false;
bool isShowFailure = false;
const Duration _dialogDisplayDuration = Duration(seconds: 3);

class DialogApp extends StatefulWidget {
  final DialogStyle style;
  final String? content;
  final Widget? contentWidget;
  final Duration? duration;
  final bool largePadding;
  final VoidCallback? onClose;
  final bool autoClose;
  final String? challengeName;
  final int? challengePoint;
  final bool isFullWidth;
  const DialogApp({
    Key? key,
    required this.style,
    this.content,
    this.contentWidget,
    this.duration,
    this.onClose,
    this.largePadding = false,
    this.autoClose = true,
    this.challengeName,
    this.challengePoint,
    this.isFullWidth = false,
  }) : super(key: key);

  @override
  State<DialogApp> createState() => _DialogAppState();

  static void close(BuildContext context) {
    if (isShowSuccess) {
      isShowSuccess = false;
      Navigator.of(context).maybePop();
      return;
    }

    if (isShowFailure) {
      isShowFailure = false;
      Navigator.of(context).maybePop();
      return;
    }
  }

  static Future showSuccess(
    BuildContext context, {
    required String content,
    Widget? contentWidget,
    VoidCallback? onClose,
    bool barrierDismissible = true,
    Duration duration = _dialogDisplayDuration,
    bool largePadding = true,
    bool isFullWidth = false,
  }) async {
    if (isShowSuccess) return;

    isShowSuccess = true;
    final response = await showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        barrierColor: const Color(0x338c8c8c),
        builder: (context) {
          return DialogApp(
            style: DialogStyle.success,
            content: content,
            contentWidget: contentWidget,
            onClose: onClose,
            duration: duration,
            largePadding: largePadding,
            isFullWidth: isFullWidth,
          );
        });
    isShowSuccess = false;
    return response;
  }

  static Future showFailure(
    BuildContext context, {
    required String? content,
    Widget? contentWidget,
    VoidCallback? onClose,
    bool barrierDismissible = true,
    bool largePadding = true,
    Duration duration = _dialogDisplayDuration,
    bool isFullWidth = false,
  }) async {
    if (isShowFailure) return;
    isShowFailure = true;
    final response = await showDialog(
        context: context,
        barrierColor: const Color(0x338c8c8c),
        barrierDismissible: barrierDismissible,
        builder: (context) {
          return DialogApp(
            style: DialogStyle.failure,
            content: content ?? "",
            contentWidget: contentWidget,
            onClose: onClose,
            duration: duration,
            largePadding: largePadding,
            isFullWidth: isFullWidth,
          );
        });
    isShowFailure = false;
    return response;
  }
}

class _DialogAppState extends State<DialogApp> {
  EdgeInsetsGeometry dialogPadding =
      const EdgeInsets.all(20.0).copyWith(top: 16);

  @override
  void initState() {
    super.initState();
    dialogPadding = widget.largePadding
        ? EdgeInsets.symmetric(horizontal: 24.r, vertical: 24.r)
        : EdgeInsets.all(12.r);
    if (widget.autoClose && widget.duration != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          Future.delayed(widget.duration!).then(
            (value) {
              if (mounted) Navigator.of(context).maybePop();
            },
          );
        },
      );
    }
  }

  @override
  void deactivate() {
    widget.onClose?.call();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: MediaQuery.of(context).viewInsets,
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.sWidth * 0.8),
          child: Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
              type: MaterialType.card,
              child: Container(
                width: widget.isFullWidth ? double.infinity : null,
                padding: dialogPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.style.dialogIcon,
                    if (widget.contentWidget != null) ...[
                      SizedBox(height: 8.h),
                      widget.contentWidget!,
                    ],
                    if (widget.content.isNotNullOrEmpty) ...[
                      SizedBox(height: 8.h),
                      Text(
                        widget.content!,
                        textAlign: TextAlign.center,
                        style: text16.blackColor.copyWith(height: 1.6),
                      )
                    ],
                  ],
                ),
              )),
        ));
  }
}
