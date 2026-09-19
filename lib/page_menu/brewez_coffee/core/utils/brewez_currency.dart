class BrewezCurrency {
  static String format(num amount) {
    final int val = amount.round();
    final str = val.toString();
    final reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final formatted = str.replaceAllMapped(reg, (Match m) => '${m[1]}.');
    return 'Rp $formatted';
  }
}
