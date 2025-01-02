import 'package:flutter/material.dart';
import 'package:weather_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 3),
          () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        maintainBottomViewPadding: true,
        child: Scaffold(
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
            child: Center(
              child: Image.asset(
                'assets/images/weather.png', // Replace with your image path
                width: 200, // Adjust the width of the image
                height: 200, // Adjust the height of the image
                fit: BoxFit.contain, // Ensures the image is scaled appropriately
              ),
            ),
          ),
        ),
      ),
    );
  }
}

