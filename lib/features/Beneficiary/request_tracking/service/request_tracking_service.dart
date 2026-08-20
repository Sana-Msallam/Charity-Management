import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../../constants/api_constants.dart';
import '../../../../../constants/dio_client.dart';
import '../model/request_details_model.dart';
import 'package:charity_management/features/Beneficiary/request_tracking/model/request_tracking_model.dart';

class RequestTrackingService {
  // =================================================
  // GET ALL MY REQUESTS
  // =================================================

  Future<List<RequestTrackingModel>> getMyRequests({
    String? status,
  }) async {
    debugPrint(
      '======================================',
    );

    debugPrint(
      'START GET MY REQUESTS',
    );

    debugPrint(
      '======================================',
    );

    try {
      final Map<String, dynamic> queryParameters =
          {};

      if (status != null &&
          status.trim().isNotEmpty) {
        queryParameters['status'] =
            status.trim().toUpperCase();
      }

      debugPrint(
        'Request URL: '
        '${ApiConstants.baseUrl}'
        '${ApiConstants.myRequests}',
      );

      debugPrint(
        'Status filter: ${status ?? 'ALL'}',
      );

      final Response<dynamic> response =
          await DioClient.dio.get<dynamic>(
        ApiConstants.myRequests,
        queryParameters:
            queryParameters,
      );

      debugPrint(
        'My requests response received',
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
        debugPrint(
          'Invalid my requests response: $data',
        );

        throw const FormatException();
      }

      final List<RequestTrackingModel>
          requests =
          data
              .whereType<Map>()
              .map(
                (item) {
                  return RequestTrackingModel
                      .fromJson(
                    Map<String, dynamic>.from(
                      item,
                    ),
                  );
                },
              )
              .toList();

      debugPrint(
        'My requests parsed successfully',
      );

      debugPrint(
        'Requests count: ${requests.length}',
      );

      for (final request in requests) {
        debugPrint(
          '--------------------------------------',
        );

        debugPrint(
          'Request id: ${request.id}',
        );

        debugPrint(
          'Category: ${request.category.name}',
        );

        debugPrint(
          'SubCategory: '
          '${request.subCategory?.name}',
        );

        debugPrint(
          'Status: ${request.status}',
        );

        debugPrint(
          'Cost: ${request.cost}',
        );

        debugPrint(
          'Current payment: '
          '${request.currentPayment}',
        );

        debugPrint(
          'TypeAid: ${request.typeAid}',
        );

        debugPrint(
          'Rejection reason: '
          '${request.rejectionReason}',
        );

        debugPrint(
          'Created at: ${request.createdAt}',
        );
      }

      debugPrint(
        '======================================',
      );

      return requests;
    } on DioException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'DIO ERROR WHILE GETTING MY REQUESTS',
      );

      debugPrint(
        'Error type: ${error.type}',
      );

      debugPrint(
        'Error message: ${error.message}',
      );

      debugPrint(
        'Status code: '
        '${error.response?.statusCode}',
      );

      debugPrint(
        'Response data: '
        '${error.response?.data}',
      );

      debugPrint(
        'Request URL: '
        '${error.requestOptions.uri}',
      );

      debugPrint(
        'Request method: '
        '${error.requestOptions.method}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      debugPrint(
        '======================================',
      );

      rethrow;
    } on FormatException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'MY REQUESTS FORMAT ERROR',
      );

      debugPrint(
        'Message: ${error.message}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      debugPrint(
        '======================================',
      );

      rethrow;
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'UNEXPECTED MY REQUESTS ERROR',
      );

      debugPrint(
        'Error: $error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      debugPrint(
        '======================================',
      );

      rethrow;
    }
  }

  // =================================================
  // GET ONE REQUEST DETAILS
  // =================================================

  Future<RequestDetailsModel>
      getRequestDetails({
    required int requestId,
  }) async {
    debugPrint(
      '======================================',
    );

    debugPrint(
      'START GET REQUEST DETAILS',
    );

    debugPrint(
      'Request id: $requestId',
    );

    debugPrint(
      '======================================',
    );

    try {
      final String endpoint =
          '/requests/$requestId';

      debugPrint(
        'Request URL: '
        '${ApiConstants.baseUrl}$endpoint',
      );

      // ==========================================
      // GET ARABIC VERSION
      // ==========================================

      debugPrint(
        'Getting Arabic request details...',
      );

      final Response<dynamic>
          arabicResponse =
          await DioClient.dio.get<dynamic>(
        endpoint,
        options: Options(
          headers: {
            'accept-language': 'ar',
          },
        ),
      );

      debugPrint(
        'Arabic response status: '
        '${arabicResponse.statusCode}',
      );

      debugPrint(
        'Arabic response data: '
        '${arabicResponse.data}',
      );

      // ==========================================
      // GET ENGLISH VERSION
      // ==========================================

      debugPrint(
        'Getting English request details...',
      );

      final Response<dynamic>
          englishResponse =
          await DioClient.dio.get<dynamic>(
        endpoint,
        options: Options(
          headers: {
            'accept-language': 'en',
          },
        ),
      );

      debugPrint(
        'English response status: '
        '${englishResponse.statusCode}',
      );

      debugPrint(
        'English response data: '
        '${englishResponse.data}',
      );

      // ==========================================
      // VALIDATE RESPONSES
      // ==========================================

      final dynamic arabicData =
          arabicResponse.data;

      final dynamic englishData =
          englishResponse.data;

      if (arabicData is! Map) {
        throw const FormatException();
      }

      if (englishData is! Map) {
        throw const FormatException();
      }

      // ==========================================
      // MERGE AR + EN
      // ==========================================

      final RequestDetailsModel request =
          RequestDetailsModel
              .fromLocalizedJson(
        arabicJson:
            Map<String, dynamic>.from(
          arabicData,
        ),
        englishJson:
            Map<String, dynamic>.from(
          englishData,
        ),
      );

      // ==========================================
      // PRINT MERGED RESULT
      // ==========================================

      debugPrint(
        '======================================',
      );

      debugPrint(
        'REQUEST DETAILS MERGED SUCCESSFULLY',
      );

      debugPrint(
        'Request id: ${request.id}',
      );

      debugPrint(
        'Category: ${request.category.name}',
      );

      debugPrint(
        'SubCategory: '
        '${request.subCategory?.name}',
      );

      debugPrint(
        'Status: ${request.status}',
      );

      debugPrint(
        'First name: ${request.firstName}',
      );

      debugPrint(
        'Father name: '
        '${request.beneficiaryFatherName}',
      );

      debugPrint(
        'Last name: ${request.lastName}',
      );

      debugPrint(
        'Age: ${request.age}',
      );

      debugPrint(
        'Gender: ${request.gender}',
      );

      debugPrint(
        'Social status: '
        '${request.socialStatus}',
      );

      debugPrint(
        'Is unemployed: '
        '${request.isUnemployed}',
      );

      debugPrint(
        'Phone number: ${request.number}',
      );

      debugPrint(
        'Address AR: ${request.addressAr}',
      );

      debugPrint(
        'Address EN: ${request.addressEn}',
      );

      debugPrint(
        'Title: ${request.title}',
      );

      debugPrint(
        'Details AR: ${request.detailsAr}',
      );

      debugPrint(
        'Details EN: ${request.detailsEn}',
      );

      debugPrint(
        'Description AR: '
        '${request.descriptionAr}',
      );

      debugPrint(
        'Description EN: '
        '${request.descriptionEn}',
      );

      debugPrint(
        'Cost: ${request.cost}',
      );

      debugPrint(
        'Current payment: '
        '${request.currentPayment}',
      );

      debugPrint(
        'Aid details AR: '
        '${request.aidDetailsAr}',
      );

      debugPrint(
        'Aid details EN: '
        '${request.aidDetailsEn}',
      );

      debugPrint(
        '======================================',
      );

      return request;
    } on DioException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'DIO ERROR WHILE GETTING REQUEST DETAILS',
      );

      debugPrint(
        'Request id: $requestId',
      );

      debugPrint(
        'Error type: ${error.type}',
      );

      debugPrint(
        'Error message: ${error.message}',
      );

      debugPrint(
        'Status code: '
        '${error.response?.statusCode}',
      );

      debugPrint(
        'Response data: '
        '${error.response?.data}',
      );

      debugPrint(
        'Request URL: '
        '${error.requestOptions.uri}',
      );

      debugPrint(
        'Request method: '
        '${error.requestOptions.method}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      debugPrint(
        '======================================',
      );

      rethrow;
    } on FormatException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'REQUEST DETAILS FORMAT ERROR',
      );

      debugPrint(
        'Request id: $requestId',
      );

      debugPrint(
        'Message: ${error.message}',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      debugPrint(
        '======================================',
      );

      rethrow;
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'UNEXPECTED REQUEST DETAILS ERROR',
      );

      debugPrint(
        'Request id: $requestId',
      );

      debugPrint(
        'Error: $error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      debugPrint(
        '======================================',
      );

      rethrow;
    }
  }
}