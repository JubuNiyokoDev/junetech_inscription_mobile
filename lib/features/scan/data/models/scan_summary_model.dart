import 'package:equatable/equatable.dart';
import 'package:junetech/features/scan/data/models/scan_model.dart';
import 'package:junetech/features/scan/domain/entities/scan_summary_entity.dart';

class ScanSummaryModel extends Equatable {
  final int totalEntrees;
  final int totalSorties;
  final List<ScanModel> scans;

  const ScanSummaryModel({
    required this.totalEntrees,
    required this.totalSorties,
    required this.scans,
  });

  factory ScanSummaryModel.fromJson(Map<String, dynamic> json) {
    return ScanSummaryModel(
      totalEntrees: json['total_entrees'] as int,
      totalSorties: json['total_sorties'] as int,
      scans: (json['scans'] as List)
          .map((scan) => ScanModel.fromJson(scan as Map<String, dynamic>))
          .toList(),
    );
  }

  ScanSummaryEntity toEntity() {
    return ScanSummaryEntity(
      totalEntrees: totalEntrees,
      totalSorties: totalSorties,
      scans: scans.map((scan) => scan.toEntity()).toList(),
    );
  }

  @override
  List<Object> get props => [totalEntrees, totalSorties, scans];
}
