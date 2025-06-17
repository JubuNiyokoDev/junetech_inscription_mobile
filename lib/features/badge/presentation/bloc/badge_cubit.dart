import 'package:bloc/bloc.dart';
import 'package:junetech/features/badge/domain/usecases/generate_badge.dart';
import 'dart:typed_data';

abstract class BadgeState {}

class BadgeInitial extends BadgeState {}

class BadgeLoading extends BadgeState {}

class BadgeSuccess extends BadgeState {
  final Uint8List badgeImage;

  BadgeSuccess(this.badgeImage);
}

class BadgeError extends BadgeState {
  final String message;

  BadgeError(this.message);
}

class BadgeCubit extends Cubit<BadgeState> {
  final GenerateBadge _generateBadge;

  BadgeCubit(this._generateBadge) : super(BadgeInitial());

  Future<void> generateBadge(String registrationNumber) async {
    if (registrationNumber.trim().isEmpty) {
      emit(BadgeError('Veuillez entrer un numéro d\'inscription'));
      return;
    }

    emit(BadgeLoading());
    final result = await _generateBadge.call(param: registrationNumber);
    result.fold(
      (failure) => emit(BadgeError(failure.message ?? 'Erreur inconnue')),
      (badgeImage) => emit(BadgeSuccess(badgeImage)),
    );
  }
}
