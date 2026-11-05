import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/constrained_form.dart';
import '../widgets/theme_toggle.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная'),
        actions: const [ThemeToggle(), SizedBox(width: 8)],
      ),
      body: SingleChildScrollView(
        child: ConstrainedForm(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              ElevatedButton.icon(
                icon: const Icon(Icons.calculate),
                label: const Text('Калькулятор'),
                onPressed: () => context.go('/calculator'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.currency_exchange),
                label: const Text('Конвертер валют'),
                onPressed: () => context.go('/converter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}