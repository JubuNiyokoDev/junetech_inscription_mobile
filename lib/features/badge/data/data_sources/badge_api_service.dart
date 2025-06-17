import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:junetech/core/constants/api_urls.dart';
import 'package:junetech/core/network/dio_client.dart';
import 'dart:typed_data';

abstract class BadgeApiService {
  Future<Either<DioException, Uint8List>> generateBadge(
      String registrationNumber);
}

class BadgeApiServiceImpl implements BadgeApiService {
  final DioClient _dioClient;

  BadgeApiServiceImpl(this._dioClient);

  @override
  Future<Either<DioException, Uint8List>> generateBadge(
      String registrationNumber) async {
    try {
      final response = await _dioClient.get(
        '${ApiUrls.badgeGenerateUrl}$registrationNumber/badge/',
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        return Right(Uint8List.fromList(response.data));
      }
      return Left(DioException(
        requestOptions: RequestOptions(
            path: '${ApiUrls.badgeGenerateUrl}$registrationNumber/badge/'),
        response: response,
        type: DioExceptionType.badResponse,
        message: _extractErrorMessage(response),
      ));
    } on DioException catch (e) {
      return Left(_handleError(e));
    }
  }

  String _extractErrorMessage(Response response) {
    if (response.statusCode == 404) {
      return 'Numéro d\'inscription introuvable ou non validé';
    }
    if (response.statusCode == 500) {
      return 'Erreur serveur : impossible de générer le badge';
    }
    if (response.data is Map<String, dynamic>) {
      final errorData = response.data as Map<String, dynamic>;
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
    String errorMessage;
    if (e.type == DioExceptionType.connectionTimeout) {
      errorMessage = 'Délai de connexion dépassé. Vérifiez votre connexion.';
    } else if (e.type == DioExceptionType.receiveTimeout) {
      errorMessage = 'Délai de réception dépassé. Essayez à nouveau.';
    } else if (e.type == DioExceptionType.connectionError) {
      errorMessage = 'Erreur de connexion. Vérifiez votre réseau.';
    } else {
      errorMessage = e.message ?? 'Erreur réseau inconnue';
    }
    return DioException(
      requestOptions: e.requestOptions,
      type: e.type,
      message: errorMessage,
    );
  }
}
