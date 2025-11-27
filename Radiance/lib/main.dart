import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';
import 'core/data/database/local_database.dart';
import 'core/data/database/web_storage.dart';
import 'core/di/dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configura Dependency Injection
  await setupDependencyInjection();
  
  // Inicializa o armazenamento de acordo com a plataforma
  if (kIsWeb) {
    // Web: usa armazenamento em memória com dados de teste
    await WebStorage.instance.seedTestData();
  } else {
    // Nativo: usa SQLite
    await LocalDatabase.instance.database;
  }
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const RadianceApp(),
    ),
  );
}

/// Radiance - Professional Diamond Price Prediction Platform
class RadianceApp extends StatelessWidget {
  const RadianceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: 'Radiance - Professional Diamond Prediction',
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