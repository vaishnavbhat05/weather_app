import 'package:flutter/material.dart';
import 'home_screen.dart';

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
    "Mumbai",
    "Delhi",
    "Kolkata",
    "Chennai",
    "Hyderabad",
    "Pune",
    "Ahmedabad",
    "Jaipur",
    "Lucknow",
    "Indore",
    "Bhopal",
    "Surat"
  ];

  List<String> filteredCities() {
    if (searchQuery.isNotEmpty) {
      return cities
          .where((city) => city.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context).copyWith(
      scaffoldBackgroundColor: Colors.white, // Setting the background to white
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
                          title: Text(filteredCities()[index],style: const TextStyle(color: Colors.black),),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Selected City: ${filteredCities()[index]}",style: TextStyle(color: Colors.black),),
                              ),
                            );
                          },
                        ),
                        const Divider(), // Add divider after each item
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

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../services/DatabaseService.dart';
// import '../models/weather_data.dart';
//
// class CitySearchScreen extends StatefulWidget {
//   @override
//   _CitySearchScreenState createState() => _CitySearchScreenState();
// }
//
// class _CitySearchScreenState extends State<CitySearchScreen> {
//   final TextEditingController _cityController = TextEditingController();
//   final String apiKey = 'cb0eaffde1f1678e6b49dde732cc8dde'; // Replace with your API key
//
//   Future<void> _searchCity() async {
//     String cityName = _cityController.text.trim();
//     if (cityName.isEmpty) return;
//
//     final response = await http.get(Uri.parse(
//         'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric'));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//
//       double temperatureCelsius = data['main']['temp'].toDouble();
//       double temperatureFahrenheit = (temperatureCelsius * 9 / 5) + 32;
//       double minTemperature = data['main']['temp_min'].toDouble();
//       double maxTemperature = data['main']['temp_max'].toDouble();
//       int precipitation = data['weather'].isNotEmpty ? data['weather'][0]['description'] == 'rain' ? 1 : 0 : 0;
//       int humidity = data['main']['humidity'];
//
//       WeatherData weatherData = WeatherData(
//         cityName: cityName,
//         temperatureCelsius: temperatureCelsius,
//         temperatureFahrenheit: temperatureFahrenheit,
//         minTemperature: minTemperature,
//         maxTemperature: maxTemperature,
//         precipitation: precipitation,
//         humidity: humidity,
//       );
//
//       await DatabaseHelper.instance.insertWeatherData(weatherData);
//
//       // Navigate back to the home screen
//       Navigator.pop(context);
//     } else {
//       print('Failed to load weather data');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Search City')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _cityController,
//               decoration: const InputDecoration(
//                 labelText: 'Enter City Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _searchCity,
//               child: const Text('Search'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

