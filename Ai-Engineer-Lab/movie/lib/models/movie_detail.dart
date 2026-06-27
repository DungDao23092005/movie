import 'episode.dart';

class MovieDetail {
  final String id;
  final String name;
  final String slug;
  final String originalName;

  final String thumbUrl;
  final String posterUrl;

  final String description;

  final int totalEpisodes;

  final String currentEpisode;

  final String time;

  final String quality;

  final String language;

  final String? director;

  final String? casts;

  final List<String> genres;

  final List<String> countries;

  final List<String> years;

  final List<Episode> episodes;

  const MovieDetail({
    required this.id,
    required this.name,
    required this.slug,
    required this.originalName,
    required this.thumbUrl,
    required this.posterUrl,
    required this.description,
    required this.totalEpisodes,
    required this.currentEpisode,
    required this.time,
    required this.quality,
    required this.language,
    required this.director,
    required this.casts,
    required this.genres,
    required this.countries,
    required this.years,
    required this.episodes,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    final category = json["category"] ?? {};

    List<String> genres = [];

    List<String> countries = [];

    List<String> years = [];

    if (category["2"] != null) {
      genres = (category["2"]["list"] as List)
          .map((e) => e["name"].toString())
          .toList();
    }

    if (category["4"] != null) {
      countries = (category["4"]["list"] as List)
          .map((e) => e["name"].toString())
          .toList();
    }

    if (category["3"] != null) {
      years = (category["3"]["list"] as List)
          .map((e) => e["name"].toString())
          .toList();
    }

    List<Episode> episodeList = [];

    if (json["episodes"] != null) {
      final servers = json["episodes"] as List;

      if (servers.isNotEmpty) {
        episodeList = (servers.first["items"] as List)
            .map((e) => Episode.fromJson(e))
            .toList();
      }
    }

    return MovieDetail(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      slug: json["slug"] ?? "",
      originalName: json["original_name"] ?? "",
      thumbUrl: json["thumb_url"] ?? "",
      posterUrl: json["poster_url"] ?? "",
      description: json["description"] ?? "",
      totalEpisodes: json["total_episodes"] ?? 0,
      currentEpisode: json["current_episode"] ?? "",
      time: json["time"] ?? "",
      quality: json["quality"] ?? "",
      language: json["language"] ?? "",
      director: json["director"],
      casts: json["casts"],
      genres: genres,
      countries: countries,
      years: years,
      episodes: episodeList,
    );
  }
}