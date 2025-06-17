import 'package:junetech/features/scan/domain/entities/scan_entity.dart';

class ScanModel {
  final int id;
  final String registration;
  final String typeScan;
  final DateTime dateScan;
  final int jourEvenement;

  ScanModel({
    required this.id,
    required this.registration,
    required this.typeScan,
    required this.dateScan,
    required this.jourEvenement,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) {
    return ScanModel(
      id: json['id'] as int,
      registration: json['registration'] as String,
      typeScan: json['type_scan'] as String,
      dateScan: DateTime.parse(json['date_scan'] as String),
      jourEvenement: json['jour_evenement'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registration': registration,
      'type_scan': typeScan,
      'date_scan': dateScan.toIso8601String(),
      'jour_evenement': jourEvenement,
    };
  }

  ScanEntity toEntity() {
    return ScanEntity(
      id: id,
      registration: registration,
      typeScan: typeScan,
      dateScan: dateScan,
      jourEvenement: jourEvenement,
    );
  }
}
