import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'favorite/favorite_screen.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import 'search/search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int currentIndex = 0;

  final _favoriteKey = GlobalKey<FavoriteScreenState>();

late final List<Widget> pages = [
  const HomeScreen(),
  const SearchScreen(),
  FavoriteScreen(
    key: _favoriteKey,
  ),
  const ProfileScreen(),
];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: IndexedStack(

        index: currentIndex,

        children: pages,

      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
          if (index == 2) {
            _favoriteKey.currentState?.refreshFavorites();
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: "home".tr(), // Đổi ở đây
          ),
          NavigationDestination(
            icon: const Icon(Icons.search),
            label: "search".tr(), // Đổi ở đây
          ),
          NavigationDestination(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: const Icon(Icons.favorite),
            label: "favorite".tr(), // Đổi ở đây
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: "profile".tr(), // Đổi ở đây
          ),
        ],
      ),
    );

  }
}