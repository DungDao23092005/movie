import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/movie.dart';

class SmallMovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;

  const SmallMovieCard({
    super.key,
    required this.movie,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: .72,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: movie.posterUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, _) => Container(
                    color: Colors.grey.shade300,
                  ),
                  errorWidget: (_, _, error) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.movie),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              movie.currentEpisode,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }
}