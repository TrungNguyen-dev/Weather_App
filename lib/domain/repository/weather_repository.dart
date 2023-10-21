import 'package:weather_app/domain/entities/weather_direct.dart';
import 'package:weather_app/domain/entities/weather_model.dart';

abstract class WeatherRepository {
  Future<WeatherModel> getWeather({
    required double latitude,
    required double longitude,
  });

  Future<dynamic> getCoordinatesByZipCode({
    required int zipCode,
  });

  Future<List<WeatherDirect>> getCoordinatesByLocationName({
    required String locationName,
  });
}
