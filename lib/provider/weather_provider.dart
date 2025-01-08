import 'package:flutter/material.dart';
import '../models/weather_data.dart';

class WeatherProvider with ChangeNotifier {
  String cityName = 'Udupi';
  double temperatureCelsius = 25.0;
  double minTemperature = 18.0;
  double maxTemperature = 29.0;
  int humidity = 77;
  int precipitation = 70;
  String description = 'Sunny';
  String weatherIconUrl = '';
  bool isCelsius = true;

  void updateWeatherData(WeatherData weatherData) {
    cityName = weatherData.cityName;
    temperatureCelsius = weatherData.temperatureCelsius;
    minTemperature = weatherData.minTemperature;
    maxTemperature = weatherData.maxTemperature;
    humidity = weatherData.humidity;
    precipitation = weatherData.precipitation;
    description = weatherData.description;
    weatherIconUrl =
    'https://openweathermap.org/img/wn/${weatherData.iconCode}@2x.png';
    notifyListeners();
  }

  void switchToCelsius() {
    isCelsius = true;
    notifyListeners();
  }

  void switchToFahrenheit() {
    isCelsius = false;
    notifyListeners();
  }
  bool isCitySearched = false;

  void setCitySearched(bool value) {
    isCitySearched = value;
    notifyListeners();
  }
}

