import 'package:get_it/get_it.dart';
import 'package:junetech/core/network/dio_client.dart';
import 'package:junetech/features/badge/data/data_sources/badge_api_service.dart';
import 'package:junetech/features/badge/data/repositories/badge_repository_impl.dart';
import 'package:junetech/features/badge/domain/repositories/badge_repository.dart';
import 'package:junetech/features/badge/domain/usecases/generate_badge.dart';
import 'package:junetech/features/badge/presentation/bloc/badge_cubit.dart';
import 'package:junetech/features/scan/data/data_sources/scan_api_service.dart';
import 'package:junetech/features/scan/data/repository/scan_repository_impl.dart';
import 'package:junetech/features/scan/domain/repositories/scan_repository.dart';
import 'package:junetech/features/scan/domain/usecases/delete_scan.dart';
import 'package:junetech/features/scan/domain/usecases/get_scan_summary.dart';
import 'package:junetech/features/scan/domain/usecases/record_scan.dart';
import 'package:junetech/features/scan/presentation/bloc/scan_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core
  sl.registerSingleton<DioClient>(DioClient());

  // Scan Feature
  sl.registerSingleton<ScanApiService>(ScanApiServiceImpl(sl<DioClient>()));
  sl.registerSingleton<ScanRepository>(
      ScanRepositoryImpl(sl<ScanApiService>()));
  sl.registerSingleton<GetScanSummary>(GetScanSummary());
  sl.registerSingleton<RecordScan>(RecordScan());
  sl.registerSingleton<DeleteScan>(DeleteScan());
  sl.registerSingleton<ScanCubit>(ScanCubit());

  // Badge Data sources
  sl.registerSingleton<BadgeApiService>(BadgeApiServiceImpl(sl()));

  // Badge Repositories
  sl.registerSingleton<BadgeRepository>(BadgeRepositoryImpl(sl()));

  // Badge Use cases
  sl.registerSingleton<GenerateBadge>(GenerateBadge(sl()));

  // Badge Cubit
  sl.registerSingleton<BadgeCubit>(BadgeCubit(sl()));
}
