class ScanEntity {
  final int id;
  final String registration;
  final String typeScan;
  final DateTime dateScan;
  final int jourEvenement;

  ScanEntity({
    required this.id,
    required this.registration,
    required this.typeScan,
    required this.dateScan,
    required this.jourEvenement,
  });
}
