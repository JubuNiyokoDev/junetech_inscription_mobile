import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:junetech/features/badge/data/data_sources/badge_api_service.dart';
import 'package:junetech/features/badge/domain/repositories/badge_repository.dart';
import 'dart:typed_data';

class BadgeRepositoryImpl implements BadgeRepository {
  final BadgeApiService _apiService;

  BadgeRepositoryImpl(this._apiService);

  @override
  Future<Either<DioException, Uint8List>> generateBadge(
      String registrationNumber) async {
    return await _apiService.generateBadge(registrationNumber).then(
          (result) => result.fold(
            (error) => Left(error),
            (badgeData) => Right(badgeData),
          ),
        );
  }
}
