import '../../data/models/ingesta_result.dart';

int compareIngestaResults(
  IngestaResult a,
  IngestaResult b,
  int columnIndex,
) {
  switch (columnIndex) {
    case 0:
      return a.accountNumber.compareTo(b.accountNumber);
    case 1:
      return a.totalConsumoUsdt.compareTo(b.totalConsumoUsdt);
    case 2:
      return a.totalConsumoBs.compareTo(b.totalConsumoBs);
    case 3:
      return a.nivelIndex.compareTo(b.nivelIndex);
    case 4:
      return a.porcentajeReintegro.compareTo(b.porcentajeReintegro);
    case 5:
      return a.reintegroUsdt.compareTo(b.reintegroUsdt);
    case 6:
      return a.reintegroBs.compareTo(b.reintegroBs);
    default:
      return 0;
  }
}

List<IngestaResult> sortIngestaResults(
  List<IngestaResult> source, {
  required int columnIndex,
  required bool ascending,
}) {
  final sorted = List<IngestaResult>.from(source);
  sorted.sort((a, b) {
    final cmp = compareIngestaResults(a, b, columnIndex);
    return ascending ? cmp : -cmp;
  });
  return sorted;
}
