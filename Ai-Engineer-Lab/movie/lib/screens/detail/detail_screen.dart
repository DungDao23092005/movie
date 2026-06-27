import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/movie_detail.dart';
import '../../models/favorite_movie.dart';
import '../../services/movie_service.dart';
import '../../storage/favorite_storage.dart';
import '../../widgets/episode_card.dart';
import '../../widgets/info_chip.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/empty_view.dart';

class DetailScreen extends StatefulWidget {
  final String slug;

  const DetailScreen({
    super.key,
    required this.slug,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final MovieService _service = MovieService();

  late Future<MovieDetail> _future;

  bool _isFavorite = false;

  Future<void> _loadFavoriteStatus() async {
    final value = await FavoriteStorage.isFavorite(widget.slug);

    if (!mounted) return;

    setState(() {
      _isFavorite = value;
    });
  }

  @override
  void initState() {
    super.initState();

    _future = _service.getMovieDetail(widget.slug);

    _loadFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<MovieDetail>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          }

          if (snapshot.hasError) {
            return ErrorView(
              error: snapshot.error.toString(),
              onRetry: () {
                setState(() {
                  _future = _service.getMovieDetail(widget.slug);
                });
              },
            );
          }

          if (!snapshot.hasData) {
            return const EmptyView(
              icon: Icons.movie,
              title: "Không tìm thấy thông tin phim",
              message: "Vui lòng thử lại sau",
            );
          }

          final movie = snapshot.data!;

          return CustomScrollView(
            slivers: [
              /// Ảnh nền + AppBar
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () => context.pop(),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () async {
                      final messenger = ScaffoldMessenger.of(context);

                      final favorite = FavoriteMovie(
                        slug: movie.slug,
                        name: movie.name,
                        originalName: movie.originalName,
                        posterUrl: movie.posterUrl,
                        thumbUrl: movie.thumbUrl,
                      );

                      final isFavorite =
                          await FavoriteStorage.toggleFavorite(favorite);

                      if (!mounted) return;

                      setState(() {
                        _isFavorite = isFavorite;
                      });

                      messenger.hideCurrentSnackBar();

                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite
                                ? "❤️ Đã thêm vào yêu thích"
                                : "🗑️ Đã xóa khỏi yêu thích",
                          ),
                        ),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: movie.posterUrl.isNotEmpty
                            ? movie.posterUrl
                            : movie.thumbUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey.shade900,
                          child: const Icon(
                            Icons.broken_image,
                            size: 50,
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black87,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Nội dung phim
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Tên phim
                      Text(
                        movie.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        movie.originalName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Info
                      Wrap(
                        children: [
                          if (movie.quality.isNotEmpty)
                            InfoChip(
                              icon: Icons.hd,
                              text: movie.quality,
                            ),
                          if (movie.time.isNotEmpty)
                            InfoChip(
                              icon: Icons.access_time,
                              text: movie.time,
                            ),
                          if (movie.years.isNotEmpty)
                            InfoChip(
                              icon: Icons.calendar_today,
                              text: movie.years.first,
                            ),
                          if (movie.language.isNotEmpty)
                            InfoChip(
                              icon: Icons.language,
                              text: movie.language,
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      /// Thể loại
                      if (movie.genres.isNotEmpty) ...[
                        const Text(
                          "Thể loại",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.genres.join(', '),
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      /// Đạo diễn
                      if (movie.director != null &&
                          movie.director!.isNotEmpty) ...[
                        Text(
                          "Đạo diễn: ${movie.director}",
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 8),
                      ],

                      /// Diễn viên
                      if (movie.casts != null &&
                          movie.casts!.isNotEmpty) ...[
                        Text(
                          "Diễn viên: ${movie.casts}",
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 16),
                      ],

                      /// Nội dung
                      const Text(
                        "Nội dung",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        movie.description.replaceAll(
                          RegExp(r'<[^>]*>'),
                          '',
                        ),
                        style: const TextStyle(
                          height: 1.5,
                          fontSize: 15,
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// Danh sách tập
                      const Text(
                        "Tập phim",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      if (movie.episodes.isNotEmpty)
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: movie.episodes.map((episode) {
                            return EpisodeCard(
                              episode: episode,
                              onTap: () {
                                context.push(
                                  '/watch',
                                  extra: episode.embed,
                                );
                              },
                            );
                          }).toList(),
                        )
                      else
                        const Text(
                          "Đang cập nhật tập phim...",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}