import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather_app/assets/icons.dart';
import 'package:weather_app/env.dart';
import 'package:weather_app/utils/extension/string.dart';

part 'weather_model.freezed.dart';
part 'weather_model.g.dart';

@freezed
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createFactory: false,
)
class WeatherModel with _$WeatherModel {
  const factory WeatherModel({
    Coord? coord,
    List<Weather>? weather,
    String? base,
    Main? main,
    int? visibility,
    Wind? wind,
    Clouds? clouds,
    int? dt,
    Sys? sys,
    int? timezone,
    int? id,
    String? name,
    int? cod,
    String? message,
  }) = _WeatherModel;

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);
}

@freezed
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createFactory: false,
)
class Coord with _$Coord {
  const factory Coord({
    double? lon,
    double? lat,
  }) = _Coord;

  factory Coord.fromJson(Map<String, dynamic> json) => _$CoordFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CoordToJson(this);
}

@freezed
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createFactory: false,
)
class Weather with _$Weather {
  const factory Weather({
    int? id,
    String? main,
    String? description,
    @JsonKey(unknownEnumValue: IconWeather.unknown) IconWeather? icon,
  }) = _Weather;

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}

@freezed
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createFactory: false,
)
class Main with _$Main {
  const factory Main({
    double? temp,
    double? feelsLike,
    double? tempMin,
    double? tempMax,
    int? pressure,
    int? humidity,
  }) = _Main;
  factory Main.fromJson(Map<String, dynamic> json) => _$MainFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MainToJson(this);
}

@freezed
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createFactory: false,
)
class Wind with _$Wind {
  const factory Wind({
    double? speed,
    int? deg,
  }) = _Wind;
  factory Wind.fromJson(Map<String, dynamic> json) => _$WindFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$WindToJson(this);
}

@freezed
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createFactory: false,
)
class Clouds with _$Clouds {
  const factory Clouds({
    int? all,
  }) = _Clouds;
  factory Clouds.fromJson(Map<String, dynamic> json) => _$CloudsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CloudsToJson(this);
}

@freezed
@JsonSerializable(
  fieldRename: FieldRename.snake,
  createFactory: false,
)
class Sys with _$Sys {
  const factory Sys({
    int? type,
    int? id,
    String? country,
    int? sunrise,
    int? sunset,
  }) = _Sys;
  factory Sys.fromJson(Map<String, dynamic> json) => _$SysFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$SysToJson(this);
}

enum IconWeather {
  @JsonValue('01d')
  d01,
  @JsonValue('01n')
  n01,
  @JsonValue('02d')
  d02,
  @JsonValue('02n')
  n02,
  @JsonValue('03d')
  d03,
  @JsonValue('03n')
  n03,
  @JsonValue('04d')
  d04,
  @JsonValue('04n')
  n04,
  @JsonValue('09d')
  d09,
  @JsonValue('09n')
  n09,
  @JsonValue('10d')
  d10,
  @JsonValue('10n')
  n10,
  @JsonValue('11d')
  d11,
  @JsonValue('11n')
  n11,
  @JsonValue('13d')
  d13,
  @JsonValue('13n')
  n13,
  @JsonValue('50d')
  d50,
  @JsonValue('50n')
  n50,
  unknown,
}

extension WeatherX on Weather {
  String get descriptionIcon => switch (icon) {
        IconWeather.d01 || IconWeather.n01 => 'Mặc đơn giản nhé, trời đẹp lắm!',
        IconWeather.d02 ||
        IconWeather.n02 =>
          'Chọn trang phục tối giản, trời không nhiều mây đâu.',
        IconWeather.d03 ||
        IconWeather.n03 =>
          'Cẩn thận mưa bất chợt, mây rải rác đấy.',
        IconWeather.d04 ||
        IconWeather.n04 =>
          'Nhớ mang ô khi trời nhiều mây để không bị ướt nhé!',
        IconWeather.d09 ||
        IconWeather.n09 =>
          'Mưa nhỏ, tránh bị ướt đi bạn ơi!',
        IconWeather.d10 ||
        IconWeather.n10 =>
          'Đừng quên mặc áo mưa khi trời mưa nhé!',
        IconWeather.d11 ||
        IconWeather.n11 =>
          'Sấm chớp thì tốt nhất hạn chế ra ngoài.',
        IconWeather.d13 ||
        IconWeather.n13 =>
          'Đang lạnh, mặc ấm khi trời tuyết nhé!',
        IconWeather.d50 || IconWeather.n50 => 'Giữ ấm trong sương mù nhé bạn!',
        _ => '',
      };

  String get iconCover => switch (icon) {
        IconWeather.d01 => PNGImage.imgCleanSky,
        IconWeather.n01 => PNGImage.imgMoon,
        IconWeather.d02 => PNGImage.imgDayFewClouds,
        IconWeather.n02 => PNGImage.imgNightFewClouds,
        IconWeather.d03 || IconWeather.n03 => PNGImage.imgScatteredClouds,
        IconWeather.d04 || IconWeather.n04 => PNGImage.imgBrokenClouds,
        IconWeather.d09 || IconWeather.n09 => PNGImage.imgShowerRain,
        IconWeather.d10 => PNGImage.imgDayRain,
        IconWeather.n10 => PNGImage.imgNightRain,
        IconWeather.d11 || IconWeather.n11 => PNGImage.imgThunderstorm,
        IconWeather.d13 || IconWeather.n13 => PNGImage.imgSnow,
        IconWeather.d50 || IconWeather.n50 => PNGImage.imgMist,
        _ => '',
      };

  String get _valueEnum => switch (icon) {
        IconWeather.d01 => '01d',
        IconWeather.n01 => '01n',
        IconWeather.d02 => '02d',
        IconWeather.n02 => '02n',
        IconWeather.d03 => '03d',
        IconWeather.n03 => '03n',
        IconWeather.d04 => '04d',
        IconWeather.n04 => '04n',
        IconWeather.d09 => '09d',
        IconWeather.n09 => '09n',
        IconWeather.d10 => '10d',
        IconWeather.n10 => '10n',
        IconWeather.d11 => '11d',
        IconWeather.n11 => '11n',
        IconWeather.d13 => '13d',
        IconWeather.n13 => '13n',
        IconWeather.d50 => '50d',
        IconWeather.n50 => '50n',
        _ => 'unknown',
      };
  String get iconUrl => _valueEnum.isNotNullOrEmpty == true
      ? Env.weatherIconUrl.replaceAll('{name}', _valueEnum)
      : '';
}

extension WeatherModelEx on WeatherModel {
  double? get getMainTemp => main?.temp;
  Weather? get getFirstWeather => weather.getFirstOrNull;
}
