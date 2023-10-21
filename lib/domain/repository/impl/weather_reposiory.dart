import 'package:injectable/injectable.dart';
import 'package:weather_app/core/api/base_api/rest_client_factory.dart';
import 'package:weather_app/core/api/weather/weather_api.dart';
import 'package:weather_app/domain/entities/weather_direct.dart';
import 'package:weather_app/domain/entities/weather_model.dart';
import 'package:weather_app/domain/repository/weather_repository.dart';
import 'package:weather_app/env.dart';

const _countryCode = 'VN';

@LazySingleton(as: WeatherRepository)
class WeatherRepositoryImpl extends WeatherRepository {
  WeatherRepositoryImpl(RestClientFactory apiServiceFactory)
      : _weatherApi = WeatherApi(
          apiServiceFactory.dio,
          baseUrl: apiServiceFactory.weatherUrl,
        );

  final WeatherApi _weatherApi;

  @override
  Future<WeatherModel> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final response = await _weatherApi.getWeatherData(
      lat: latitude,
      lon: longitude,
      lang: 'vi',
      units: 'metric',
      appId: Env.weatherApiKey,
      exclude: 'current',
    );
    return response;
  }

  @override
  Future<List<WeatherDirect>> getCoordinatesByLocationName(
      {required String locationName}) async {
    final response = await _weatherApi.getCoordinatesByLocationName(
      locationName: '$locationName,$_countryCode',
      limit: 1,
      appId: Env.weatherApiKey,
    );
    return response;
  }

  @override
  Future getCoordinatesByZipCode({required int zipCode}) async {
    final response = await _weatherApi.getCoordinatesByZipCode(
      zipCode: '$zipCode,$_countryCode',
      appId: Env.weatherApiKey,
    );
    return response;
  }
}
