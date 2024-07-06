import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class WeatherInitialEvent extends WeatherEvent {}

class FetchWeather extends WeatherEvent {
  final String cityName;

  const FetchWeather(this.cityName);

  @override
  List<Object> get props => [cityName];
}

class RefreshWeather extends WeatherEvent {
  final String cityName;

  const RefreshWeather(this.cityName);

  @override
  List<Object> get props => [cityName];
}
