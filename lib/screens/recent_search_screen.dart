import 'package:flutter/material.dart';
import 'home_screen.dart';

class RecentSearchScreen extends StatefulWidget {
  const RecentSearchScreen({super.key});

  @override
  State<RecentSearchScreen> createState() => _RecentSearchScreenState();
}

class _RecentSearchScreenState extends State<RecentSearchScreen> {
  List<Map<String, dynamic>> recentSearches = [
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
        return Icons.water_drop_rounded;
      default:
        return Icons.wb_sunny_rounded;
    }
  }

  void clearAllSearches() {
    setState(() {
      recentSearches.clear();
    });
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
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            const SizedBox(width: 20),
            const Text(
              'Recent Search',
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
        body: recentSearches.isEmpty
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
                    'assets/images/no_recent.jpeg',
                    fit: BoxFit.cover,
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
          ),
        )
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
                    const Text(
                      "You recently searched for",
                      style: TextStyle(
                          fontSize: 18, color: Colors.white),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        clearAllSearches();
                      },
                      child: const Text(
                        "Clear All",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: recentSearches.length,
                    itemBuilder: (context, index) {
                      final search = recentSearches[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 2.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.2),
                              offset: const Offset(0, 2),
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
                                  search['name'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      getWeatherIcon(
                                          search['description']),
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${search['temp']}c',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      search['description'],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
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
