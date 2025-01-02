import 'package:flutter/material.dart';
import 'home_screen.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<Map<String, dynamic>> favoriteCities = [
    {'name': 'Udupi', 'temp': '25 °', 'description': 'Mostly Sunny'},
    {'name': 'Mysore', 'temp': '18 °', 'description': 'Cloudy'},
    {'name': 'Bangalore', 'temp': '30 °', 'description': 'Sunny'},
    {'name': 'Mangalore', 'temp': '22 °', 'description': 'Clear Sky'},
    {'name': 'Hassan', 'temp': '28 °', 'description': 'Rainy'},
    {'name': 'Hubli', 'temp': '33 °', 'description': 'Humid'},
  ];

  IconData getWeatherIcon(String description) {
    switch (description.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny_rounded;
      case 'cloudy':
        return Icons.cloud_rounded;
      case 'clear sky':
        return Icons.wb_cloudy_rounded;
      case 'rainy':
        return Icons.cloudy_snowing;
      case 'humid':
        return Icons
            .water_drop_rounded;
      default:
        return Icons.wb_sunny_rounded;
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
          borderRadius: BorderRadius.zero,
        ),
        content: const Text(
          "Are you sure you want to remove all the favorites?",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              removeAllFavorites();
              Navigator.pop(context);
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
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>HomeScreen()),
                );
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
          ],
        ),
        body: favoriteCities.isEmpty
            ? Center(
                child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF3D72E8),
                      Color(0xFF9568D1),
                    ],
                    begin: Alignment.bottomLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/no_fav.png',
                        fit: BoxFit
                            .cover,
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
                      Color(0xFF3D72E8),
                      Color(0xFF9568D1),
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
                                        .withOpacity(0.2),
                                    offset:
                                        const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        city['name'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .yellow,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
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
                                                  .white,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            city['description'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors
                                                  .white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.favorite),
                                    color: Colors.yellow.shade700,
                                    onPressed: () {
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
