import 'package:flutter/material.dart';
import '../theme/theme_scope.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ThemeScope.of(context);
    final isDark = controller.mode == ThemeMode.dark;
    return IconButton(
      tooltip: isDark ? 'Светлая тема' : 'Тёмная тема',
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      onPressed: controller.toggle,
    );
  }
}