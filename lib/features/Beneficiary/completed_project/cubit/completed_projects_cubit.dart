import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/completed_project_model.dart';
import '../service/completed_projects_service.dart';
import 'completed_projects_state.dart';

class CompletedProjectsCubit
    extends Cubit<CompletedProjectsState> {
  CompletedProjectsCubit(
    this._service,
  ) : super(
          const CompletedProjectsInitial(),
        );

  final CompletedProjectsService _service;

  Future<void> loadCompletedProjects() async {
    if (state is CompletedProjectsLoading) {
      return;
    }

    emit(
      const CompletedProjectsLoading(),
    );

    try {
      final List<CompletedProjectModel>
          projects =
          await _service.getCompletedProjects();

      emit(
        CompletedProjectsSuccess(
          projects,
        ),
      );
    } on FormatException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'CompletedProjectsCubit FormatException: '
        '${error.message}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        CompletedProjectsFailure(
          error.message,
        ),
      );
    } on DioException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'CompletedProjectsCubit DioException: '
        '${error.message}',
      );

      debugPrint(
        'Response: ${error.response?.data}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        CompletedProjectsFailure(
          _extractDioMessage(
            error,
          ),
        ),
      );
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'CompletedProjectsCubit unexpected error: '
        '$error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      emit(
        const CompletedProjectsFailure(
          'تعذر تحميل المشاريع المنجزة',
        ),
      );
    }
  }

  String _extractDioMessage(
    DioException error,
  ) {
    final dynamic data =
        error.response?.data;

    if (data is Map) {
      final dynamic message =
          data['message'];

      if (message is String &&
          message.trim().isNotEmpty) {
        return message;
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال بالخادم';

      case DioExceptionType.connectionError:
        return 'تعذر الاتصال بالخادم';

      default:
        return 'تعذر تحميل المشاريع المنجزة';
    }
  }
}