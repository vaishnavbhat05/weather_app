class RecentSearch {
  final int? id;
  final String cityName;
  final double temperatureCelsius;
  final String description;
  final String weatherIconUrl;

  RecentSearch({
    this.id,
    required this.cityName,
    required this.temperatureCelsius,
    required this.description,
    required this.weatherIconUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'cityName': cityName,
      'temperatureCelsius': temperatureCelsius,
      'description': description,
      'weatherIconUrl': weatherIconUrl,
    };
  }

  static RecentSearch fromMap(Map<String, dynamic> map) {
    return RecentSearch(
      id: map['id'],
      cityName: map['cityName'],
      temperatureCelsius: map['temperatureCelsius'],
      description: map['description'],
      weatherIconUrl: map['weatherIconUrl'],
    );
  }
}
