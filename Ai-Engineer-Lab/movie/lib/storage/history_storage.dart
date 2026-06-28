import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/history_movie.dart';

class HistoryStorage {
  HistoryStorage._();

  static const String _key = "watch_history";

  /// Lấy toàn bộ lịch sử xem
  static Future<List<HistoryMovie>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_key);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList
        .map(
          (e) => HistoryMovie.fromJson(
            Map<String, dynamic>.from(e),
          ),
        )
        .toList();
  }

  /// Ghi toàn bộ lịch sử
  static Future<void> saveHistory(
    List<HistoryMovie> movies,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(
      movies.map((e) => e.toJson()).toList(),
    );

    await prefs.setString(
      _key,
      jsonString,
    );
  }

  /// Thêm/Cập nhật lịch sử
  static Future<void> addHistory(
    HistoryMovie movie,
  ) async {
    final history = await getHistory();

    history.removeWhere(
      (e) =>
          e.slug == movie.slug &&
          e.episodeName == movie.episodeName,
    );

    history.insert(
      0,
      movie.copyWith(
        watchedAt: DateTime.now(),
      ),
    );

    if (history.length > 30) {
      history.removeRange(
        30,
        history.length,
      );
    }

    await saveHistory(history);
  }

  /// Xóa 1 mục
  static Future<void> removeHistory(
    String slug,
    String episodeName,
  ) async {
    final history = await getHistory();

    history.removeWhere(
      (e) =>
          e.slug == slug &&
          e.episodeName == episodeName,
    );

    await saveHistory(history);
  }

  /// Xóa toàn bộ
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_key);
  }

  /// Thêm phương thức này vào bên trong class HistoryStorage
  static Future<void> updateWatchPosition(String slug, String episodeName, int positionInSeconds) async {
    final history = await getHistory();
    
    final index = history.indexWhere(
      (e) => e.slug == slug && e.episodeName == episodeName,
    );

    if (index != -1) {
      final updatedMovie = history[index].copyWith(
        position: positionInSeconds,
        watchedAt: DateTime.now(),
      );
      history[index] = updatedMovie;
      
      // Đưa phim vừa xem lên đầu danh sách
      final item = history.removeAt(index);
      history.insert(0, item);
      
      await saveHistory(history);
    }
  }
}