import 'dart:io';

import 'package:dio/dio.dart';

import 'api_response.dart';

class AppErrorCode {
  AppErrorCode._();

  static const unknown = -1;
  static const noConnection = -1000;
  static const success = 200;
  static const badRequest = 400;
  static const unauthorized = 401;
  static const notFound = 404;
  static const unProcessAbleContent = 422;
  static const serverError = 500;
}

class ApiError extends AppError implements DioException {
  final dynamic data;
  ApiError({int code = AppErrorCode.unknown, String message = '', this.data})
      : super(code: code, message: message);

  ApiError.noConnection([String? message])
      : this(
          code: AppErrorCode.noConnection,
          message: message ?? 'Mất kết nối mạng,\nbạn vui lòng kiểm tra lại!',
        );

  ApiError.unknown(message, this.data)
      : super(code: AppErrorCode.unknown, message: message);

  static ApiError fromDio(DioException error) {
    if (_isConnectionError(error)) {
      return ApiError.noConnection(error.message);
    } else if (error.response != null) {
      return _parseExceptionFromResponse(error, error.response!);
    } else {
      return ApiError.unknown((error.error as HttpException).message, null);
    }
  }

  static ApiError _parseExceptionFromResponse(
    DioException error,
    Response resp,
  ) {
    try {
      final response = ApiResponse.fromJson(resp.data);
      final data = resp.data["data"];
      int? code = response.code;
      if (code == null) {
        if (_isAccessDenied(response)) {
          code = AppErrorCode.unauthorized;
        } else if (_isServerError(error)) {
          final reason = response.message;
          code = _kErrorCodeMap[reason] ?? resp.statusCode;
        } else {
          code = AppErrorCode.unknown;
        }
      }

      return ApiError(
        code: code!,
        message: _kMappingError[code] ?? response.message!,
        data: data,
      );
    } catch (_) {
      try {
        int? code = resp.statusCode ?? AppErrorCode.unknown;

        return ApiError(
          code: code,
          message: _kMappingError[code] ?? 'unknown',
          data: null,
        );
      } catch (e) {
        return ApiError.unknown(error.message ?? '', null);
      }
    }
  }

  @override
  DioException copyWith(
      {RequestOptions? requestOptions,
      Response? response,
      DioExceptionType? type,
      Object? error,
      StackTrace? stackTrace,
      String? message}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  dynamic error;

  @override
  Response? response;

  @override
  late DioExceptionType type;

  @override
  late RequestOptions requestOptions;

  @override
  StackTrace get stackTrace => StackTrace.current;
}

class AppError implements Exception {
  static const kUnknownError = "Unknown error";
  final int code;
  final String message;

  AppError({this.code = AppErrorCode.unknown, this.message = kUnknownError});

  AppError.code(int code, [String? message])
      : this(
          code: code,
          message: message ?? kUnknownError,
        );

  AppError.unknown([String? message])
      : this(
          code: AppErrorCode.unknown,
          message: message ?? kUnknownError,
        );

  factory AppError.wrap(dynamic error) {
    if (error is AppError) {
      return error;
    }

    return AppError.unknown(error.toString());
  }

  @override
  String toString() {
    return "[$code][$message]";
  }
}

bool _isConnectionError(DioException error) =>
    error.type == DioExceptionType.receiveTimeout ||
    error.type == DioExceptionType.connectionTimeout ||
    error.type == DioExceptionType.connectionError ||
    error.error is SocketException;

bool _isServerError(DioException error) =>
    (error.response?.statusCode ?? 0) > 300;

bool _isAccessDenied(ApiResponse response) =>
    response.message == "access_denied" ||
    response.code == AppErrorCode.unauthorized;

final Map<int, String> _kMappingError = {
  AppErrorCode.notFound: 'Không tìm thấy dữ liệu.',
  AppErrorCode.noConnection:
      'Không thể kết nối đến máy chủ, xin vui lòng kiểm tra kết nối internet và thử lại.',
  AppErrorCode.unauthorized: 'Vui lòng đăng nhập để tiếp tục',
  AppErrorCode.unknown: 'Có lỗi xảy ra, xin vui lòng thử lại.',
  AppErrorCode.serverError: 'Lỗi máy chủ\nVui lòng thử lại sau',
};

const Map<String, int> _kErrorCodeMap = {
  "not_found": AppErrorCode.notFound,
  "invalid_param": AppErrorCode.badRequest,
};
