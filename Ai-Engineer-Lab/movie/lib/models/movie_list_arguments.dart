enum MovieListType {
  latest,
  category,
  genre,
  country,
  year,
}

class MovieListArguments {
  final String title;
  final String slug;
  final MovieListType type;

  const MovieListArguments({
    required this.title,
    required this.slug,
    required this.type,
  });
}