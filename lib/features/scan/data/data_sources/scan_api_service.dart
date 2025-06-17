import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:junetech/core/constants/api_urls.dart';
import 'package:junetech/core/network/dio_client.dart';
import 'package:junetech/features/scan/data/models/scan_summary_model.dart';

abstract class ScanApiService {
  Future<Either<DioException, ScanSummaryModel>> getScanSummary(
      int jourEvenement);
  Future<Either<DioException, Response>> recordScan({
    required String registrationNumber,
    required String typeScan,
    required int jourEvenement,
  });
  Future<Either<DioException, Response>> deleteScan(int scanId);
}

class ScanApiServiceImpl implements ScanApiService {
  final DioClient _dioClient;

  ScanApiServiceImpl(this._dioClient);

  @override
  Future<Either<DioException, ScanSummaryModel>> getScanSummary(
      int jourEvenement) async {
    try {
      final response = await _dioClient.get(
        ApiUrls.scanSummaryUrl,
        queryParameters: {'jour_evenement': jourEvenement},
      );
      if (response.statusCode == 200) {
        return Right(ScanSummaryModel.fromJson(response.data));
      }
      print(response);
      return Left(DioException(
        requestOptions: RequestOptions(path: ApiUrls.scanSummaryUrl),
        response: response,
        type: DioExceptionType.badResponse,
        message: _extractErrorMessage(response),
      ));
    } on DioException catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<DioException, Response>> recordScan({
    required String registrationNumber,
    required String typeScan,
    required int jourEvenement,
  }) async {
    try {
      final data = {
        'registration': registrationNumber,
        'type_scan': typeScan,
      };
      print('Envoi POST /api/scans/ : $data');
      final response = await _dioClient.post(
        ApiUrls.scanCreateUrl,
        data: data,
      );
      if (response.statusCode == 201) {
        return Right(response);
      }
      return Left(DioException(
        requestOptions: RequestOptions(path: ApiUrls.scanCreateUrl),
        response: response,
        type: DioExceptionType.badResponse,
        message: _extractErrorMessage(response),
      ));
    } on DioException catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<DioException, Response>> deleteScan(int scanId) async {
    try {
      final response = await _dioClient.delete(
        '${ApiUrls.scanCreateUrl}$scanId/',
      );
      if (response.statusCode == 200) {
        return Right(response);
      }
      return Left(DioException(
        requestOptions:
            RequestOptions(path: '${ApiUrls.scanCreateUrl}$scanId/'),
        response: response,
        type: DioExceptionType.badResponse,
        message: _extractErrorMessage(response),
      ));
    } on DioException catch (e) {
      return Left(_handleError(e));
    }
  }

  String _extractErrorMessage(Response response) {
    if (response.statusCode == 500) {
      return 'Erreur serveur : impossible d\'effectuer l\'opération';
    }
    if (response.data is Map<String, dynamic>) {
      final errorData = response.data as Map<String, dynamic>;
      if (errorData.containsKey('registration')) {
        final error = errorData['registration'] is List
            ? errorData['registration'][0].toString()
            : errorData['registration'].toString();
        if (error.contains('Invalid pk') || error.contains('does not exist')) {
          return 'Aucun visiteur trouvé avec ce numéro d\'enregistrement';
        }
        return error;
      }
      if (errorData.containsKey('non_field_errors')) {
        final error = errorData['non_field_errors'] is List
            ? errorData['non_field_errors'][0].toString()
            : errorData['non_field_errors'].toString();
        if (error.contains('Ce visiteur a déjà un scan')) {
          final typeScan = errorData['type_scan']?.toString() ?? 'ce type';
          return 'Ce visiteur a déjà été scanné en $typeScan aujourd\'hui';
        }
        return error;
      }
      if (errorData.containsKey('detail')) {
        return errorData['detail'].toString();
      }
      if (errorData.containsKey('error')) {
        return errorData['error'].toString();
      }
      if (errorData.containsKey('message')) {
        return errorData['message'].toString();
      }
    }
    return 'Erreur serveur ${response.statusCode}';
  }

  DioException _handleError(DioException e) {
    if (e.response != null) {
      return DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        type: e.type,
        message: _extractErrorMessage(e.response!),
      );
    }
    return DioException(
      requestOptions: e.requestOptions,
      type: e.type,
      message: 'Erreur réseau inconnue',
    );
  }
}
