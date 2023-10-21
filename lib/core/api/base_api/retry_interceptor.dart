import 'dart:io';

import 'package:dio/dio.dart';
import 'package:weather_app/core/global_callback.dart';
import 'package:weather_app/domain/entities/api/api_error.dart';

import 'dio_connectivity_request_retrier.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final DioConnectivityRequestRetrier requestRetrier;
  final Function dioErrorSubject;
  final Map _lastRetry = {"ts": 0};

  RetryOnConnectionChangeInterceptor({
    required this.requestRetrier,
    required this.dioErrorSubject,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers["Connection"] = "Keep-Alive";
    options.receiveDataWhenStatusError = true;
    super.onRequest(options, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    final apiError = ApiError.fromDio(err);
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_shouldRetry(err) && now > _lastRetry["ts"] + 500) {
      _lastRetry["ts"] = now;
      try {
        GlobalCallback.instance.onNetworkErrorPopup?.call(true);

        final response =
            await requestRetrier.scheduleRequestRetry(err.requestOptions);
        handler.resolve(response);
      } on ApiError catch (e) {
        handler.reject(e);
        dioErrorSubject.call(e);
      }
    } else if (apiError.code == AppErrorCode.unauthorized) {
      dioErrorSubject.call(apiError);
      super.onError(apiError, handler);
    } else {
      if (err.error is SocketException) {
        GlobalCallback.instance.onNetworkErrorPopup?.call(false);
      }
      dioErrorSubject.call(apiError);
      super.onError(apiError, handler);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.error is SocketException && err.requestOptions.method == 'GET';
  }
}
