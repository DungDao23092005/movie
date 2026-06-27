import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/movie.dart';
import '../../models/movie_list_arguments.dart';
import '../../services/movie_service.dart';
import '../../widgets/movie_card.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/empty_view.dart';

class MovieListScreen extends StatefulWidget {
  final MovieListArguments arguments;

  const MovieListScreen({
    super.key,
    required this.arguments,
  });

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final MovieService _service = MovieService();

  final ScrollController _scrollController = ScrollController();

  final List<Movie> _movies = [];

  int _page = 1;

  bool _loading = true;

  bool _loadingMore = false;

  bool _hasMore = true;

  String? _error;

  @override
  void initState() {
    super.initState();

    _loadMovies();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_loadingMore) return;

    if (!_hasMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;

    final current = _scrollController.position.pixels;

    if (current >= maxScroll - 300) {
      _loadMore();
    }
  }

  Future<List<Movie>> _fetchPage(int page) {
    switch (widget.arguments.type) {
      case MovieListType.latest:
        return _service.getLatestMovies(page: page);

      case MovieListType.category:
        return _service.getMoviesByCategory(
          widget.arguments.slug,
          page: page,
        );

      case MovieListType.genre:
        return _service.getMoviesByGenre(
          widget.arguments.slug,
          page: page,
        );

      case MovieListType.country:
        return _service.getMoviesByCountry(
          widget.arguments.slug,
          page: page,
        );

      case MovieListType.year:
        return _service.getMoviesByYear(
          widget.arguments.slug,
          page: page,
        );
    }
  }

  Future<void> _loadMovies() async {
    setState(() {
      _loading = true;
      _error = null;
      _page = 1;
      _hasMore = true;
      _movies.clear();
    });

    try {
      final movies = await _fetchPage(1);

      if (!mounted) return;

      setState(() {
        _movies.addAll(movies);
        _loading = false;
        _hasMore = movies.isNotEmpty;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore) return;

    if (!_hasMore) return;

    setState(() {
      _loadingMore = true;
    });

    try {
      final nextPage = _page + 1;

      final movies = await _fetchPage(nextPage);

      if (!mounted) return;

      setState(() {
        _page = nextPage;

        _movies.addAll(movies);

        _loadingMore = false;

        if (movies.isEmpty) {
          _hasMore = false;
        }
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.arguments.title),
      ),
      body: RefreshIndicator(
  onRefresh: _loadMovies,
  child: _loading
      ? const LoadingView()
      : _error != null
          ? ErrorView(
              error: _error!,
              onRetry: _loadMovies,
            )
          : _movies.isEmpty
              ? const EmptyView(
                  icon: Icons.movie_outlined,
                  title: "Không có dữ liệu",
                )
              : GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _movies.length + (_loadingMore ? 1 : 0),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.58,
                  ),
                  itemBuilder: (context, index) {
                    if (index >= _movies.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: LoadingView(),
                        ),
                      );
                    }

                    final movie = _movies[index];

                    return MovieCard(
                      movie: movie,
                      onTap: () async {
                        await context.push(
                          "/detail",
                          extra: movie.slug,
                        );

                        if (!mounted) return;

                        setState(() {});
                      },
                    );
                  },
                ),
              ),    
);
  }
}