import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/provider/favourite_provider.dart';
import 'package:weather_app/provider/weather_provider.dart';
import 'package:weather_app/screens/home_screen.dart';
import 'package:weather_app/services/database_service.dart';
import 'package:weather_app/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => WeatherProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FavouriteProvider()..fetchFavorites(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      // home: const HomeScreen(),
    );
  }
}
