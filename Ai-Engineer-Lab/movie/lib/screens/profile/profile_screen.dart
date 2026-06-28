import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../core/theme/theme_controller.dart';
import '../favorite/favorite_screen.dart';
import '../history/history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale.languageCode;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, themeMode, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("profile".tr()), // Đã gắn .tr()
          ),
          body: ListView(
            children: [
              const SizedBox(height: 24),
              const CircleAvatar(
                radius: 45,
                child: Icon(Icons.movie, size: 40),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "Movie App",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const Center(
                child: Text("Version 1.0.0"),
              ),
              const SizedBox(height: 32),

              /// PHẦN 1: GIAO DIỆN
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "theme".tr(), // Đã gắn .tr()
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  children: [
                    RadioListTile<AppThemeMode>(
                      value: AppThemeMode.system,
                      secondary: const Icon(Icons.phone_android),
                      title: Text("system_theme".tr()), // Đã gắn .tr()
                    ),
                    RadioListTile<AppThemeMode>(
                      value: AppThemeMode.light,
                      secondary: const Icon(Icons.light_mode),
                      title: Text("light_theme".tr()), // Đã gắn .tr()
                    ),
                    RadioListTile<AppThemeMode>(
                      value: AppThemeMode.dark,
                      secondary: const Icon(Icons.dark_mode),
                      title: Text("dark_theme".tr()), // Đã gắn .tr()
                    ),
                  ],
                ),
              ),

              const Divider(height: 32),

              /// PHẦN 2: NGÔN NGỮ
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "language".tr(), // Đã gắn .tr()
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),

              ListTile(
                leading: const Text("🇻🇳", style: TextStyle(fontSize: 24)),
                title: const Text("Tiếng Việt"), // Riêng tên ngôn ngữ nên để gốc
                trailing: currentLocale == 'vi' ? const Icon(Icons.check, color: Colors.red) : null,
                onTap: () => context.setLocale(const Locale('vi', 'VN')),
              ),
              ListTile(
                leading: const Text("🇺🇸", style: TextStyle(fontSize: 24)),
                title: const Text("English"),
                trailing: currentLocale == 'en' ? const Icon(Icons.check, color: Colors.red) : null,
                onTap: () => context.setLocale(const Locale('en', 'US')),
              ),
              ListTile(
                leading: const Text("🇨🇳", style: TextStyle(fontSize: 24)),
                title: const Text("中文"),
                trailing: currentLocale == 'zh' ? const Icon(Icons.check, color: Colors.red) : null,
                onTap: () => context.setLocale(const Locale('zh', 'CN')),
              ),

              const Divider(height: 32),

              /// PHẦN 3: MENU CHỨC NĂNG
              ListTile(
                leading: const Icon(Icons.favorite),
                title: Text("favorite".tr()), // Đã gắn .tr()
                subtitle: Text("favorite_sub".tr()), // Đã gắn .tr()
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoriteScreen()));
                },
              ),

              ListTile(
                leading: const Icon(Icons.history),
                title: Text("history".tr()), // Đã gắn .tr()
                subtitle: Text("history_sub".tr()), // Đã gắn .tr()
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen()));
                },
              ),

              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text("about".tr()), // Đã gắn .tr()
                subtitle: const Text("Movie App Flutter"),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}