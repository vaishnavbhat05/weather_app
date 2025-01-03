import 'package:flutter/material.dart';
import '../models/favourite_city.dart';
import '../models/weather_data.dart';
import '../services/DatabaseService.dart';class WeatherProvider with ChangeNotifier {
  String cityName = 'Udupi';
  double temperatureCelsius = 25.0;
  double minTemperature = 18.0;
  double maxTemperature = 29.0;
  int humidity = 77;
  int precipitation = 70;
  String description = 'Rainy';
  String weatherIconUrl = '';
  bool isFavorite = false;
  bool isCelsius = true;

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  void updateWeatherData(WeatherData weatherData) {
    cityName = weatherData.cityName;
    temperatureCelsius = weatherData.temperatureCelsius;
    minTemperature = weatherData.minTemperature;
    maxTemperature = weatherData.maxTemperature;
    humidity = weatherData.humidity;
    precipitation = weatherData.precipitation;
    description = weatherData.description;
    weatherIconUrl = 'https://openweathermap.org/img/wn/${weatherData.iconCode}@2x.png';

    _checkIfFavorite(cityName).then((_) {
      notifyListeners();
    });
  }

  void switchToCelsius() {
    isCelsius = true;
    notifyListeners();
  }
  void switchToFahrenheit() {
    isCelsius = false;
    notifyListeners();
  }
  void toggleFavorite() async {
    isFavorite = !isFavorite;
    if (isFavorite) {
      await _databaseHelper.insertFavorite(FavouriteCity(
        cityName: cityName,
        temperatureCelsius: temperatureCelsius,
        description: description,
        isFavorite: isFavorite,
        weatherIconUrl: weatherIconUrl,
      ));
    } else {
      await _databaseHelper.deleteFavorite(cityName);
    }
    notifyListeners();
  }
  Future<void> _checkIfFavorite(String cityName) async {
    List<FavouriteCity> favorites = await _databaseHelper.getFavorites();
    isFavorite = favorites.any((city) => city.cityName == cityName);
  }
}
