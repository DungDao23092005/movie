class Episode {
  final String name;
  final String slug;
  final String embed;

  const Episode({
    required this.name,
    required this.slug,
    required this.embed,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      name: json["name"] ?? "",
      slug: json["slug"] ?? "",
      embed: json["embed"] ?? "",
    );
  }
}