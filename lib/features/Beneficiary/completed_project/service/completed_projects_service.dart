import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../../constants/api_constants.dart';
import '../../../../../constants/dio_client.dart';
import '../model/completed_project_model.dart';

class CompletedProjectsService {
  Future<List<CompletedProjectModel>>
      getCompletedProjects() async {
    debugPrint('======================================');
    debugPrint('START GET COMPLETED PROJECTS');
    debugPrint('======================================');

    try {
      final Response<dynamic> response =
          await DioClient.dio.get<dynamic>(
        ApiConstants.completedAidRequests,
      );

      debugPrint(
        'Completed projects response received',
      );

      debugPrint(
        'Status code: ${response.statusCode}',
      );

      debugPrint(
        'Response data: ${response.data}',
      );

      final dynamic data =
          response.data;

      if (data is! List) {
        throw const FormatException(
          'استجابة المشاريع المنجزة غير صالحة',
        );
      }

      final List<CompletedProjectModel>
          projects = data
              .whereType<Map>()
              .map(
                (
                  Map<dynamic, dynamic>
                      item,
                ) {
                  return CompletedProjectModel
                      .fromJson(
                    Map<String, dynamic>.from(
                      item,
                    ),
                  );
                },
              )
              .toList();

      debugPrint(
        'Completed projects count: ${projects.length}',
      );

      for (final project in projects) {
        debugPrint(
          'Project #${project.id} - '
          '${project.category.name} - '
          '${project.displayTitle}',
        );
      }

      debugPrint('======================================');

      return projects;
    } on DioException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'DIO ERROR WHILE GETTING COMPLETED PROJECTS',
      );

      debugPrint(
        'Type: ${error.type}',
      );

      debugPrint(
        'Message: ${error.message}',
      );

      debugPrint(
        'Status code: ${error.response?.statusCode}',
      );

      debugPrint(
        'Response data: ${error.response?.data}',
      );

      debugPrint(
        'URL: ${error.requestOptions.uri}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      debugPrint('======================================');

      rethrow;
    }
  }
}