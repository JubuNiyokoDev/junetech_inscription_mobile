import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:junetech/features/scan/data/data_sources/scan_api_service.dart';
import 'package:junetech/features/scan/domain/entities/scan_summary_entity.dart';
import 'package:junetech/features/scan/domain/repositories/scan_repository.dart';

class ScanRepositoryImpl implements ScanRepository {
  final ScanApiService _scanApiService;

  ScanRepositoryImpl(this._scanApiService);

  @override
  Future<Either<DioException, ScanSummaryEntity>> getScanSummary(
      int jourEvenement) async {
    return await _scanApiService.getScanSummary(jourEvenement).then(
          (result) => result.fold(
            (error) => Left(error),
            (model) => Right(model.toEntity()),
          ),
        );
  }

  @override
  Future<Either<DioException, Unit>> recordScan({
    required String registrationNumber,
    required String typeScan,
    required int jourEvenement,
  }) async {
    return await _scanApiService
        .recordScan(
          registrationNumber: registrationNumber,
          typeScan: typeScan,
          jourEvenement: jourEvenement,
        )
        .then(
          (result) => result.fold(
            (error) => Left(error),
            (_) => Right(unit),
          ),
        );
  }

  @override
  Future<Either<DioException, Unit>> deleteScan(int scanId) async {
    return await _scanApiService.deleteScan(scanId).then(
          (result) => result.fold(
            (error) => Left(error),
            (_) => Right(unit),
          ),
        );
  }
}
