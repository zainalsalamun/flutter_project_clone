const List<String> _idDays = [
  'Sen',
  'Sel',
  'Rab',
  'Kam',
  'Jum',
  'Sab',
  'Min',
];

const List<String> _idMonths = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

String formatTravelCurrency(num amount) {
  final intVal = amount.round();
  final digits = intVal.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write('.');
    }
    buffer.write(digits[i]);
  }
  return 'Rp $buffer';
}

String formatTravelDate(DateTime date) {
  final dayName = _idDays[(date.weekday - 1).clamp(0, 6)];
  final monthName = _idMonths[(date.month - 1).clamp(0, 11)];
  return '$dayName, ${date.day} $monthName ${date.year}';
}

String formatTravelTime(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
