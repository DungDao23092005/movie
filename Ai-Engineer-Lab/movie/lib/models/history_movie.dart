class HistoryMovie {
  final String slug;
  final String name;
  final String originalName;
  final String posterUrl;
  final String thumbUrl;
  final String episodeName;
  final String episodeEmbed;
  final DateTime watchedAt;

  const HistoryMovie({
    required this.slug,
    required this.name,
    required this.originalName,
    required this.posterUrl,
    required this.thumbUrl,
    required this.episodeName,
    required this.episodeEmbed,
    required this.watchedAt,
  });

  factory HistoryMovie.fromJson(Map<String, dynamic> json) {
    return HistoryMovie(
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      originalName: json['originalName'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      thumbUrl: json['thumbUrl'] ?? '',
      episodeName: json['episodeName'] ?? '',
      episodeEmbed: json['episodeEmbed'] ?? '',
      watchedAt: DateTime.tryParse(
            json['watchedAt'] ?? '',
          ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'originalName': originalName,
      'posterUrl': posterUrl,
      'thumbUrl': thumbUrl,
      'episodeName': episodeName,
      'episodeEmbed': episodeEmbed,
      'watchedAt': watchedAt.toIso8601String(),
    };
  }

  HistoryMovie copyWith({
    String? slug,
    String? name,
    String? originalName,
    String? posterUrl,
    String? thumbUrl,
    String? episodeName,
    String? episodeEmbed,
    DateTime? watchedAt,
  }) {
    return HistoryMovie(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      originalName: originalName ?? this.originalName,
      posterUrl: posterUrl ?? this.posterUrl,
      thumbUrl: thumbUrl ?? this.thumbUrl,
      episodeName: episodeName ?? this.episodeName,
      episodeEmbed: episodeEmbed ?? this.episodeEmbed,
      watchedAt: watchedAt ?? this.watchedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HistoryMovie &&
        other.slug == slug &&
        other.episodeName == episodeName;
  }

  @override
  int get hashCode => Object.hash(
        slug,
        episodeName,
      );
}