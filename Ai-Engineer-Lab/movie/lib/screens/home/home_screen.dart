import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/movie.dart';
import '../../models/movie_list_arguments.dart';
import '../../services/movie_service.dart';
import '../../widgets/banner_slider.dart';
import '../../widgets/common/empty_view.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/horizontal_movie_list.dart';
import '../../widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MovieService _service = MovieService();

  late Future<HomeData> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadData();
  }

  Future<HomeData> _loadData() async {
    final results = await Future.wait([
      _service.getLatestMovies(),
      _service.getMoviesByCategory("phim-dang-chieu"),
      _service.getMoviesByCategory("phim-bo"),
      _service.getMoviesByCategory("phim-le"),
    ]);

    return HomeData(
      latest: results[0],
      nowPlaying: results[1],
      series: results[2],
      single: results[3],
    );
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _loadData();
    });

    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<HomeData>(
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
                    _future = _loadData();
                  });
                },
              );
            }

            if (!snapshot.hasData) {
              return const EmptyView(
                icon: Icons.movie_creation_outlined,
                title: "Không có dữ liệu",
              );
            }

            final data = snapshot.data!;

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                /// HEADER
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  elevation: 0,
                  expandedHeight: 90,
                  title: const Text(
                    "Movie",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        context.push("/search");
                      },
                    ),
                  ],
                ),

                /// Banner
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 12,
                      bottom: 8,
                    ),
                    child: BannerSlider(
                      movies: data.latest.take(5).toList(),
                    ),
                  ),
                ),

                /// Phim mới
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: "🔥 Phim mới cập nhật",
                        onSeeAll: () {
                          context.push(
                            "/movies",
                            extra: const MovieListArguments(
                              title: "Phim mới cập nhật",
                              slug: "",
                              type: MovieListType.latest,
                            ),
                          );
                        },
                      ),
                      HorizontalMovieList(
                        movies: data.latest,
                      ),
                    ],
                  ),
                ),

                /// Đang chiếu
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: "🎬 Đang chiếu",
                        onSeeAll: () {
                          context.push(
                            "/movies",
                            extra: const MovieListArguments(
                              title: "Đang chiếu",
                              slug: "phim-dang-chieu",
                              type: MovieListType.category,
                            ),
                          );
                        },
                      ),
                      HorizontalMovieList(
                        movies: data.nowPlaying,
                      ),
                    ],
                  ),
                ),

                /// Phim bộ
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: "📺 Phim bộ",
                        onSeeAll: () {
                          context.push(
                            "/movies",
                            extra: const MovieListArguments(
                              title: "Phim bộ",
                              slug: "phim-bo",
                              type: MovieListType.category,
                            ),
                          );
                        },
                      ),
                      HorizontalMovieList(
                        movies: data.series,
                      ),
                    ],
                  ),
                ),

                /// Phim lẻ
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: "🍿 Phim lẻ",
                        onSeeAll: () {
                          context.push(
                            "/movies",
                            extra: const MovieListArguments(
                              title: "Phim lẻ",
                              slug: "phim-le",
                              type: MovieListType.category,
                            ),
                          );
                        },
                      ),
                      HorizontalMovieList(
                        movies: data.single,
                      ),
                    ],
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 25),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class HomeData {
  final List<Movie> latest;
  final List<Movie> nowPlaying;
  final List<Movie> series;
  final List<Movie> single;

  const HomeData({
    required this.latest,
    required this.nowPlaying,
    required this.series,
    required this.single,
  });
}