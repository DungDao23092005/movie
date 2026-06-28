import 'package:go_router/go_router.dart';

import '../../models/movie_list_arguments.dart';
import '../../screens/detail/detail_screen.dart';
import '../../screens/main_screen.dart';
import '../../screens/movie_list/movie_list_screen.dart';
import '../../screens/search/search_screen.dart';
import '../../screens/watch/watch_screen.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: "/",
    routes: [
      /// Main Screen
      GoRoute(
        path: "/",
        builder: (context, state) => const MainScreen(),
      ),

      /// Search
      GoRoute(
        path: "/search",
        builder: (context, state) => const SearchScreen(),
      ),

      /// Detail
      GoRoute(
        path: "/detail",
        builder: (context, state) {
          final slug = state.extra as String;

          return DetailScreen(
            slug: slug,
          );
        },
      ),

      /// Watch (Đã cập nhật theo yêu cầu)
      GoRoute(
        path: "/watch",
        builder: (context, state) {
          final embedUrl = state.extra as String; // Chỉ lấy chuỗi URL
          return WatchScreen(embedUrl: embedUrl);
        },
      ),

      /// Movie List
      GoRoute(
        path: "/movies",
        builder: (context, state) {
          final args = state.extra as MovieListArguments;

          return MovieListScreen(
            arguments: args,
          );
        },
      ),
    ],
  );
}