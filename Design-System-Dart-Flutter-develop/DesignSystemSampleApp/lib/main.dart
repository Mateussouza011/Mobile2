import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const ShadcnDesignSystemApp(),
    ),
  );
}

/// Aplicação principal baseada no Shadcn/UI e Origin UI
class ShadcnDesignSystemApp extends StatelessWidget {
  const ShadcnDesignSystemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'Shadcn/UI Design System',
          debugShowCheckedModeBanner: false,
          theme: ShadcnTheme.lightTheme,
          darkTheme: ShadcnTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}