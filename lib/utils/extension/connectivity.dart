import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityUtils {
  static Future<bool> get isConnected async =>
      await InternetConnection().hasInternetAccess;

  static StreamSubscription<InternetStatus> onListen(onTap) {
    return InternetConnection().onStatusChange.listen((status) {
      if (onTap != null) onTap(status);
    });
  }

  static Future showErrorDialog(BuildContext context,
      [Function? onThen]) async {
    // await Dialog.showFailure(
    //   context,
    //   content: 'Mất kết nối mạng,\nbạn vui lòng kiểm tra lại!',
    //   largePadding: false,
    // ).then((_) {
    //   onThen?.call();
    // });
  }
}
