class FavouriteCity {
  final int? id;
  final String cityName;
  final double temperatureCelsius;
  final String description;
  final String weatherIconUrl;
  late final bool isFavorite;

  FavouriteCity({
    this.id,
    required this.cityName,
    required this.temperatureCelsius,
    required this.description,
    required this.weatherIconUrl,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'cityName': cityName,
      'temperatureCelsius': temperatureCelsius,
      'description': description,
      'isFavorite': isFavorite ? 1 : 0,
      'weatherIconUrl': weatherIconUrl,
    };
  }

  static FavouriteCity fromMap(Map<String, dynamic> map) {
    return FavouriteCity(
      id: map['id'],
      cityName: map['cityName'],
      temperatureCelsius: map['temperatureCelsius'],
      description: map['description'],
      weatherIconUrl: map['weatherIconUrl'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}
