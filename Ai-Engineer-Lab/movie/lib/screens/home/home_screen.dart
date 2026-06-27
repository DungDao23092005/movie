import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/movie.dart';
import '../../services/movie_service.dart';
import '../../widgets/home_banner.dart';
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
      _service.getMoviesByCategory("phim-sap-chieu"),
    ]);

    return HomeData(
      latest: results[0],
      nowPlaying: results[1],
      series: results[2],
      single: results[3],
      comingSoon: results[4],
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return _buildError(snapshot.error.toString());
            }

            if (!snapshot.hasData) {
              return _buildEmpty();
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
                      onPressed: () {
                        context.push("/search");
                      },
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),

                /// BANNER
                SliverToBoxAdapter(
                  child: HomeBanner(
                    movie: data.latest.first,
                    onTap: () {
                      context.push(
                        "/detail",
                        extra: data.latest.first.slug,
                      );
                    },
                  ),
                ),

                /// PHIM MỚI
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        title: "🔥 Phim mới cập nhật",
                      ),
                      HorizontalMovieList(
                        movies: data.latest,
                      ),
                    ],
                  ),
                ),

                /// ĐANG CHIẾU
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        title: "🎬 Đang chiếu",
                      ),
                      HorizontalMovieList(
                        movies: data.nowPlaying,
                      ),
                    ],
                  ),
                ),

                /// PHIM BỘ
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        title: "📺 Phim bộ",
                      ),
                      HorizontalMovieList(
                        movies: data.series,
                      ),
                    ],
                  ),
                ),

                /// PHIM LẺ
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        title: "🍿 Phim lẻ",
                      ),
                      HorizontalMovieList(
                        movies: data.single,
                      ),
                    ],
                  ),
                ),
                                /// SẮP CHIẾU
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(
                        title: "🎥 Sắp chiếu",
                      ),
                      HorizontalMovieList(
                        movies: data.comingSoon,
                      ),
                    ],
                  ),
                ),

                /// Bottom Space
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 25,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return ListView(
      children: const [
        SizedBox(height: 200),
        Icon(
          Icons.movie_creation_outlined,
          size: 90,
          color: Colors.grey,
        ),
        SizedBox(height: 15),
        Center(
          child: Text(
            "Không có dữ liệu",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildError(String error) {
    return ListView(
      children: [
        const SizedBox(height: 150),
        const Icon(
          Icons.error_outline,
          size: 90,
          color: Colors.red,
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _future = _loadData();
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Thử lại"),
          ),
        )
      ],
    );
  }
}

/// Model dùng riêng cho HomeScreen
class HomeData {
  final List<Movie> latest;
  final List<Movie> nowPlaying;
  final List<Movie> series;
  final List<Movie> single;
  final List<Movie> comingSoon;

  const HomeData({
    required this.latest,
    required this.nowPlaying,
    required this.series,
    required this.single,
    required this.comingSoon,
  });
}