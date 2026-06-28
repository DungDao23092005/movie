class Episode {
  final String name;
  final String slug;
  final String embed;
  final String m3u8Url; 

  const Episode({
    required this.name,
    required this.slug,
    required this.embed,
    required this.m3u8Url, 
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    print("=== DATA TẬP PHIM: $json");
    return Episode(
      name: json["name"] ?? "",
      slug: json["slug"] ?? "",
      embed: json["embed"] ?? json["link_embed"] ?? "",
      m3u8Url: json["m3u8"] ?? json["link_m3u8"] ?? "",
    );
  }
}