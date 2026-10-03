import 'package:intl/intl.dart';

final NumberFormat _botanicaRupiahFormat = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0,
);

final NumberFormat _botanicaNumberFormat = NumberFormat('#,###', 'id_ID');

/// Format integer price into standard Indonesian Rupiah (e.g. `Rp 489.000`)
String formatBotanicaRupiah(num amount) {
  return _botanicaRupiahFormat.format(amount);
}

/// Format integer into clean Rupiah (e.g. `Rp 245.000`)
String formatBotanicaRupiahClean(num amount) {
  return 'Rp ${_botanicaNumberFormat.format(amount)}';
}
