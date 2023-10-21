import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ApiResponse {
  final int? code;
  final String? message;
  final bool? error;

  ApiResponse({this.code, this.message, this.error});

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}
