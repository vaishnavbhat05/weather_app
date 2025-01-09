import 'package:flutter/material.dart';
import '../models/favourite_city.dart';
import '../services/database_service.dart';

class FavouriteProvider with ChangeNotifier {
  List<FavouriteCity> _favoriteCities = [];

  List<FavouriteCity> get favoriteCities => _favoriteCities;

  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  Future<void> fetchFavorites() async {
    _favoriteCities = await _databaseHelper.getFavorites();
    notifyListeners();
  }

  Future<void> toggleFavorite(FavouriteCity city) async {
    if (isCityFavorite(city.cityName)) {
      await removeFavorite(city.cityName);
    } else {
      await addFavorite(city);
    }
    notifyListeners();
  }

  Future<void> addFavorite(FavouriteCity city) async {
    await _databaseHelper.insertFavorite(city);
    _favoriteCities.add(city);
    notifyListeners();
  }

  Future<void> removeFavorite(String cityName) async {
    await _databaseHelper.deleteFavorite(cityName);
    _favoriteCities.removeWhere((city) => city.cityName == cityName);
    notifyListeners();
  }

  Future<void> removeAllFavorites() async {
    for (var city in _favoriteCities) {
      await _databaseHelper.deleteFavorite(city.cityName);
    }
    _favoriteCities.clear();
    notifyListeners();
  }

  bool isCityFavorite(String cityName) {
    return favoriteCities.any((city) => city.cityName == cityName);
  }

}
