class HistoryMovie {
  final String slug;
  final String name;
  final String originalName;
  final String posterUrl;
  final String thumbUrl;
  final String episodeName;
  final String episodeEmbed;
  final DateTime watchedAt;
  final int position; 
  const HistoryMovie({
    required this.slug,
    required this.name,
    required this.originalName,
    required this.posterUrl,
    required this.thumbUrl,
    required this.episodeName,
    required this.episodeEmbed,
    required this.watchedAt,
    this.position = 0, 
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
      watchedAt: DateTime.tryParse(json['watchedAt'] ?? '') ?? DateTime.now(),
      position: json['position'] ?? 0, // Bổ sung
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
      'position': position, // Bổ sung
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
    int? position,
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
      position: position ?? this.position,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HistoryMovie && other.slug == slug && other.episodeName == episodeName;
  }

  @override
  int get hashCode => Object.hash(slug, episodeName);
}