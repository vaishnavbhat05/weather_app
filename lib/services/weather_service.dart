// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import '../models/city.dart';
// import 'DatabaseService.dart';
//
// Future<City?> fetchCityFromApi(String cityName) async {
//   final url = 'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=YOUR_API_KEY';
//   final response = await http.get(Uri.parse(url));
//
//   if (response.statusCode == 200) {
//     final data = json.decode(response.body);
//     return City.fromJson(data);
//   }
//   return null;
// }
//
// Future<City?> getCityData(String cityName) async {
//   final dbHelper = DatabaseHelper.instance;
//
//   // Check if city exists in the database
//   final dbResult = await dbHelper.fetchCity(cityName);
//   if (dbResult.isNotEmpty) {
//     return City(
//       name: dbResult[0]['name'],
//       lon: dbResult[0]['lon'],
//       lat: dbResult[0]['lat'],
//       temp: dbResult[0]['temp'],
//       description: dbResult[0]['description'],
//       icon: dbResult[0]['icon'],
//     );
//   }
//
//   // If not, fetch from API and save to the database
//   final city = await fetchCityFromApi(cityName);
//   if (city != null) {
//     await dbHelper.insertCity(city.toMap());
//   }
//   return city;
// }
