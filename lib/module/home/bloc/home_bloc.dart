import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/app_dependencies.dart';
import 'package:weather_app/domain/entities/api/api_error.dart';
import 'package:weather_app/domain/entities/weather_model.dart';
import 'package:weather_app/domain/repository/weather_repository.dart';
import 'package:weather_app/utils/extension/string.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<GetWeatherInfo>(_getWeatherInfo);
    on<GetCoordinatesByLocationName>(_getCoordinatesByLocationName);
  }

  final _weatherRepos = getIt.get<WeatherRepository>();
  bool didGoToSettings = false;

  Future<void> _getWeatherInfo(
    GetWeatherInfo event,
    Emitter<HomeState> emit,
  ) async {
    try {
      double? latitude = event.lat;
      double? longitude = event.lon;

      if (latitude == null && longitude == null) {
        final location = await _determinePosition(emit);
        latitude = location?.latitude;
        longitude = location?.longitude;
      }
      if (latitude == null && longitude == null) return;
      emit(state.copyWith(status: HomeStatus.loading));

      final response = await _weatherRepos.getWeather(
        latitude: latitude!,
        longitude: longitude!,
      );
      if (response.cod == 200) {
        emit(
          state.copyWith(
            status: HomeStatus.success,
            data: response,
            lat: latitude,
            lon: longitude,
          ),
        );
      } else {
        emit(state.copyWith(status: HomeStatus.failure));
      }
    } catch (e) {
      final error = AppError.wrap(e);
      log('load-exception-getWeatherInfo', error: error);
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  Future<Position?> _determinePosition(Emitter<HomeState> emit) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (didGoToSettings) {
        didGoToSettings = false;
        return null;
      }

      ///Location service is disabled
      emit(state.copyWith(status: HomeStatus.locationServiceDisabled));
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (didGoToSettings) {
          didGoToSettings = false;
          return null;
        }

        ///Denied second time
        emit(state.copyWith(status: HomeStatus.locationPermissionDenied));
        return null;
      }
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return await Geolocator.getCurrentPosition();
    }
    didGoToSettings = false;
    return null;
  }

  Future<void> _getCoordinatesByLocationName(
    GetCoordinatesByLocationName event,
    Emitter<HomeState> emit,
  ) async {
    try {
      if (!event.locationName.isNotNullOrEmpty) {
        add(GetWeatherInfo());
        return;
      }
      final response = await _weatherRepos.getCoordinatesByLocationName(
        locationName: event.locationName ?? '',
      );
      if (response.isNotEmpty && response.firstOrNull != null) {
        final locationFirst = response.firstOrNull;
        if (locationFirst?.lon != null || locationFirst?.lat != null) {
          add(GetWeatherInfo(lat: locationFirst?.lat, lon: locationFirst?.lon));
        } else {
          emit(state.copyWith(status: HomeStatus.failure));
          add(GetWeatherInfo());
        }
      } else {
        emit(state.copyWith(status: HomeStatus.failure));
        add(GetWeatherInfo());
      }
    } catch (e) {
      final error = AppError.wrap(e);
      log('load-exception-getCoordinatesByLocationName', error: error);
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}
