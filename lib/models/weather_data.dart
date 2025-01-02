class WeatherData {
  final int? id;
  final String cityName;
  final double temperatureCelsius;
  final double temperatureFahrenheit;
  final double minTemperature;
  final double maxTemperature;
  final int precipitation;
  final int humidity;

  WeatherData({
    this.id,
    required this.cityName,
    required this.temperatureCelsius,
    required this.temperatureFahrenheit,
    required this.minTemperature,
    required this.maxTemperature,
    required this.precipitation,
    required this.humidity,
  });

  Map<String, dynamic> toMap() {
    return {
      'cityName': cityName,
      'temperatureCelsius': temperatureCelsius,
      'temperatureFahrenheit': temperatureFahrenheit,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
      'precipitation': precipitation,
      'humidity': humidity,
    };
  }

  static WeatherData fromMap(Map<String, dynamic> map) {
    return WeatherData(
      id: map['id'],
      cityName: map['cityName'],
      temperatureCelsius: map['temperatureCelsius'],
      temperatureFahrenheit: map['temperatureFahrenheit'],
      minTemperature: map['minTemperature'],
      maxTemperature: map['maxTemperature'],
      precipitation: map['precipitation'],
      humidity: map['humidity'],
    );
  }
}
