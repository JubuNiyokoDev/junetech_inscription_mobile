import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:junetech/core/usecases/future_usecase.dart';
import 'package:junetech/features/badge/domain/repositories/badge_repository.dart';
import 'dart:typed_data';

class GenerateBadge
    implements Usecase<Either<DioException, Uint8List>, String> {
  final BadgeRepository _repository;

  GenerateBadge(this._repository);

  @override
  Future<Either<DioException, Uint8List>> call({required String param}) async {
    return await _repository.generateBadge(param);
  }
}
