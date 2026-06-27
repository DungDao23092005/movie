import 'movie.dart';

class HomeSection {
  final String title;
  final String slug;
  final List<Movie> movies;

  const HomeSection({
    required this.title,
    required this.slug,
    required this.movies,
  });
}