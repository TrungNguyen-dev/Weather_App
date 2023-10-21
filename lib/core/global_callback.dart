typedef OnNetworkErrorPopup = Future Function(bool pop);

class GlobalCallback {
  static GlobalCallback? _instance;

  OnNetworkErrorPopup? onNetworkErrorPopup;

  GlobalCallback._internal();
  static GlobalCallback get instance {
    _instance ??= GlobalCallback._internal();
    return _instance!;
  }
}
