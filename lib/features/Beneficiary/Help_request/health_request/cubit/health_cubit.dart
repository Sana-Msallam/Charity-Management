import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants/api_exception.dart';
import '../model/health_request_model.dart';
import '../service/health_request_service.dart';
import 'health_state.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';

class HealthCubit extends Cubit<HealthState> {
  HealthCubit(this._healthRequestService) : super(const HealthInitial()) {
    debugPrint('HealthCubit created with HealthInitial state');
  }

  final HealthRequestService _healthRequestService;

  Future<void> submitHealthRequest(
    HealthRequestModel request,
    AppLocalizations localizations,
  ) async {
    debugPrint('======================================');
    debugPrint('HealthCubit.submitHealthRequest called');

    debugPrint('Current state: ${state.runtimeType}');

    if (state is HealthLoading) {
      debugPrint('Duplicate health request submission ignored');

      debugPrint('======================================');
      return;
    }

    debugPrint('HealthCubit request information:');

    debugPrint(
      'Applicant first name: '
      '${request.applicantInfo.firstName}',
    );

    debugPrint(
      'Applicant father name: '
      '${request.applicantInfo.fatherName}',
    );

    debugPrint(
      'Applicant last name: '
      '${request.applicantInfo.lastName}',
    );

    debugPrint(
      'Applicant age: '
      '${request.applicantInfo.age}',
    );

    debugPrint(
      'Applicant gender: '
      '${request.applicantInfo.gender}',
    );

    debugPrint(
      'Applicant social status: '
      '${request.applicantInfo.socialStatus}',
    );

    debugPrint(
      'Applicant is unemployed: '
      '${request.applicantInfo.isUnemployed}',
    );

    debugPrint(
      'Applicant phone number: '
      '${request.applicantInfo.phoneNumber}',
    );

    debugPrint(
      'Applicant address AR: '
      '${request.applicantInfo.addressAr}',
    );

    debugPrint(
      'Applicant address EN: '
      '${request.applicantInfo.addressEn}',
    );

    debugPrint(
      'Health aid type: '
      '${request.typeAid.apiValue}',
    );

    debugPrint(
      'Arabic details length: '
      '${request.detailsAr.length}',
    );

    debugPrint(
      'English details length: '
      '${request.detailsEn.length}',
    );

    debugPrint('Cost: ${request.cost}');

    debugPrint('Media count: ${request.media.length}');

    for (final file in request.media) {
      debugPrint('Media file name: ${file.name}');

      debugPrint('Media file path: ${file.path}');

      debugPrint('Media file size: ${file.size}');

      debugPrint(
        'Media bytes available: '
        '${file.bytes != null}',
      );
    }

    debugPrint('HealthCubit: emitting HealthLoading');

    emit(const HealthLoading());

    try {
      debugPrint('HealthCubit: calling HealthRequestService');

      final String message = await _healthRequestService.submitHealthRequest(
        request,
      );

      debugPrint('HealthCubit: service completed successfully');

      debugPrint('Success message: $message');

      debugPrint('HealthCubit: emitting HealthSuccess');

      emit(HealthSuccess(message));

      debugPrint('======================================');
    } on DioException catch (error, stackTrace) {
      debugPrint('HealthCubit caught DioException');

      debugPrint('Dio error type: ${error.type}');

      debugPrint('Dio error message: ${error.message}');

      debugPrint('Status code: ${error.response?.statusCode}');

      debugPrint('Response data: ${error.response?.data}');

      debugPrint('Request URL: ${error.requestOptions.uri}');

      debugPrint('Stack trace: $stackTrace');

      final String message = ApiException.getMessage(error, localizations);

      debugPrint('Converted Arabic error message: $message');

      debugPrint('HealthCubit: emitting HealthFailure');

      emit(HealthFailure(message));

      debugPrint('======================================');
    } on FormatException catch (error, stackTrace) {
      debugPrint('HealthCubit caught FormatException');

      debugPrint('FormatException message: ${error.message}');

      debugPrint('Stack trace: $stackTrace');

      debugPrint('HealthCubit: emitting HealthFailure');

      emit(HealthFailure(error.message));

      debugPrint('======================================');
    } catch (error, stackTrace) {
      debugPrint('HealthCubit caught unexpected exception');

      debugPrint('Runtime type: ${error.runtimeType}');

      debugPrint('Error: $error');

      debugPrint('Stack trace: $stackTrace');

      debugPrint('HealthCubit: emitting HealthFailure');

      emit(const HealthFailure('حدث خطأ غير متوقع، يرجى المحاولة مجدداً'));

      debugPrint('======================================');
    }
  }

  Future<void> updateHealthRequest({
    required int requestId,
    required HealthRequestModel request,
    required AppLocalizations localizations,
  }) async {
    if (state is HealthLoading) {
      debugPrint('Duplicate health request update ignored');
      return;
    }

    debugPrint('======================================');
    debugPrint('HealthCubit.updateHealthRequest called');
    debugPrint('Request id: $requestId');

    emit(const HealthLoading());

    try {
      final String message = await _healthRequestService.updateHealthRequest(
        requestId: requestId,
        request: request,
      );

      debugPrint('HealthCubit update success: $message');
      emit(HealthSuccess(message));
    } on DioException catch (error, stackTrace) {
      debugPrint('HealthCubit update DioException');
      debugPrint('Dio error type: ${error.type}');
      debugPrint('Dio error message: ${error.message}');
      debugPrint('Status code: ${error.response?.statusCode}');
      debugPrint('Response data: ${error.response?.data}');
      debugPrint('Request URL: ${error.requestOptions.uri}');
      debugPrint('Stack trace: $stackTrace');

      emit(HealthFailure(ApiException.getMessage(error, localizations)));
    } on FormatException catch (error, stackTrace) {
      debugPrint('HealthCubit update FormatException');
      debugPrint('FormatException message: ${error.message}');
      debugPrint('Stack trace: $stackTrace');

      emit(HealthFailure(error.message));
    } catch (error, stackTrace) {
      debugPrint('HealthCubit update unexpected exception');
      debugPrint('Error: $error');
      debugPrint('Stack trace: $stackTrace');

      emit(HealthFailure(localizations.unexpectedError));
    }

    debugPrint('======================================');
  }

  void reset() {
    debugPrint('HealthCubit reset to HealthInitial');

    emit(const HealthInitial());
  }

  @override
  Future<void> close() {
    debugPrint('HealthCubit closed');

    return super.close();
  }
}
