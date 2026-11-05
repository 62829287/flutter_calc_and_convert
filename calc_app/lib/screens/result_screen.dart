import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/calculator_service.dart';
import '../services/currency_service.dart';
import '../widgets/constrained_form.dart';
import '../widgets/theme_toggle.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, String> params;

  const ResultScreen({super.key, required this.params});

  static String _symbol(String? op) {
    switch (op) {
      case 'add': return '+';
      case 'subtract': return '−';
      case 'multiply': return '×';
      case 'divide': return '÷';
      default: return '?';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasCalcParams = params.containsKey('op') || params.containsKey('a') || params.containsKey('b');
    final hasConvParams = params.containsKey('from') || params.containsKey('to') || params.containsKey('amount');

    Widget content;
    if (hasCalcParams && hasConvParams) {
      content = const _ErrorCard(message: 'Параметры калькулятора и конвертера не могут быть вместе');
    } else if (hasCalcParams) {
      content = _buildCalculator(context, params);
    } else if (hasConvParams) {
      content = _buildConverter(context, params);
    } else {
      content = const _ErrorCard(message: 'Не переданы параметры результата:\n(op, a, b) или (from, to, amount)');
    }

    return Scaffold(
      appBar: AppBar(
        // Кнопка Назад наверху
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Назад',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text('Результат'),
        actions: const [ThemeToggle(), SizedBox(width: 8)],
      ),
      body: SingleChildScrollView(
        child: ConstrainedForm(child: content),
      ),
    );
  }

  Widget _buildCalculator(BuildContext context, Map<String, String> params) {
    final op = params['op'];
    final aStr = params['a'];
    final bStr = params['b'];

    if (op == null || aStr == null || bStr == null) {
      return const _ErrorCard(message: 'Не хватает параметров калькулятора (op, a, b)');
    }

    final a = double.tryParse(aStr);
    final b = double.tryParse(bStr);
    if (a == null || b == null) {
      return const _ErrorCard(message: 'Параметры a и b должны быть числами');
    }

    try {
      final result = CalculatorService.compute(operation: op, a: a, b: b);
      final expression = '${CalculatorService.formatNumber(a)} ${_symbol(op)} ${CalculatorService.formatNumber(b)}';
      final resultText = CalculatorService.formatNumber(result);
      
      return _SuccessCard(
        topText: expression,
        bottomText: resultText,
        bottomColor: Theme.of(context).colorScheme.primary,
      );
    } on CalculationException catch (e) {
      return _ErrorCard(message: e.message);
    }
  }

  Widget _buildConverter(BuildContext context, Map<String, String> params) {
    final from = params['from'];
    final to = params['to'];
    final amountStr = params['amount'];

    if (from == null || to == null || amountStr == null) {
      return const _ErrorCard(message: 'Не хватает параметров конвертации (from, to, amount)');
    }
    if (!CurrencyService.currencies.contains(from)) {
      return _ErrorCard(message: 'Неизвестная валюта: $from');
    }
    if (!CurrencyService.currencies.contains(to)) {
      return _ErrorCard(message: 'Неизвестная валюта: $to');
    }

    final amount = double.tryParse(amountStr);
    if (amount == null) {
      return const _ErrorCard(message: 'Сумма должна быть числом');
    }
    if (amount < 0) {
      return const _ErrorCard(message: 'Сумма не может быть отрицательной');
    }

    try {
      final result = CurrencyService.convert(from: from, to: to, amount: amount);
      return _SuccessCard(
        topText: '${CalculatorService.formatNumber(amount)} $from',
        bottomText: '${CalculatorService.formatNumber(result)} $to',
        bottomColor: Colors.green,
      );
    } on ArgumentError catch (e) {
      return _ErrorCard(message: e.message.toString());
    }
  }
}

class _SuccessCard extends StatelessWidget {
  final String topText;
  final String bottomText;
  final Color bottomColor;

  const _SuccessCard({
    required this.topText,
    required this.bottomText,
    required this.bottomColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              topText,
              style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              bottomText,
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: bottomColor,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
            ),
          ],
        ),
      ),
    );
  }
}