import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo easy_localization
  await EasyLocalization.ensureInitialized();
  
  await themeController.loadTheme();

  // Bọc ứng dụng trong EasyLocalization
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('vi', 'VN'),
        Locale('en', 'US'),
        Locale('zh', 'CN'),
      ],
      path: 'assets/translations', // Thư mục chứa các file JSON ngôn ngữ
      fallbackLocale: const Locale('vi', 'VN'), // Ngôn ngữ mặc định khi xảy ra lỗi
      child: const MovieApp(),
    ),
  );
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, themeMode, child) {
        return MaterialApp.router(
          // Cấu hình đa ngôn ngữ cho MaterialApp
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          
          debugShowCheckedModeBanner: false,
          title: "Movie App",
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}