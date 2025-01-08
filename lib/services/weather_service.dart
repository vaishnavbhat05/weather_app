import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../provider/weather_provider.dart';
import '../models/weather_data.dart';

class WeatherService {
  final String apiKey = 'cb0eaffde1f1678e6b49dde732cc8dde';

  Future<void> fetchWeatherData(String cityName, BuildContext context) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      WeatherData weatherData = WeatherData.fromJson(data);

      // Update WeatherProvider with the fetched data
      Provider.of<WeatherProvider>(context, listen: false)
          .updateWeatherData(weatherData);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
