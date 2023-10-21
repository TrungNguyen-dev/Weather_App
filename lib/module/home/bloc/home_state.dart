part of 'home_bloc.dart';

enum HomeStatus {
  unknown,
  loading,
  success,
  failure,
  refresh,
  locationPermissionDenied,
  locationServiceDisabled,
}

const _defaultLatitude = 10.75;
const _defaultLongitude = 106.6667;

class HomeState extends Equatable {
  final HomeStatus status;
  final WeatherModel? data;
  final double? lat;
  final double? lon;
  const HomeState({
    this.status = HomeStatus.unknown,
    this.data,
    this.lat,
    this.lon,
  });

  String? get temp => data?.getMainTemp?.ceilToDouble().format();
  String? get description => data?.getFirstWeather?.descriptionIcon;
  String? get icon => data?.getFirstWeather?.iconCover;
  String? get iconUrl => data?.getFirstWeather?.iconUrl;
  int get humidity => data?.main?.humidity ?? 0;
  double get feelsLike => data?.main?.feelsLike?.roundToDouble().abs() ?? 0;
  double get _wind => data?.wind?.speed ?? 0;
  double get windSped => _wind * 3.6;

  bool get locationDenied =>
      status == HomeStatus.locationPermissionDenied ||
      status == HomeStatus.locationServiceDisabled;

  HomeState copyWith({
    HomeStatus? status,
    WeatherModel? data,
    double? lat,
    double? lon,
  }) {
    return HomeState(
      status: status ?? this.status,
      data: data ?? this.data,
      lat: lat ?? this.lat,
      lon: lon ?? this.lon,
    );
  }

  @override
  List<Object?> get props => [status, data, lat, lon];
}
