import '../core/api/api_service.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';

class MovieService {
  final ApiService _api = ApiService();

  // ===========================
  // Parse Movie List
  // ===========================

  List<Movie> _parseMovieList(Map<String, dynamic> json) {
    final List<dynamic> items = json["items"] ?? [];

    return items
        .map((e) => Movie.fromJson(e))
        .toList();
  }

  // ===========================
  // Latest
  // ===========================

  Future<List<Movie>> getLatestMovies({
    int page = 1,
  }) async {
    final response = await _api.get(
      "/films/phim-moi-cap-nhat",
      queryParameters: {
        "page": page,
      },
    );

    return _parseMovieList(response.data);
  }

  // ===========================
  // Category
  // ===========================

  Future<List<Movie>> getMoviesByCategory(
    String slug, {
    int page = 1,
  }) async {
    final response = await _api.get(
      "/films/danh-sach/$slug",
      queryParameters: {
        "page": page,
      },
    );

    return _parseMovieList(response.data);
  }

  // ===========================
  // Genre
  // ===========================

  Future<List<Movie>> getMoviesByGenre(
    String slug, {
    int page = 1,
  }) async {
    final response = await _api.get(
      "/films/the-loai/$slug",
      queryParameters: {
        "page": page,
      },
    );

    return _parseMovieList(response.data);
  }

  // ===========================
  // Country
  // ===========================

  Future<List<Movie>> getMoviesByCountry(
    String slug, {
    int page = 1,
  }) async {
    final response = await _api.get(
      "/films/quoc-gia/$slug",
      queryParameters: {
        "page": page,
      },
    );

    return _parseMovieList(response.data);
  }

  // ===========================
  // Year
  // ===========================

  Future<List<Movie>> getMoviesByYear(
    String year, {
    int page = 1,
  }) async {
    final response = await _api.get(
      "/films/nam-phat-hanh/$year",
      queryParameters: {
        "page": page,
      },
    );

    return _parseMovieList(response.data);
  }

  // ===========================
  // Search
  // ===========================

  Future<List<Movie>> searchMovies(
    String keyword,
  ) async {
    final response = await _api.get(
      "/films/search",
      queryParameters: {
        "keyword": keyword,
      },
    );

    return _parseMovieList(response.data);
  }

  // ===========================
  // Detail
  // ===========================

  Future<MovieDetail> getMovieDetail(
    String slug,
  ) async {
    final response = await _api.get(
      "/film/$slug",
    );

    return MovieDetail.fromJson(
      response.data["movie"],
    );
  }
}