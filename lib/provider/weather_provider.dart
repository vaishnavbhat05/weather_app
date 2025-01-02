import 'package:flutter/material.dart';class WeatherProvider with ChangeNotifier {
  String cityName = '';
  double temperatureCelsius = 0.0;
  double minTemperature = 0.0;
  double maxTemperature = 0.0;
  int humidity = 0;
  int pressure = 0;
  String description = '';
  bool isFavorite = false;
  bool isCelsius = true;

  void updateWeatherData({
    required String city,
    required double tempCelsius,
    required double tempFahrenheit,
    required double minTemp,
    required double maxTemp,
    required int humidity,
    required int pressure,
    required String description,
  }) {
    cityName = city;
    temperatureCelsius = tempCelsius;
    minTemperature = minTemp;
    maxTemperature = maxTemp;
    this.humidity = humidity;
    this.pressure = pressure;
    this.description = description;
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

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
