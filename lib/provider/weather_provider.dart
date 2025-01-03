import 'package:flutter/material.dart';
class WeatherProvider with ChangeNotifier {
  String cityName = 'kumta';
  double temperatureCelsius = 25.0;
  double minTemperature = 18.0;
  double maxTemperature = 29.0;
  int humidity = 77;
  int precipitation = 70;
  String description = 'Rainy';
  String weatherIconUrl = '';
  bool isFavorite = false;
  bool isCelsius = true;

  void updateWeatherData({
    required String city,
    required double tempCelsius,
    required double tempFahrenheit,
    required double minTemp,
    required double maxTemp,
    required int humidity,
    required int precipitation,
    required String description,
    required String iconCode,
  }) {
    cityName = city;
    temperatureCelsius = tempCelsius;
    minTemperature = minTemp;
    maxTemperature = maxTemp;
    this.humidity = humidity;
    this.precipitation = precipitation;
    this.description = description;
    weatherIconUrl = 'https://openweathermap.org/img/wn/$iconCode@2x.png';
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
