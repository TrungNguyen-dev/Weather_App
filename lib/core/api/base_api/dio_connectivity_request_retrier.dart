import 'dart:async';

import 'package:dio/dio.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:weather_app/utils/extension/connectivity.dart';

class DioConnectivityRequestRetrier {
  final Dio dio;

  DioConnectivityRequestRetrier({
    required this.dio,
  });

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    StreamSubscription? streamSubscription;
    final responseCompleter = Completer<Response>();

    streamSubscription = ConnectivityUtils.onListen(
      (status) async {
        if (status == InternetStatus.connected &&
            requestOptions.method == 'GET') {
          streamSubscription?.cancel();

          // Complete the completer instead of returning
          final options = Options(
            method: requestOptions.method,
            receiveDataWhenStatusError: false,
            headers: <String, dynamic>{
              ...requestOptions.headers,
            },
            extra: <String, dynamic>{
              'secure': <Map<String, String>>[
                {
                  'type': 'http',
                  'name': 'Authorization',
                },
              ],
              ...requestOptions.extra,
            },
            contentType: [
              'application/json',
            ].first,
            validateStatus: requestOptions.validateStatus,
          );
          responseCompleter.complete(
            dio.request(
              '${requestOptions.baseUrl}${requestOptions.path}',
              cancelToken: requestOptions.cancelToken,
              data: requestOptions.data,
              onReceiveProgress: requestOptions.onReceiveProgress,
              onSendProgress: requestOptions.onSendProgress,
              queryParameters: requestOptions.queryParameters,
              options: options,
            ),
          );
        }
      },
    );

    return responseCompleter.future;
  }
}
