import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/favourite_city.dart';
import '../models/recent_search.dart';
import '../provider/favourite_provider.dart';
import '../services/DatabaseService.dart';
import 'home_screen.dart';

class RecentSearchScreen extends StatefulWidget {
  const RecentSearchScreen({super.key});

  @override
  State<RecentSearchScreen> createState() => _RecentSearchScreenState();
}

class _RecentSearchScreenState extends State<RecentSearchScreen> {
  late Future<List<RecentSearch>> recentSearches;

  @override
  void initState() {
    super.initState();
    recentSearches = DatabaseHelper.instance.getRecentSearches();
  }

  void clearAllSearches() async {
    await DatabaseHelper.instance.clearAllRecentSearches();
    setState(() {
      recentSearches = DatabaseHelper.instance.getRecentSearches();
    });
  }

  void removeSearch(String cityName) async {
    await DatabaseHelper.instance.deleteRecentSearch(cityName);
    setState(() {
      recentSearches = DatabaseHelper.instance.getRecentSearches();
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
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
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
              onPressed: () {},
              icon: const Icon(Icons.search, color: Colors.black),
            ),
          ],
        ),
        body: FutureBuilder<List<RecentSearch>>(
          future: recentSearches,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading recent searches'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3D72E8), Color(0xFF9568D1)],
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
                    ],
                  ),
                ),
              );
            } else {
              final recentSearchesList = snapshot.data!;
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3D72E8), Color(0xFF9568D1)],
                    begin: Alignment.bottomLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "You recently searched for",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: clearAllSearches,
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
                          itemCount: recentSearchesList.length,
                          itemBuilder: (context, index) {
                            final search = recentSearchesList[index];
                            return Dismissible(
                              key: Key(search.cityName),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              onDismissed: (direction) {
                                removeSearch(search.cityName);
                              },
                              child: Consumer<FavouriteProvider>(
                                builder: (context, favoriteProvider, child) {
                                  final isFavorite = favoriteProvider
                                      .isCityFavorite(search.cityName);

                                  return Container(
                                    margin:
                                    const EdgeInsets.symmetric(vertical: 2.0),
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
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              search.cityName,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.yellow,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                search.weatherIconUrl.isNotEmpty
                                                    ? Image.network(
                                                  search.weatherIconUrl,
                                                  width: 32,
                                                  height: 32,
                                                  fit: BoxFit.cover,
                                                )
                                                    : const Icon(
                                                  Icons.wb_sunny_rounded,
                                                  color: Colors.white,
                                                  size: 28,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  '${search.temperatureCelsius.toStringAsFixed(0)}°c',
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  search.description,
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
                                          icon: Icon(
                                            Icons.favorite,
                                            color: isFavorite
                                                ? Colors.yellow
                                                : Colors.white,
                                          ),
                                          onPressed: () {
                                            favoriteProvider.toggleFavorite(
                                              FavouriteCity(
                                                cityName: search.cityName,
                                                weatherIconUrl:
                                                search.weatherIconUrl,
                                                temperatureCelsius:
                                                search.temperatureCelsius,
                                                description: search.description,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
