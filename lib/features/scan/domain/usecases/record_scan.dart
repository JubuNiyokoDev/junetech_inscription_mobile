import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:junetech/core/usecases/future_usecase.dart';
import 'package:junetech/features/scan/domain/repositories/scan_repository.dart';
import 'package:junetech/service_locator.dart';

class RecordScan
    implements Usecase<Either<DioException, Unit>, RecordScanParams> {
  @override
  Future<Either<DioException, Unit>> call(
      {required RecordScanParams param}) async {
    return await sl<ScanRepository>().recordScan(
      registrationNumber: param.registrationNumber,
      typeScan: param.typeScan,
      jourEvenement: param.jourEvenement,
    );
  }
}

class RecordScanParams {
  final String registrationNumber;
  final String typeScan;
  final int jourEvenement;

  RecordScanParams({
    required this.registrationNumber,
    required this.typeScan,
    required this.jourEvenement,
  });
}
