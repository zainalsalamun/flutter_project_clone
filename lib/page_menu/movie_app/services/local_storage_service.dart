import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/movie_model.dart';

class LocalStorageService {
  static const String _watchlistBox = 'watchlistBox';

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_watchlistBox);
  }

  Future<void> saveWatchlist(Movie movie) async {
    final box = Hive.box<String>(_watchlistBox);
    // Serialize Movie to JSON String because Hive needs TypeAdapters for custom objects
    // or we can just store the JSON string to avoid generating TypeAdapters.
    box.put(movie.id, jsonEncode(movie.toJson()));
  }

  Future<void> removeWatchlist(int id) async {
    final box = Hive.box<String>(_watchlistBox);
    box.delete(id);
  }

  bool isWatchlisted(int id) {
    final box = Hive.box<String>(_watchlistBox);
    return box.containsKey(id);
  }

  List<Movie> getWatchlist() {
    final box = Hive.box<String>(_watchlistBox);
    return box.values.map((e) => Movie.fromJson(jsonDecode(e))).toList();
  }
}
