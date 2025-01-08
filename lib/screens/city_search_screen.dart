import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recent_search.dart';
import '../models/weather_data.dart';
import '../provider/weather_provider.dart';
import '../services/database_service.dart';
import 'home_screen.dart';
import 'package:http/http.dart' as http;

class CitySearchScreen extends StatefulWidget {
  const CitySearchScreen({super.key});

  @override
  State<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  List<String> cities = [
    "Bangalore",
    "Mysuru",
    "Mangalore",
    "Hubli",
    "Dharwad",
    "Belagavi",
    "Shimoga",
    "Tumkur",
    "Udupi",
    "Chitradurga",
    "Bijapur",
    "Bagalkot",
    "Raichur",
    "Hassan",
    "Davangere",
    "malpe",
  ];

  List<String> filteredCities() {
    if (searchQuery.isNotEmpty) {
      return cities
          .where(
              (city) => city.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    return [];
  }

  Future<void> _fetchWeatherData(String cityName) async {
    const apiKey = 'cb0eaffde1f1678e6b49dde732cc8dde';
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      WeatherData weatherData = WeatherData.fromJson(data);

      final recentSearch = RecentSearch(
        cityName: cityName,
        temperatureCelsius: weatherData.temperatureCelsius,
        description: weatherData.description,
        weatherIconUrl:
        'https://openweathermap.org/img/wn/${weatherData.iconCode}@2x.png',
      );
      await DatabaseHelper.instance.insertRecentSearch(recentSearch);

      if (mounted) {
        final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);

        // Update weather data and set isCitySearched to true
        weatherProvider.updateWeatherData(weatherData);
        weatherProvider.setCitySearched(true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } else {
      throw Exception('Failed to load weather data');
    }
  }


  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context).copyWith(
      scaffoldBackgroundColor: Colors.white,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: searchController,
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: "Search for City",
            prefixIcon: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            suffixIcon: searchQuery.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: () {
                      setState(() {
                        searchQuery = "";
                        searchController.clear();
                      });
                    },
                  ),
          ),
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Visibility(
                visible: searchQuery.isNotEmpty,
                child: filteredCities().isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredCities().length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  filteredCities()[index],
                                  style: const TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  _fetchWeatherData(filteredCities()[index]);
                                },
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          "No cities found matching your query.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
