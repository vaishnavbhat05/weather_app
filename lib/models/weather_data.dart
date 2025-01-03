class WeatherData {
  final int? id;
  final String cityName;
  final double temperatureCelsius;
  final double temperatureFahrenheit;
  final double minTemperature;
  final double maxTemperature;
  final int precipitation;
  final int humidity;
  final String description;
  final String iconCode;

  WeatherData({
    this.id,
    required this.cityName,
    required this.temperatureCelsius,
    required this.temperatureFahrenheit,
    required this.minTemperature,
    required this.maxTemperature,
    required this.precipitation,
    required this.humidity,
    required this.description,
    required this.iconCode,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];
    final clouds = json['clouds'];

    final double temperatureCelsius = main['temp'].toDouble();
    final double temperatureFahrenheit = (temperatureCelsius * 9 / 5) + 32;
    final double minTemperature = main['temp_min'].toDouble();
    final double maxTemperature = main['temp_max'].toDouble();
    final int precipitation = clouds['all'];
    final int humidity = main['humidity'];
    final String description = weather['main'];
    final String iconCode = weather['icon'];

    return WeatherData(
      cityName: json['name'],
      temperatureCelsius: temperatureCelsius,
      temperatureFahrenheit: temperatureFahrenheit,
      minTemperature: minTemperature,
      maxTemperature: maxTemperature,
      precipitation: precipitation,
      humidity: humidity,
      description: description,
      iconCode: iconCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'temperatureCelsius': temperatureCelsius,
      'temperatureFahrenheit': temperatureFahrenheit,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
      'precipitation': precipitation,
      'humidity': humidity,
      'description': description,
      'iconCode': iconCode,
    };
  }
}
