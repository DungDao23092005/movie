class Movie {
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

  const Movie({
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
    this.director,
    this.casts,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      originalName: json['original_name'] ?? '',
      thumbUrl: json['thumb_url'] ?? '',
      posterUrl: json['poster_url'] ?? '',
      description: json['description'] ?? '',
      totalEpisodes: json['total_episodes'] ?? 0,
      currentEpisode: json['current_episode'] ?? '',
      time: json['time'] ?? '',
      quality: json['quality'] ?? '',
      language: json['language'] ?? '',
      director: json['director'],
      casts: json['casts'],
    );
  }
}