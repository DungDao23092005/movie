import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/history_movie.dart';
import '../../models/movie.dart';
import '../../storage/history_storage.dart';
import '../../widgets/movie_card.dart';
import '../../widgets/common/confirmation_dialog.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  List<HistoryMovie> _history = [];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> refreshHistory() async {
    await _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() {
      _loading = true;
    });

    final history = await HistoryStorage.getHistory();

    if (!mounted) return;

    setState(() {
      _history = history;
      _loading = false;
    });
  }

  Future<void> _removeItem(HistoryMovie movie) async {
    final messenger = ScaffoldMessenger.of(context);

    await HistoryStorage.removeHistory(
      movie.slug,
      movie.episodeName,
    );

    if (!mounted) return;

    await _loadHistory();

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Text(
          "Đã xóa ${movie.name}",
        ),
      ),
    );
  }

  Future<void> _clearAll() async {
    final messenger = ScaffoldMessenger.of(context);

    await HistoryStorage.clearHistory();

    if (!mounted) return;

    await _loadHistory();

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      const SnackBar(
        content: Text(
          "Đã xóa toàn bộ lịch sử",
        ),
      ),
    );
  }

  Movie _convertMovie(HistoryMovie movie) {
    return Movie(
      name: movie.name,
      slug: movie.slug,
      originalName: movie.originalName,
      thumbUrl: movie.thumbUrl,
      posterUrl: movie.posterUrl,
      description: "",
      totalEpisodes: 0,
      currentEpisode: movie.episodeName,
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
        title: const Text("Lịch sử xem"),
        actions: [
  if (_history.isNotEmpty)
    IconButton(
      icon: const Icon(Icons.delete_forever),
      onPressed: () async {
        final ok = await ConfirmationDialog.show(
          context,
          title: "Xóa toàn bộ lịch sử?",
          message:
              "Bạn có chắc chắn muốn xóa toàn bộ lịch sử xem không?",
          confirmText: "Xóa",
          cancelText: "Hủy",
        );

        if (ok == true) {
          await _clearAll();
        }
      },
    ),
],
      ),
      body: RefreshIndicator(
        onRefresh: _loadHistory,
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _history.isEmpty
                ? ListView(
                    children: const [
                      SizedBox(height: 140),
                      Icon(
                        Icons.history,
                        size: 90,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Chưa có lịch sử xem",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Center(
                        child: Text(
                          "Xem một bộ phim để lịch sử xuất hiện",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _history.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.58,
                    ),
                    itemBuilder: (context, index) {
                      final movie = _history[index];

                      return Dismissible(
                        key: ValueKey(
                          "${movie.slug}_${movie.episodeName}",
                        ),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) {
                          _removeItem(movie);
                        },
                        child: MovieCard(
                          movie: _convertMovie(movie),
                          onTap: () async {
                            await context.push(
                              "/detail",
                              extra: movie.slug,
                            );

                            if (!mounted) return;

                            await _loadHistory();
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}