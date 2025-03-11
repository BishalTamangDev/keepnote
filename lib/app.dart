import 'package:flutter/material.dart';
import 'package:keepnote/config/routes/app_routes.dart';
import 'package:keepnote/config/theme/app_theme.dart';

class KeepNote extends StatelessWidget {
  const KeepNote({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Keep Note',
      routerConfig: AppRouter.appRouter,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
