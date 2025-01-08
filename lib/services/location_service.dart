import 'package:geolocator/geolocator.dart';

class LocationService {
  // Get current location
  Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      throw Exception('Location permission denied');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // Get city name from coordinates (latitude, longitude)
  Future<String> getCityName(Position position) async {
    // Use reverse geocoding API to get city name from coordinates (you can use a service like Google Maps API)
    // For simplicity, here we are assuming the city name is retrieved as a placeholder.
    return 'udupi';  // Replace with actual city name logic
  }
}
