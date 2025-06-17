import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:junetech/features/scan/domain/entities/scan_summary_entity.dart';

abstract class ScanRepository {
  Future<Either<DioException, ScanSummaryEntity>> getScanSummary(
      int jourEvenement);
  Future<Either<DioException, Unit>> recordScan({
    required String registrationNumber,
    required String typeScan,
    required int jourEvenement,
  });
  Future<Either<DioException, Unit>> deleteScan(int scanId);
}
