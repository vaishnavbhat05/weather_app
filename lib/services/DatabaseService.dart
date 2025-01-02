import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/weather_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('weather.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE weather (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cityName TEXT,
        temperatureCelsius REAL,
        temperatureFahrenheit REAL,
        minTemperature REAL,
        maxTemperature REAL,
        precipitation INTEGER,
        humidity INTEGER
      )
    ''');
  }

  Future<WeatherData?> getWeatherData(String cityName) async {
    final db = await instance.database;
    final maps = await db.query(
      'weather',
      columns: [
        'cityName',
        'temperatureCelsius',
        'temperatureFahrenheit',
        'minTemperature',
        'maxTemperature',
        'precipitation',
        'humidity',
      ],
      where: 'cityName = ?',
      whereArgs: [cityName],
    );

    if (maps.isNotEmpty) {
      return WeatherData.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> insertWeatherData(WeatherData weatherData) async {
    final db = await instance.database;
    return await db.insert(
      'weather',
      weatherData.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
