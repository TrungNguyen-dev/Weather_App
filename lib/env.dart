import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'WEATHER_URL')
  static String weatherUrl = _Env.weatherUrl;
  @EnviedField(varName: 'WEATHER_ICON_URL')
  static String weatherIconUrl = _Env.weatherIconUrl;
  @EnviedField(varName: 'WEATHER_API_KEY')
  static String weatherApiKey = _Env.weatherApiKey;
}
