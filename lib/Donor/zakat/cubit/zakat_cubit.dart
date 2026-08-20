import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/zakat_type.dart';
import '../service/zakat_service.dart';
import 'zakat_state.dart';

class ZakatCubit
    extends Cubit<ZakatState> {
  ZakatCubit(
    this._zakatService,
  ) : super(
          const ZakatInitial(),
        );

  final ZakatService
      _zakatService;

  Future<void> calculate({
    required ZakatType type,
    required double amount,
    required double gramPrice,
    required AppLocalizations localizations,
  }) async {
    if (state is ZakatLoading) {
      return;
    }

    emit(
      const ZakatLoading(),
    );

    try {
      final result =
          await _zakatService
              .calculateZakat(
        type: type,
        amount: amount,
        gramPrice: gramPrice,
      );

      emit(
        ZakatSuccess(
          result: result,
        ),
      );
    } on FormatException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'ZakatCubit FormatException: '
        '${error.message}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        ZakatFailure(
          message:
              localizations.unexpectedError,
        ),
      );
    } on DioException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'ZakatCubit DioException: '
        '${error.message}',
      );

      debugPrint(
        'Response: '
        '${error.response?.data}',
      );

      debugPrint(
        'Status code: '
        '${error.response?.statusCode}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        ZakatFailure(
          message:
              _extractDioMessage(
            error,
            localizations:
                localizations,
          ),
        ),
      );
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'ZakatCubit unexpected error: '
        '$error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        ZakatFailure(
          message:
              localizations.unexpectedError,
        ),
      );
    }
  }

  String _extractDioMessage(
    DioException error, {
    required AppLocalizations localizations,
  }) {
    final dynamic data =
        error.response?.data;

    if (data is Map) {
      final dynamic message =
          data['message'];

      if (message is String &&
          message
              .trim()
              .isNotEmpty) {
        return message;
      }

      if (message is List &&
          message.isNotEmpty) {
        return message.join(
          '\n',
        );
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return localizations
            .connectionTimeout;

      case DioExceptionType.connectionError:
        return localizations
            .connectionError;

      default:
        break;
    }

    switch (
        error.response?.statusCode) {
      case 400:
        return localizations
            .badRequest;

      case 401:
        return localizations
            .unauthorized;

      case 403:
        return localizations
            .forbidden;

      case 404:
        return localizations
            .notFound;

      case 500:
        return localizations
            .serverError;

      default:
        return localizations
            .unexpectedError;
    }
  }

  void reset() {
    emit(
      const ZakatInitial(),
    );
  }
}