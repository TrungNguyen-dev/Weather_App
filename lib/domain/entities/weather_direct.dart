import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_direct.freezed.dart';
part 'weather_direct.g.dart';

@freezed
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createFactory: false,
)
class WeatherDirect with _$WeatherDirect {
  const factory WeatherDirect({
    String? name,
    double? lat,
    double? lon,
    String? country,
    String? state,
  }) = _WeatherDirect;

  factory WeatherDirect.fromJson(Map<String, dynamic> json) =>
      _$WeatherDirectFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WeatherDirectToJson(this);
}
