import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/restaurant.dart';

class DatabaseHelper {
  static const _dbName = 'restory.db';
  static const _dbVersion = 1;
  static const _table = 'favorites';

  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _openDb();
    return _db!;
  }

  static Future<Database> _openDb() async {
    final path = join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) => db.execute(
        'CREATE TABLE $_table('
        'id TEXT PRIMARY KEY,'
        'name TEXT NOT NULL,'
        'description TEXT NOT NULL,'
        'pictureId TEXT NOT NULL,'
        'city TEXT NOT NULL,'
        'rating REAL NOT NULL'
        ')',
      ),
    );
  }

  static Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    final maps = await db.query(_table);
    return maps.map(Restaurant.fromMap).toList();
  }

  static Future<void> addFavorite(Restaurant restaurant) async {
    final db = await database;
    await db.insert(
      _table,
      restaurant.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(_table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<bool> isFavorite(String id) async {
    final db = await database;
    final result = await db.query(_table, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }
}
