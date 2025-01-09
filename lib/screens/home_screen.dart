import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/screens/recent_search_screen.dart';
import '../models/favourite_city.dart';
import '../provider/favourite_provider.dart';
import '../provider/weather_provider.dart';
import '../services/location_service.dart';
import '../services/weather_service.dart';
import 'city_search_screen.dart';
import 'favourite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLocationFetched = false;

  @override
  void initState() {
    super.initState();
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    if (!weatherProvider.isCitySearched) {
      _getCurrentLocationWeather();
    }
  }

  Future<void> _getCurrentLocationWeather() async {
    try {
      Position position = await LocationService().getCurrentLocation();
      String city = await LocationService().getCityName(position);
      await _fetchWeatherData(city);
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching location: $error');
      }
    }
  }

  Future<void> _fetchWeatherData(String cityName) async {
    await WeatherService().fetchWeatherData(cityName, context);
    setState(() {
      isLocationFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        return SafeArea(
          child: Scaffold(
            key: _scaffoldKey,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF9568D1),
                        Color(0xFF9568D1),
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 30),
                  Image.asset(
                    'assets/images/weather.png',
                    width: 180,
                    height: 180,
                    fit: BoxFit.contain,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CitySearchScreen(),
                        ),
                      );
                    },
                    icon:
                        const Icon(Icons.search, color: Colors.white, size: 30),
                  ),
                ],
              ),
            ),
            drawer: Drawer(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
                children: [
                  ListTile(
                    title: const Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Favourites',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FavouriteScreen()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'Recent Search',
                      style: TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecentSearchScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            body: OrientationBuilder(
              builder: (context, orientation) {
                return Container(
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
                    padding: const EdgeInsets.all(20.0),
                    child: orientation == Orientation.portrait
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: _buildWeatherContent(weatherProvider),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: _buildWeatherContent(weatherProvider),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildWeatherContent(WeatherProvider weatherProvider) {
    String currentDate = DateFormat('EEE, dd MMM yyyy').format(DateTime.now());
    String currentTime = DateFormat('hh:mm a').format(DateTime.now());
    double temperatureFahrenheit =
        (weatherProvider.temperatureCelsius * 9 / 5) + 32;

    return [
      const SizedBox(height: 20),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$currentDate    ',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            TextSpan(
              text: currentTime,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 30),
      Text(
        '${weatherProvider.cityName}, India',
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer<FavouriteProvider>(
            builder: (context, favouriteProvider, _) {
              final isFavorite =
                  favouriteProvider.isCityFavorite(weatherProvider.cityName);
              return IconButton(
                onPressed: () {
                  favouriteProvider.toggleFavorite(FavouriteCity(
                    cityName: weatherProvider.cityName,
                    temperatureCelsius: weatherProvider.temperatureCelsius,
                    description: weatherProvider.description,
                    weatherIconUrl: weatherProvider.weatherIconUrl,
                  ));
                },
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 30,
                  color: isFavorite ? Colors.yellow : Colors.white,
                ),
              );
            },
          ),
          const Text(
            "Add to favourite",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
      const SizedBox(height: 70),
      weatherProvider.weatherIconUrl.isNotEmpty
          ? Image.network(
              weatherProvider.weatherIconUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            )
          : const Icon(
              Icons.wb_sunny_rounded,
              size: 100,
              color: Colors.white,
            ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                weatherProvider.isCelsius
                    ? weatherProvider.temperatureCelsius.toStringAsFixed(0)
                    : temperatureFahrenheit.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 90,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color:
                  weatherProvider.isCelsius ? Colors.white : Colors.transparent,
              border: Border.all(color: Colors.white),
            ),
            child: TextButton(
              onPressed: () {
                weatherProvider.switchToCelsius();
              },
              child: Text(
                '°C',
                style: TextStyle(
                  fontSize: 22,
                  color: weatherProvider.isCelsius ? Colors.red : Colors.white,
                ),
              ),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: !weatherProvider.isCelsius
                  ? Colors.white
                  : Colors.transparent,
              border: Border.all(color: Colors.white),
            ),
            child: TextButton(
              onPressed: () {
                weatherProvider.switchToFahrenheit();
              },
              child: Text(
                '°F',
                style: TextStyle(
                  fontSize: 22,
                  color: !weatherProvider.isCelsius ? Colors.red : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Text(
        weatherProvider.description,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 80),
      const Divider(),
      const SizedBox(height: 30),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.thermostat_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Min - Max',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    '${weatherProvider.minTemperature.toStringAsFixed(0)}°',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const TextSpan(
                                text: ' - ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '${weatherProvider.maxTemperature.toStringAsFixed(0)}°',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.cloudy_snowing,
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Precipitation',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${weatherProvider.precipitation}%',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.water_drop_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Humidity',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:
                                    weatherProvider.humidity.toStringAsFixed(0),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const TextSpan(
                                text: '%',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }
}
