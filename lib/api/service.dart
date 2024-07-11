import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weathermodel.dart';
import 'package:geocoding/geocoding.dart';

class WeatherService {
  //api key
  static const String apiKey = 'd69ee7bb0fc12c6625834fd5097599c0';
  //open weather api
  static const String apiUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  //for Fetching Weather
  Future<WeatherModel> fetchWeather(String cityName) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?q=$cityName&units=metric&appid=$apiKey'));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return WeatherModel.fromJson(json);
      } else {
        throw Exception("Failed to fetch data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching weather data: $e");
      throw Exception("Failed to fetch weather data. Please check your internet connection.");
    }
  }


}
