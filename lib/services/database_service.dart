import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/favourite_city.dart';
import '../models/recent_search.dart';

class DatabaseHelper {
  static const _databaseName = "WeatherApp.db";
  static const _databaseVersion = 2;

  static const tableFavorites = 'favorites';
  static const tableRecentSearch = 'recent_search';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, _databaseName);
    return await openDatabase(path, version: _databaseVersion,
        onCreate: (Database db, int version) async {
          await db.execute('''
        CREATE TABLE $tableFavorites (
          id INTEGER PRIMARY KEY,
          cityName TEXT NOT NULL,
          temperatureCelsius REAL,
          description TEXT,
          isFavorite INTEGER,
          weatherIconUrl TEXT NOT NULL
        );
      ''');
          await db.execute('''
        CREATE TABLE $tableRecentSearch (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          cityName TEXT NOT NULL,
          temperatureCelsius REAL,
          description TEXT,
          weatherIconUrl TEXT
        );
      ''');
        }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
          if (oldVersion < 2) {
            await db.execute('''
          ALTER TABLE $tableFavorites ADD COLUMN weatherIconUrl TEXT NOT NULL;
        ''');
          }
        });
  }

  Future<void> insertFavorite(FavouriteCity city) async {
    Database db = await instance.database;
    await db.insert(tableFavorites, city.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteFavorite(String cityName) async {
    Database db = await instance.database;
    await db.delete(
      tableFavorites,
      where: 'cityName = ?',
      whereArgs: [cityName],
    );
  }

  Future<List<FavouriteCity>> getFavorites() async {
    Database db = await instance.database;
    var res = await db.query(tableFavorites);
    return res.isNotEmpty
        ? res.map((c) => FavouriteCity.fromMap(c)).toList()
        : [];
  }

  Future<int> insertRecentSearch(RecentSearch search) async {
    final db = await instance.database;
    return await db.insert(tableRecentSearch, search.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<RecentSearch>> getRecentSearches() async {
    final db = await instance.database;
    final result = await db.query(tableRecentSearch);
    return result.isNotEmpty
        ? result.map((e) => RecentSearch.fromMap(e)).toList()
        : [];
  }

  Future<int> deleteRecentSearch(String cityName) async {
    final db = await instance.database;
    return await db.delete(tableRecentSearch, where: 'cityName = ?', whereArgs: [cityName]);
  }

  Future<void> clearAllRecentSearches() async {
    final db = await database;
    await db.delete('recent_search');
  }
  Future<bool> isFavorite(String cityName) async {
    final db = await instance.database;
    final result = await db.query(
      tableFavorites,
      where: 'cityName = ?',
      whereArgs: [cityName],
    );
    return result.isNotEmpty;
  }

}
