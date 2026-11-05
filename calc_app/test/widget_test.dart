import 'package:flutter_test/flutter_test.dart';
import 'package:calc_app/services/calculator_service.dart';
import 'package:calc_app/services/currency_service.dart';

void main() {
  group('CalculatorService.compute', () {
    test('сложение возвращает сумму', () {
      expect(CalculatorService.compute(operation: 'add', a: 2, b: 3), 5);
    });

    test('вычитание возвращает разность', () {
      expect(CalculatorService.compute(operation: 'subtract', a: 5, b: 3), 2);
    });

    test('умножение возвращает произведение', () {
      expect(
          CalculatorService.compute(operation: 'multiply', a: 4, b: 2.5), 10);
    });

    test('деление возвращает частное', () {
      expect(CalculatorService.compute(operation: 'divide', a: 10, b: 4), 2.5);
    });

    test('деление на ноль бросает CalculationException', () {
      expect(
        () => CalculatorService.compute(operation: 'divide', a: 1, b: 0),
        throwsA(isA<CalculationException>()),
      );
    });

    test('неизвестная операция бросает CalculationException', () {
      expect(
        () => CalculatorService.compute(operation: 'modulo', a: 1, b: 2),
        throwsA(isA<CalculationException>()),
      );
    });
  });

  group('CalculatorService.tryParse', () {
    test('пустая строка возвращает null', () {
      expect(CalculatorService.tryParse(''), isNull);
      expect(CalculatorService.tryParse('   '), isNull);
    });

    test('нечисловой ввод возвращает null', () {
      expect(CalculatorService.tryParse('abc'), isNull);
      expect(CalculatorService.tryParse('1,5'), isNull);
    });

    test('корректное число парсится', () {
      expect(CalculatorService.tryParse('3.14'), 3.14);
      expect(CalculatorService.tryParse('-7'), -7.0);
    });
  });

  group('CalculatorService.formatNumber', () {

    test('целые числа без точки', () {
      expect(CalculatorService.formatNumber(8.0), '8');
    });

    test('0.1 + 0.2 форматируется как 0.3', () {
      expect(CalculatorService.formatNumber(0.1 + 0.2), '0.3');
    });
  });

  group('CurrencyService', () {
    test('конвертация EUR→USD', () {
      final result =
          CurrencyService.convert(from: 'EUR', to: 'USD', amount: 100);
      expect(result, closeTo(110, 0.001));
    });

    test('конвертация USD→EUR', () {
      final result =
          CurrencyService.convert(from: 'USD', to: 'EUR', amount: 110);
      expect(result, closeTo(100, 0.001));
    });

    test('неизвестная валюта бросает ArgumentError', () {
      expect(
        () => CurrencyService.convert(from: 'XYZ', to: 'USD', amount: 1),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}