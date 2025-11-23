import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/film.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'films.db');

    // Debug
    print('DBHelper: database path = $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print('DBHelper: creating table films');
        await db.execute('''
          CREATE TABLE films (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT NOT NULL,
            gambar TEXT NOT NULL,
            deskripsi TEXT
          )
        ''');
      },
    );
  }

  // INSERT
  Future<int> insertFilm(Film film) async {
    try {
      final dbClient = await database;
      final id = await dbClient.insert('films', film.toMap());
      print('DBHelper: insertFilm succeeded id=$id');
      return id;
    } catch (e, st) {
      print('DBHelper: insertFilm ERROR -> $e\n$st');
      rethrow;
    }
  }

  // SELECT ALL
  Future<List<Film>> getFilms() async {
    try {
      final dbClient = await database;
      final data = await dbClient.query('films', orderBy: 'id DESC');
      print('DBHelper: getFilms count=${data.length}');
      return data.map((e) => Film.fromMap(e)).toList();
    } catch (e, st) {
      print('DBHelper: getFilms ERROR -> $e\n$st');
      rethrow;
    }
  }

  // UPDATE
  Future<int> updateFilm(Film film) async {
    try {
      final dbClient = await database;
      final res = await dbClient.update(
        'films',
        film.toMap(),
        where: 'id = ?',
        whereArgs: [film.id],
      );
      print('DBHelper: updateFilm res=$res');
      return res;
    } catch (e, st) {
      print('DBHelper: updateFilm ERROR -> $e\n$st');
      rethrow;
    }
  }

  // DELETE
  Future<int> deleteFilm(int id) async {
    try {
      final dbClient = await database;
      final res = await dbClient.delete(
        'films',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('DBHelper: deleteFilm res=$res');
      return res;
    } catch (e, st) {
      print('DBHelper: deleteFilm ERROR -> $e\n$st');
      rethrow;
    }
  }
}
