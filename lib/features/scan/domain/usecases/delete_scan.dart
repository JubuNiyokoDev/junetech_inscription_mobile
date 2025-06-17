import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:junetech/core/usecases/future_usecase.dart';
import 'package:junetech/features/scan/domain/repositories/scan_repository.dart';
import 'package:junetech/service_locator.dart';

class DeleteScan implements Usecase<Either<DioException, Unit>, int> {
  @override
  Future<Either<DioException, Unit>> call({required int param}) async {
    return await sl<ScanRepository>().deleteScan(param);
  }
}
