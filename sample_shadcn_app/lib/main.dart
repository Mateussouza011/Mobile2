import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'core/theme/theme.dart';

void main() {
  runApp(const SampleShadcnApp());
}

/// Aplicação principal
class SampleShadcnApp extends StatelessWidget {
  const SampleShadcnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sample Shadcn App',
      debugShowCheckedModeBanner: false,
      theme: ShadcnTheme.lightTheme,
      darkTheme: ShadcnTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
