import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:weather_app/domain/entities/weather_direct.dart';
import 'package:weather_app/domain/entities/weather_model.dart';

part 'weather_api.g.dart';

@RestApi()
abstract class WeatherApi {
  factory WeatherApi(Dio dio, {String baseUrl}) = _WeatherApi;

  @GET('/data/2.5/weather')
  Future<WeatherModel> getWeatherData({
    @Query("lat") required double lat,
    @Query('lon') required double lon,
    @Query("lang") required String lang,
    @Query('units') required String? units,
    @Query("appid") required String appId,
    @Query("exclude") required String? exclude,
  });

  @GET('/geo/1.0/zip')
  Future<WeatherModel> getCoordinatesByZipCode({
    @Query("zip") required String zipCode,
    @Query("appid") required String appId,
  });

  @GET('/geo/1.0/direct')
  Future<List<WeatherDirect>> getCoordinatesByLocationName({
    @Query("q") required String locationName,
    @Query("appid") required String appId,
    @Query("limit") required int limit,
  });
}
