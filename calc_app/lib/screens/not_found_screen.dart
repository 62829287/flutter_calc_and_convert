import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/theme_toggle.dart';

class NotFoundScreen extends StatelessWidget {
  final Uri? uri;

  const NotFoundScreen({super.key, this.uri});

  @override
  Widget build(BuildContext context) {
    final path = uri?.toString() ?? '/unknown';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Страница не найдена'),
        actions: const [ThemeToggle(), SizedBox(width: 8)],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('404',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      )),
              const SizedBox(height: 16),
              Icon(Icons.search_off,
                  size: 64, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(height: 16),
              Text('ВСЕ ФИГНЯ, МИША! Страница не найдена',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text('Путь: $path',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text('На главную'),
                onPressed: () => context.go('/'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}