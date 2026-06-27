import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/favorite_movie.dart';

class FavoriteStorage {
  FavoriteStorage._();

  static const String _key = "favorite_movies";

  /// Lấy toàn bộ danh sách yêu thích
  static Future<List<FavoriteMovie>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_key);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList
        .map(
          (e) => FavoriteMovie.fromJson(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();
  }

  /// Ghi toàn bộ danh sách
  static Future<void> saveFavorites(
    List<FavoriteMovie> movies,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(
      movies
          .map(
            (e) => e.toJson(),
          )
          .toList(),
    );

    await prefs.setString(
      _key,
      jsonString,
    );
  }

  /// Kiểm tra đã yêu thích chưa
  static Future<bool> isFavorite(
    String slug,
  ) async {
    final favorites = await getFavorites();

    return favorites.any(
      (movie) => movie.slug == slug,
    );
  }

  /// Thêm phim
  static Future<void> addFavorite(
    FavoriteMovie movie,
  ) async {
    final favorites = await getFavorites();

    final exists = favorites.any(
      (e) => e.slug == movie.slug,
    );

    if (exists) return;

    favorites.add(movie);

    await saveFavorites(favorites);
  }

  /// Xóa phim
  static Future<void> removeFavorite(
    String slug,
  ) async {
    final favorites = await getFavorites();

    favorites.removeWhere(
      (movie) => movie.slug == slug,
    );

    await saveFavorites(favorites);
  }

  /// Toggle Favorite
  static Future<bool> toggleFavorite(
    FavoriteMovie movie,
  ) async {
    final favorites = await getFavorites();

    final exists = favorites.any(
      (e) => e.slug == movie.slug,
    );

    if (exists) {
      favorites.removeWhere(
        (e) => e.slug == movie.slug,
      );

      await saveFavorites(favorites);

      return false;
    }

    favorites.add(movie);

    await saveFavorites(favorites);

    return true;
  }

  /// Xóa tất cả
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }
}