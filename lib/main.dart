import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared/routing/app_router.dart';
import 'shared/themes/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Lab App',
      routerConfig: router,
      theme: AppTheme.darkTheme,
      // darkTheme: AppTheme.darkTheme,
      // themeMode: AppTheme.themeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}
