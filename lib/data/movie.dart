import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:movie_search_app/models/movie.dart';

class MovieDatabase {
  static final MovieDatabase _instance = MovieDatabase._internal();
  static Database _db;

  factory MovieDatabase() => _instance;

  Future<Database> get db async {
    _db = _db ?? await initDB();
    return _db;
  }

  MovieDatabase._internal();

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Movies (id STRING PRIMARY KEY, title TEXT, poster_path TEXT, overview TEXT, favored BIT)');
    print("db created");
  }

  Future<List<Movie>> getMovies() async {
    var dbClient = await db;
    List<Map> res = await dbClient.query("Movies");
    return res.map((m) => Movie.fromJson(m)).toList();
  }

  Future<Movie> getMovie(String id) async {
    var dbClient = await db;
    var res = await dbClient.query("Movies", where: "id = ?", whereArgs: [id]);
    if (res.length == 0) return null;
    return Movie.fromJson(res[0]);
  }

  Future<int> addMovie(Movie movie) async {
    var dbClient = await db;
    try {
      int res = await dbClient.insert("Movies", movie.toMap());
      print("Movie added $res");
      return res;
    } catch (e) {
      int res = await updateMovie(movie);
      return res;
    }
  }

  Future<int> updateMovie(Movie movie) async {
    var dbClient = await db;
    int res = await dbClient.update("Movies", movie.toMap(),
        where: "id = ?", whereArgs: [movie.id]);
    print("Movie updated $res");
    return res;
  }

  Future<int> deleteMovie(String id) async {
    var dbClient = await db;
    var res = await dbClient.delete("Movies", where: "id = ?", whereArgs: [id]);
    print("Movie deleted $res");
    return res;
  }

  Future closeDb() async {
    var dbClient = await db;
    dbClient.close();
  }
}
