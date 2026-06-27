import 'package:flutter/material.dart';

import '../../core/theme/theme_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, themeMode, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Cá nhân"),
          ),
          body: ListView(
            children: [
              const SizedBox(height: 24),

              const CircleAvatar(
                radius: 45,
                child: Icon(
                  Icons.movie,
                  size: 40,
                ),
              ),

              const SizedBox(height: 16),

              const Center(
                child: Text(
                  "Movie App",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Center(
                child: Text(
                  "Version 1.0.0",
                ),
              ),

              const SizedBox(height: 32),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Giao diện",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              RadioGroup<AppThemeMode>(
                groupValue: themeController.currentMode,
                onChanged: (value) {
                  if (value != null) {
                    themeController.setTheme(value);
                  }
                },
                child: Column(
                  children: const [
                    RadioListTile<AppThemeMode>(
                      value: AppThemeMode.system,
                      secondary: Icon(Icons.phone_android),
                      title: Text("Theo hệ thống"),
                    ),
                    RadioListTile<AppThemeMode>(
                      value: AppThemeMode.light,
                      secondary: Icon(Icons.light_mode),
                      title: Text("Sáng"),
                    ),
                    RadioListTile<AppThemeMode>(
                      value: AppThemeMode.dark,
                      secondary: Icon(Icons.dark_mode),
                      title: Text("Tối"),
                    ),
                  ],
                ),
              ),

              const Divider(height: 32),

              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text("Yêu thích"),
                subtitle: const Text("Danh sách phim đã lưu"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Điều hướng sang FavoriteScreen
                },
              ),

              ListTile(
                leading: const Icon(Icons.history),
                title: const Text("Lịch sử xem"),
                subtitle: const Text("Các phim đã xem gần đây"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Điều hướng sang HistoryScreen
                },
              ),

              const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text("Về ứng dụng"),
                subtitle: Text("Movie App Flutter"),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}