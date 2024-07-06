import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/bloc/weather_event.dart';
import 'package:weather_app/bloc/weather_state.dart';
import 'package:weather_app/api/service.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherService weatherService;

  WeatherBloc({required this.weatherService}) : super(WeatherInitial()) {
    // on<WeatherInitialEvent>(_weatherInitialEvent);
    on<FetchWeather>(_onFetchWeather);
    on<RefreshWeather>(_onRefreshWeather);
    _loadLastCity();
  }

  void _onFetchWeather(FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final weather = await weatherService.fetchWeather(event.cityName);
      _saveLastCity(event.cityName);
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }

  void _onRefreshWeather(
      RefreshWeather event, Emitter<WeatherState> emit) async {
    final currentState = state;
    if (currentState is WeatherLoaded) {
      try {
        final weather =
            await weatherService.fetchWeather(currentState.weather.cityName);
        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    }
  }

  Future<void> _saveLastCity(String cityName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastCity', cityName);
  }

  Future<void> _loadLastCity() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cityName = prefs.getString('lastCity');
    if (cityName != null) {
      add(FetchWeather(cityName));
    }
  }
}
