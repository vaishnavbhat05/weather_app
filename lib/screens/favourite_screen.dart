import 'package:flutter/material.dart';
import 'city_search_screen.dart';
import 'home_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  // Example data for favorite cities
  List<Map<String, dynamic>> favoriteCities = [
    {'name': 'New York', 'temp': '25 °', 'description': 'Mostly Sunny'},
    {'name': 'London', 'temp': '18 °', 'description': 'Cloudy'},
    {'name': 'Tokyo', 'temp': '30 °', 'description': 'Sunny'},
    {'name': 'Paris', 'temp': '22 °', 'description': 'Clear Sky'},
    {'name': 'Sydney', 'temp': '28 °', 'description': 'Rainy'},
    {'name': 'Mumbai', 'temp': '33 °', 'description': 'Humid'},
  ];

  // Function to return different icons based on weather description
  IconData getWeatherIcon(String description) {
    switch (description.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny_rounded;
      case 'cloudy':
        return Icons.cloud_rounded;
      case 'clear sky':
        return Icons.wb_cloudy_rounded;
      case 'rainy':
        return Icons.cloudy_snowing; // Use a different icon for rainy weather
      case 'humid':
        return Icons
            .water_drop_rounded; // Use a water drop icon for humid weather
      default:
        return Icons.wb_sunny_rounded; // Default icon for undefined weather
    }
  }

  void removeAllFavorites() {
    setState(() {
      favoriteCities.clear();
    });
  }

  void showRemoveAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Make the dialog rectangular
        ),
        content: const Text(
          "Are you sure you want to remove all the favorites?",
          style: TextStyle(fontSize: 16), // Optional: Adjust font size
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              removeAllFavorites(); // Remove all favorites
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back), // Back button icon
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>HomeScreen()),
                ); // Navigate back to the HomeScreen
              },
            ),
            const SizedBox(
              width: 20,
            ),
            const Text(
              'Favourite',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
              onPressed: () { },
              icon: const Icon(Icons.search, color: Colors.black),
            ),
          ], // Add a title for clarity
        ),
        body: favoriteCities.isEmpty
            ? Center(
                child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3D72E8), // Second gradient color
                      Color(0xFF9568D1), // Third gradient color
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/no_fav.png', // Replace with your image path
                        fit: BoxFit
                            .cover, // Ensures the image covers the entire container
                      ),
                    ),
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [],
                      ),
                    ),
                  ],
                ),
              ))
            : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3D72E8), // Second gradient color
                      Color(0xFF9568D1), // Third gradient color
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        children: [
                          Text(
                            "${favoriteCities.length} city added to favourite",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              showRemoveAllDialog(context);
                            },
                            child: const Text(
                              "Remove All",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      // List of favorite cities
                      Expanded(
                        child: ListView.builder(
                          itemCount: favoriteCities.length,
                          itemBuilder: (context, index) {
                            final city = favoriteCities[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 2.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white
                                        .withOpacity(0.2), // Light shadow color
                                    offset:
                                        const Offset(0, 2), // Shadow position
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left Column for City Name and Icon+Temp+Description
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // City Name with Yellow color
                                      Text(
                                        city['name'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .yellow, // Yellow color for city name
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Second Line: Weather Icon, Temp, Description
                                      Row(
                                        children: [
                                          // Weather Icon based on description
                                          Icon(
                                            getWeatherIcon(city['description']),
                                            color: Colors.white,
                                            size: 28,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${city['temp']}c',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors
                                                  .white, // White color for temperature
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            city['description'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors
                                                  .white, // White color for description
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  // Favorite Button - Positioned on the right, centered vertically
                                  IconButton(
                                    icon: const Icon(Icons.favorite),
                                    color: Colors.yellow.shade700,
                                    onPressed: () {
                                      // Logic to remove the city from favorites
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
