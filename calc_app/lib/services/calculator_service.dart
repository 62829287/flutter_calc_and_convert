enum Operation { add, subtract, multiply, divide }

class CalculationException implements Exception {
  final String message;
  CalculationException(this.message);
  @override
  String toString() => message;
}

class CalculatorService {
  static const Map<String, Operation> operationsByName = {
    'add': Operation.add,
    'subtract': Operation.subtract,
    'multiply': Operation.multiply,
    'divide': Operation.divide,
  };

  static double compute({
    required String operation,
    required double a,
    required double b,
  }) {
    final op = operationsByName[operation];
    if (op == null) {
      throw CalculationException('Неизвестная операция: $operation');
    }
    switch (op) {
      case Operation.add:
        return a + b;
      case Operation.subtract:
        return a - b;
      case Operation.multiply:
        return a * b;
      case Operation.divide:
        if (b == 0) {
          throw CalculationException('Деление на ноль невозможно');
        }
        return a / b;
    }
  }

  static double? tryParse(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }

  static String formatNumber(double value) {
    if (value.isNaN) return 'NaN';
    if (value.isInfinite) return value > 0 ? '∞' : '-∞';
    if (value == value.roundToDouble() && value.abs() < 1e15) {
      return value.toInt().toString();
    }
    String s = value.toStringAsFixed(3);
    if (s.contains('.')) {
      s = s.replaceAll(RegExp(r'0+$'), '');
      s = s.replaceAll(RegExp(r'\.$'), '');
    }
    return s;
  }
}