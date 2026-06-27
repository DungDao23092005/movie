import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/movie.dart';
import '../../services/movie_service.dart';
import '../../widgets/movie_card.dart';
import '../../widgets/common/loading_view.dart';
import '../../widgets/common/error_view.dart';
import '../../widgets/common/empty_view.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MovieService _service = MovieService();

  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;

  List<Movie> _movies = [];

  bool _loading = false;

  String? _error;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () {
        _search(value);
      },
    );
  }

  Future<void> _search(String keyword) async {
    keyword = keyword.trim();

    if (keyword.isEmpty) {
      setState(() {
        _movies.clear();
        _error = null;
        _loading = false;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final result = await _service.searchMovies(keyword);

      if (!mounted) return;

      setState(() {
        _movies = result;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tìm kiếm"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              onChanged: _onChanged,
              decoration: InputDecoration(
                hintText: "Nhập tên phim...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();

                          setState(() {
                            _movies.clear();
                            _error = null;
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          if (_loading)
            const Expanded(
              child: LoadingView(),
            )
          else if (_error != null)
            Expanded(
              child: ErrorView(
                error: _error!,
                onRetry: () {
                  _search(_controller.text);
                },
              ),
            )

          else if (_controller.text.isEmpty)
            const Expanded(
              child: EmptyView(
                icon: Icons.search,
                title: "Nhập tên phim để tìm kiếm",
              ),
            )

          else if (_movies.isEmpty)
            const Expanded(
              child: EmptyView(
                icon: Icons.movie_outlined,
                title: "Không tìm thấy phim",
                message: "Hãy thử tìm kiếm với từ khóa khác",
              ),
            )

          else
                      Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: _movies.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.58,
                ),
                itemBuilder: (context, index) {
                  final movie = _movies[index];

                  return MovieCard(
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
            ),
        ],
      ),
    );
  }
}