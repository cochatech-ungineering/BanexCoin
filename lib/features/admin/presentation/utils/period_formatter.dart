const _months = [
  'enero',
  'febrero',
  'marzo',
  'abril',
  'mayo',
  'junio',
  'julio',
  'agosto',
  'septiembre',
  'octubre',
  'noviembre',
  'diciembre',
];

String spanishMonth(int month) => _months[month - 1];

String formatAdminPeriod(DateTime d) => '${spanishMonth(d.month)} ${d.year}';
