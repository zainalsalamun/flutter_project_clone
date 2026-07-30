import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(double amount) {
    // Fake Store API returns prices in USD, so we format as USD.
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }
}
