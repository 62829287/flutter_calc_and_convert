class CurrencyService {
  static const Map<String, double> ratesToUsd = {
    'USD': 1.0,
    'EUR': 1.10,
    'GBP': 1.27,
    'JPY': 0.0064,
    'RUB': 0.011,
    'CNY': 0.14,
  };

  static List<String> get currencies => ratesToUsd.keys.toList();

  static double convert({
    required String from,
    required String to,
    required double amount,
  }) {
    final fromRate = ratesToUsd[from];
    final toRate = ratesToUsd[to];
    if (fromRate == null) {
      throw ArgumentError('Неизвестная валюта: $from');
    }
    if (toRate == null) {
      throw ArgumentError('Неизвестная валюта: $to');
    }
    return amount * fromRate / toRate;
  }
}