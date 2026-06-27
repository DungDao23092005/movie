import 'package:flutter/material.dart';

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

  final pages = const [

    HomeScreen(),

    SearchScreen(),

    FavoriteScreen(),

    ProfileScreen(),

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

        onDestinationSelected: (value){

          setState(() {

            currentIndex=value;

          });

        },

        destinations: const [

          NavigationDestination(

            icon: Icon(Icons.home_outlined),

            selectedIcon: Icon(Icons.home),

            label: "Home",

          ),

          NavigationDestination(

            icon: Icon(Icons.search),

            label: "Search",

          ),

          NavigationDestination(

            icon: Icon(Icons.favorite_outline),

            selectedIcon: Icon(Icons.favorite),

            label: "Favorite",

          ),

          NavigationDestination(

            icon: Icon(Icons.person_outline),

            selectedIcon: Icon(Icons.person),

            label: "Profile",

          ),

        ],

      ),

    );

  }
}