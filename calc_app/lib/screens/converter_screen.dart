import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/calculator_service.dart';
import '../services/currency_service.dart';
import '../services/preferences_service.dart';
import '../widgets/constrained_form.dart';
import '../widgets/theme_toggle.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});
  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final _amountController = TextEditingController();
  String _from = 'USD';
  String _to = 'EUR';
  String? _error;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final pair = await PreferencesService.loadConverterPair();
    if (!mounted) return;
    setState(() {
      if (pair.from != null && CurrencyService.currencies.contains(pair.from)) {
        _from = pair.from!;
      }
      if (pair.to != null && CurrencyService.currencies.contains(pair.to)) {
        _to = pair.to!;
      }
      _loaded = true;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _amountController.text;
    final amount = CalculatorService.tryParse(text);
    if (text.trim().isEmpty) {
      setState(() => _error = 'Введите сумму');
      return;
    }
    if (amount == null) {
      setState(() => _error = 'Сумма должна быть числом');
      return;
    }
    if (amount < 0) {
      setState(() => _error = 'Сумма не может быть отрицательной');
      return;
    }
    setState(() => _error = null);
    
    // На всякий случай сохраняем еще раз перед переходом
    await PreferencesService.saveConverterPair(_from, _to);
    
    if (!mounted) return;
    final uri = Uri(
      path: '/result',
      queryParameters: {'from': _from, 'to': _to, 'amount': text.trim()},
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
        title: const Text('Конвертер валют'),
        actions: const [ThemeToggle(), SizedBox(width: 8)],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: ConstrainedForm(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Из валюты',
                        border: OutlineInputBorder(),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _from,
                          isExpanded: true,
                          items: CurrencyService.currencies
                              .map((c) =>
                                  DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => _from = v);
                            // Сохраняем сразу при изменении
                            PreferencesService.saveConverterPair(_from, _to);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'В валюту',
                        border: OutlineInputBorder(),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _to,
                          isExpanded: true,
                          items: CurrencyService.currencies
                              .map((c) =>
                                  DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => _to = v);
                            // Сохраняем сразу при изменении
                            PreferencesService.saveConverterPair(_from, _to);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Сумма',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Text(_error!,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error)),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Конвертировать'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}