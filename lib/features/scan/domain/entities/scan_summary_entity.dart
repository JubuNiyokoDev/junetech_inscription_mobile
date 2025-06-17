import 'package:junetech/features/scan/domain/entities/scan_entity.dart';

class ScanSummaryEntity {
  final int totalEntrees;
  final int totalSorties;
  final List<ScanEntity> scans;

  ScanSummaryEntity({
    required this.totalEntrees,
    required this.totalSorties,
    required this.scans,
  });
}
