import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/calculator_service.dart';
import '../widgets/constrained_form.dart';
import '../widgets/theme_toggle.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _aController = TextEditingController();
  final _bController = TextEditingController();
  String _operation = 'add';
  String? _error;

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    super.dispose();
  }

  void _submit() {
    final aText = _aController.text;
    final bText = _bController.text;
    final a = CalculatorService.tryParse(aText);
    final b = CalculatorService.tryParse(bText);

    if (aText.trim().isEmpty || bText.trim().isEmpty) {
      setState(() => _error = 'Оба поля должны быть заполнены');
      return;
    }
    if (a == null || b == null) {
      setState(() => _error = 'Оба значения должны быть числами');
      return;
    }
    setState(() => _error = null);
    final uri = Uri(
      path: '/result',
      queryParameters: {'op': _operation, 'a': aText.trim(), 'b': bText.trim()},
    );
    context.push(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'На главную',
          onPressed: () => context.go('/'),
        ),
        title: const Text('Калькулятор'),
        actions: const [ThemeToggle(), SizedBox(width: 8)],
      ),
      body: SingleChildScrollView(
        child: ConstrainedForm(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _aController,
                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                decoration: const InputDecoration(labelText: 'Первое число', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _bController,
                keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                decoration: const InputDecoration(labelText: 'Второе число', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              InputDecorator(
                decoration: const InputDecoration(labelText: 'Операция', border: OutlineInputBorder()),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _operation,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'add', child: Text('Сложение (+)')),
                      DropdownMenuItem(value: 'subtract', child: Text('Вычитание (−)')),
                      DropdownMenuItem(value: 'multiply', child: Text('Умножение (×)')),
                      DropdownMenuItem(value: 'divide', child: Text('Деление (÷)')),
                    ],
                    onChanged: (v) => setState(() => _operation = v ?? 'add'),
                  ),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _submit, child: const Text('Вычислить')),
            ],
          ),
        ),
      ),
    );
  }
}