import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';

abstract class BadgeRepository {
  Future<Either<DioException, Uint8List>> generateBadge(
      String registrationNumber);
}
