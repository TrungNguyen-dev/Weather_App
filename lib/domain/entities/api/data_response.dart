import 'package:json_annotation/json_annotation.dart';

import 'api_response.dart';

@JsonSerializable(
  genericArgumentFactories: true,
  createFactory: false,
  createToJson: false,
)
class DataResponse<T> extends ApiResponse {
  final T data;
  DataResponse(int? code, String? message, bool? error, this.data)
      : super(code: code, message: message, error: error);

  factory DataResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) mapper) {
    final data = json['data'];
    T toData = mapper(data);
    return DataResponse(json['code'], json['message'], json['error'], toData);
  }
}
