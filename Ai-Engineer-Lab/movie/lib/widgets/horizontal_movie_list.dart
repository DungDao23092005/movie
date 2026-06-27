import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/movie.dart';
import 'small_movie_card.dart';

class HorizontalMovieList extends StatelessWidget {
  final List<Movie> movies;

  const HorizontalMovieList({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final movie = movies[index];

          return SmallMovieCard(
            movie: movie,
            onTap: () {
              context.push(
                "/detail",
                extra: movie.slug,
              );
            },
          );
        },
      ),
    );
  }
}