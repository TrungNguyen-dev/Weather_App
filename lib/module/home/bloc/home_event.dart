// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {}

class GetWeatherInfo extends HomeEvent {
  final double? lat;
  final double? lon;
  GetWeatherInfo({
    this.lat,
    this.lon,
  });
  @override
  List<Object?> get props => [lat, lon];
}

class GetCoordinatesByZipCode extends HomeEvent {
  @override
  List<Object?> get props => [];
}

class GetCoordinatesByLocationName extends HomeEvent {
  final String? locationName;
  GetCoordinatesByLocationName({
    this.locationName,
  });
  @override
  List<Object?> get props => [locationName];
}
