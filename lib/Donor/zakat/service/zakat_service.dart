import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../constants/api_constants.dart';
import '../../../constants/dio_client.dart';
import '../model/zakat_result_model.dart';
import '../model/zakat_type.dart';

class ZakatService {
  Future<ZakatResultModel> calculateZakat({
    required ZakatType type,
    required double amount,
    required double gramPrice,
  }) async {
    debugPrint(
      '======================================',
    );

    debugPrint(
      'START CALCULATE ZAKAT',
    );

    debugPrint(
      'Type: ${type.apiValue}',
    );

    debugPrint(
      'Amount: $amount',
    );

    debugPrint(
      'Gram price: $gramPrice',
    );

    debugPrint(
      '======================================',
    );

    try {
      final Response<dynamic> response =
          await DioClient.dio.post<dynamic>(
        ApiConstants.zakatCalculate,
        queryParameters:
            <String, dynamic>{
          'type':
              type.apiValue,
        },
        data:
            <String, dynamic>{
          'amount':
              amount.toStringAsFixed(
            2,
          ),
          'gramPrice':
              gramPrice.toStringAsFixed(
            2,
          ),
        },
      );

      debugPrint(
        'Zakat response status: '
        '${response.statusCode}',
      );

      debugPrint(
        'Zakat response data: '
        '${response.data}',
      );

      final dynamic data =
          response.data;

      if (data is! Map) {
        throw const FormatException();
      }

      final ZakatResultModel result =
          ZakatResultModel.fromJson(
        Map<String, dynamic>.from(
          data,
        ),
      );

      debugPrint(
        'Zakat parsed successfully',
      );

      debugPrint(
        'Eligible: ${result.eligible}',
      );

      debugPrint(
        'Zakat due: ${result.zakatDue}',
      );

      debugPrint(
        '======================================',
      );

      return result;
    } on DioException catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'DIO ERROR WHILE CALCULATING ZAKAT',
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
        'ZAKAT FORMAT ERROR',
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
        'UNEXPECTED ZAKAT ERROR',
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