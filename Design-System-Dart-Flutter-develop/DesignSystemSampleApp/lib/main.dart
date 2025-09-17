import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const ShadcnDesignSystemApp());
}

/// Aplicação principal baseada no Shadcn/UI e Origin UI
class ShadcnDesignSystemApp extends StatelessWidget {
  const ShadcnDesignSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Shadcn/UI Design System',
      debugShowCheckedModeBanner: false,
      theme: ShadcnTheme.lightTheme,
      darkTheme: ShadcnTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}