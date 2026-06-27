class FavoriteMovie {
  final String slug;
  final String name;
  final String originalName;
  final String posterUrl;
  final String thumbUrl;

  const FavoriteMovie({
    required this.slug,
    required this.name,
    required this.originalName,
    required this.posterUrl,
    required this.thumbUrl,
  });

  factory FavoriteMovie.fromJson(Map<String, dynamic> json) {
    return FavoriteMovie(
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
      originalName: json['originalName'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      thumbUrl: json['thumbUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'originalName': originalName,
      'posterUrl': posterUrl,
      'thumbUrl': thumbUrl,
    };
  }

  FavoriteMovie copyWith({
    String? slug,
    String? name,
    String? originalName,
    String? posterUrl,
    String? thumbUrl,
  }) {
    return FavoriteMovie(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      originalName: originalName ?? this.originalName,
      posterUrl: posterUrl ?? this.posterUrl,
      thumbUrl: thumbUrl ?? this.thumbUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FavoriteMovie && other.slug == slug;
  }

  @override
  int get hashCode => slug.hashCode;
}