import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/screens/city_search_screen.dart';
import '../screens/recent_search_screen.dart';
import '../services/DatabaseService.dart';
import 'favourite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _navigateToScreen(String screenName) {
    setState(() {
      _currentScreen = screenName; // Update the active screen name
    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) {
        if (screenName == 'Favourites') {
          return const FavouriteScreen();
        } else if (screenName == 'Recent Search') {
          return const RecentSearchScreen();
        }
        return const HomeScreen(); // Default is HomeScreen
      },
    ));
  }

  String _currentScreen = 'Home';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Mock data for the current city and temperature (this could come from an API)
  String cityName = 'Bangalore';
  double temperatureCelsius = 28.0;
  bool isCelsius = true;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('EEE, dd MMM yyyy').format(DateTime.now());
    String currentTime = DateFormat('hh:mm a').format(DateTime.now());

    // Convert temperature to Fahrenheit
    double temperatureFahrenheit = (temperatureCelsius * 9 / 5) + 32;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF9568D1), // Second gradient color
                    Color(0xFF9568D1), // Third gradient color
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  _scaffoldKey.currentState
                      ?.openDrawer(); // Open the drawer without using a key
                },
                icon: const Icon(Icons.menu, color: Colors.white,size: 30,),
              ),
              const SizedBox(width: 30),
              Image.asset(
                'assets/images/weather.png', // Replace with your image path
                width: 180, // Adjust the width of the image
                height: 180, // Adjust the height of the image
                fit: BoxFit.contain, // Ensures the image is scaled appropriately
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
                  icon: const Icon(Icons.search, color: Colors.white,size: 30,)),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
            children: [
              ListTile(
                title: Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: _currentScreen == 'Home'
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                onTap: () {
                  _navigateToScreen('Home');
                },
              ),
              ListTile(
                title: const Text(
                  'Favourites',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  _navigateToScreen('Favourites');
                },
              ),
              ListTile(
                title: const Text(
                  'Recent Search',
                  style: TextStyle(fontSize: 18),
                ),
                onTap: () {
                  _navigateToScreen('Recent Search');
                },
              ),
            ],
          ),
        ),
        body: Container(
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
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
                  '$cityName, Karnataka',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite; // Toggle favorite status
                        });
                      },
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border_sharp, // Change icon based on favorite state
                        size: 30,
                        color: isFavorite ? Colors.yellow : Colors.white, // Toggle color
                      ),
                    ),
                    const Text("Add to favourite",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 70),
                const Icon(
                  Icons.wb_sunny_rounded,
                  size: 100,
                  color: Colors.white,
                ),
                // Sun Icon and temperature
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Temperature Display with fixed font size
                    Column(
                      children: [
                        Text(
                          isCelsius
                              ? temperatureCelsius.toStringAsFixed(0)
                              : temperatureFahrenheit.toStringAsFixed(0),
                          style: const TextStyle(
                            fontSize:
                                90, // Increased font size for the temperature
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                        width: 10), // Space between the temperature and buttons
                    // Celsius Button (Square Box)
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isCelsius ? Colors.white : Colors.transparent,
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isCelsius = true;
                          });
                        },
                        child: Text(
                          '°C',
                          style: TextStyle(
                            fontSize: 22,
                            color: isCelsius
                                ? Colors.red
                                : Colors.white, // Set red color when selected
                          ),
                        ),
                      ),
                    ),
                    // Fahrenheit Button (Square Box)
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: !isCelsius ? Colors.white : Colors.transparent,
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isCelsius = false;
                          });
                        },
                        child: Text(
                          '°F',
                          style: TextStyle(
                            fontSize: 22,
                            color: !isCelsius
                                ? Colors.red
                                : Colors.white, // Set red color when selected
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Mostly Sunny',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                const Divider(
                  thickness: 2.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 30),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Min and Max temperature
                      Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.thermostat_rounded,
                                size: 40,
                                color: Colors.white,
                              ),
                              SizedBox(
                                  width: 10), // Space between icon and text
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Min- Max',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '20°- 30°',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      // Precipitation
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.cloudy_snowing,
                                size: 40,
                                color: Colors.white,
                              ),
                              SizedBox(
                                  width: 10), // Space between icon and text
                              Text(
                                'Precipitation',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '10%',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      // Humidity
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.water_drop_outlined,
                                size: 40,
                                color: Colors.white,
                              ), // Space between icon and text
                              Text(
                                'Humid',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '     70%',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
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

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../services/DatabaseService.dart';
// import '../models/weather_data.dart';
// import 'city_search_screen.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   String _currentScreen = 'Home';
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   // Add state variables for weather data
//   String cityName = 'Mysore';
//   double temperatureCelsius = 0.0;
//   double temperatureFahrenheit = 0.0;
//   double minTemperature = 0.0;
//   double maxTemperature = 0.0;
//   int precipitation = 0;
//   int humidity = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchWeatherData();
//   }
//
//   Future<void> _fetchWeatherData() async {
//     final weatherData = await DatabaseHelper.instance.getWeatherData(cityName);
//
//     if (weatherData != null) {
//       setState(() {
//         cityName = weatherData.cityName;
//         temperatureCelsius = weatherData.temperatureCelsius;
//         temperatureFahrenheit = weatherData.temperatureFahrenheit;
//         minTemperature = weatherData.minTemperature;
//         maxTemperature = weatherData.maxTemperature;
//         precipitation = weatherData.precipitation;
//         humidity = weatherData.humidity;
//       });
//     } else {
//       print('Weather data not found for $cityName');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String currentDate = DateFormat('EEE, dd MMM yyyy').format(DateTime.now());
//     String currentTime = DateFormat('hh:mm a').format(DateTime.now());
//
//     return SafeArea(
//       child: Scaffold(
//         key: _scaffoldKey,
//         appBar: AppBar(
//           title: const Text('Weather App'),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CitySearchScreen()),
//                 );
//               },
//               icon: const Icon(Icons.search),
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             children: [
//               Text('$currentDate, $currentTime'),
//               const SizedBox(height: 20),
//               Text(
//                 '$cityName, Karnataka',
//                 style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               Text('Temperature: ${temperatureCelsius.toStringAsFixed(1)} °C'),
//               Text('Min: ${minTemperature.toStringAsFixed(1)} °C'),
//               Text('Max: ${maxTemperature.toStringAsFixed(1)} °C'),
//               Text('Precipitation: $precipitation'),
//               Text('Humidity: $humidity%'),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
