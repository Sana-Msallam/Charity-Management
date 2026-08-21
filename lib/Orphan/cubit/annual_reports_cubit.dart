import 'package:charity_management/Orphan/cubit/annual_reports_state.dart';
import 'package:charity_management/Orphan/repository/annual_reports_repository.dart';
import 'package:charity_management/constants/api_exception.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnualReportsCubit extends Cubit<AnnualReportsState> {
  AnnualReportsCubit({AnnualReportsRepository? repository})
    : _repository = repository ?? AnnualReportsRepository(),
      super(const AnnualReportsInitial());

  final AnnualReportsRepository _repository;

  Future<void> loadAnnualReports({
    required int sponsorshipId,
    required AppLocalizations localizations,
  }) async {
    if (state is AnnualReportsLoading) {
      return;
    }

    emit(const AnnualReportsLoading());

    try {
      final reports = await _repository.getAnnualReports(
        sponsorshipId: sponsorshipId,
      );

      reports.sort((first, second) {
        final yearComparison = second.reportYear.compareTo(first.reportYear);
        if (yearComparison != 0) {
          return yearComparison;
        }

        return second.reportNumber.compareTo(first.reportNumber);
      });

      if (reports.isEmpty) {
        emit(const AnnualReportsEmpty());
        return;
      }

      emit(AnnualReportsSuccess(reports));
    } on DioException catch (error) {
      debugPrint('Annual reports DioException:');
      debugPrint('  type: ${error.type}');
      debugPrint('  statusCode: ${error.response?.statusCode}');
      debugPrint('  response: ${error.response?.data}');
      debugPrint('  uri: ${error.requestOptions.uri}');
      emit(AnnualReportsFailure(ApiException.getMessage(error, localizations)));
    } on FormatException catch (error) {
      debugPrint('Annual reports invalid response: ${error.message}');
      emit(AnnualReportsFailure(localizations.invalidServerResponse));
    } catch (error, stackTrace) {
      debugPrint('Annual reports unexpected error: $error');
      debugPrint('Annual reports stack trace: $stackTrace');
      emit(AnnualReportsFailure(localizations.unexpectedError));
    }
  }
}
