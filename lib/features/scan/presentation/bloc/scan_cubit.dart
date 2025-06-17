import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:junetech/features/scan/domain/entities/scan_summary_entity.dart';
import 'package:junetech/features/scan/domain/usecases/delete_scan.dart';
import 'package:junetech/features/scan/domain/usecases/get_scan_summary.dart';
import 'package:junetech/features/scan/domain/usecases/record_scan.dart';
import 'package:junetech/service_locator.dart';

abstract class ScanState {}

class ScanInitial extends ScanState {}

class ScanLoading extends ScanState {}

class ScanLoaded extends ScanState {
  final ScanSummaryEntity summary;

  ScanLoaded(this.summary);
}

class ScanError extends ScanState {
  final String message;

  ScanError(this.message);
}

class ScanCubit extends Cubit<ScanState> {
  final GetScanSummary _getScanSummary;
  final RecordScan _recordScan;
  final DeleteScan _deleteScan;

  ScanCubit()
      : _getScanSummary = sl<GetScanSummary>(),
        _recordScan = sl<RecordScan>(),
        _deleteScan = sl<DeleteScan>(),
        super(ScanInitial());

  Future<void> fetchScanSummary(int jourEvenement) async {
    if (!isClosed) {
      emit(ScanLoading());
      final result = await _getScanSummary.call(param: jourEvenement);
      result.fold(
        (error) => emit(ScanError(error.message ?? "")),
        (summary) => emit(ScanLoaded(summary)),
      );
    }
  }

  Future<void> recordScan({
    required String registrationNumber,
    required String typeScan,
    required int jourEvenement,
  }) async {
    if (!isClosed) {
      final result = await _recordScan.call(
        param: RecordScanParams(
          registrationNumber: registrationNumber,
          typeScan: typeScan,
          jourEvenement: jourEvenement,
        ),
      );
      result.fold(
        (error) => emit(ScanError(error.message ?? "")),
        (_) {
          if (!isClosed) {
            fetchScanSummary(jourEvenement);
          }
        },
      );
    }
  }

  Future<void> deleteScan(int scanId, int jourEvenement) async {
    if (!isClosed) {
      emit(ScanLoading());
      final result = await _deleteScan.call(param: scanId);
      result.fold(
        (error) => emit(ScanError(error.message ?? "")),
        (_) {
          if (!isClosed) {
            fetchScanSummary(jourEvenement);
          }
        },
      );
    }
  }
}
