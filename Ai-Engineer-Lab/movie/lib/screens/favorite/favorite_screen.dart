import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/favorite_movie.dart';
import '../../models/movie.dart';
import '../../storage/favorite_storage.dart';
import '../../widgets/movie_card.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/common/empty_view.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({
    super.key,
  });

  @override
  State<FavoriteScreen> createState() => FavoriteScreenState();
}

class FavoriteScreenState extends State<FavoriteScreen> {
  List<FavoriteMovie> _favorites = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _loading = true;
    });

    final movies = await FavoriteStorage.getFavorites();

    if (!mounted) return;

    setState(() {
      _favorites = movies;
      _loading = false;
    });
  }

  Future<void> refreshFavorites() async {
    await _loadFavorites();
  }

  Movie _convertMovie(FavoriteMovie movie) {
    return Movie(
      name: movie.name,
      slug: movie.slug,
      originalName: movie.originalName,
      thumbUrl: movie.thumbUrl,
      posterUrl: movie.posterUrl,
      description: "",
      totalEpisodes: 0,
      currentEpisode: "",
      time: "",
      quality: "",
      language: "",
      director: null,
      casts: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yêu thích"),
      ),
      body: RefreshIndicator(
  onRefresh: _loadFavorites,
  child: _loading
      ? const LoadingView()
      : _favorites.isEmpty
          ? const EmptyView(
              icon: Icons.favorite_border,
              title: "Chưa có phim yêu thích",
              message: "Nhấn ❤️ trong màn hình chi tiết để lưu phim",
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _favorites.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.58,
              ),
              itemBuilder: (context, index) {
                final movie = _favorites[index];

                return MovieCard(
                  movie: _convertMovie(movie),
                  onTap: () async {
                    await context.push(
                      "/detail",
                      extra: movie.slug,
                    );

                    if (!mounted) return;

                    await _loadFavorites();
                  },
                );
              },
            ),
),
    );
  }
}