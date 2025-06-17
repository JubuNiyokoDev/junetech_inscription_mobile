import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:junetech/core/usecases/future_usecase.dart';
import 'package:junetech/features/scan/domain/entities/scan_summary_entity.dart';
import 'package:junetech/features/scan/domain/repositories/scan_repository.dart';
import 'package:junetech/service_locator.dart';

class GetScanSummary
    implements Usecase<Either<DioException, ScanSummaryEntity>, int> {
  @override
  Future<Either<DioException, ScanSummaryEntity>> call(
      {required int param}) async {
    return await sl<ScanRepository>().getScanSummary(param);
  }
}
