import 'dart:developer';

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:weather_app/env.dart';

import 'dio_connectivity_request_retrier.dart';
import 'retry_interceptor.dart';

const Duration _kTimeout = Duration(seconds: 60);

@lazySingleton
class RestClientFactory {
  PublishSubject<Exception> dioErrorSubject = PublishSubject();

  Stream<Exception> get dioErrorStream => dioErrorSubject.stream;

  late Dio dio;

  String get weatherUrl => Env.weatherUrl;

  RestClientFactory() {
    dio = Dio(
      BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: _kTimeout,
        receiveTimeout: _kTimeout,
        sendTimeout: _kTimeout,
      ),
    );
    if (kDebugMode) {
      dio.interceptors.add(
        AwesomeDioInterceptor(
            // Disabling headers and timeout would minimize the logging output.
            // Optional, defaults to true
            logRequestTimeout: false,
            logRequestHeaders: false,
            logResponseHeaders: false,
            logger: (value) {
              log(value, name: 'Weather App');
            }),
      );
    }
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: dio,
        ),
        dioErrorSubject: (dioError) {
          dioErrorSubject.add(dioError);
        },
      ),
    );
  }
}
