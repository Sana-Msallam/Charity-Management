import 'package:charity_management/Payment/model/aid_request_payment_intent_model.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:dio/dio.dart';

class AidRequestPaymentService {
  AidRequestPaymentService({Dio? dio}) : _dio = dio ?? DioClient.dio;

  final Dio _dio;

  Future<AidRequestPaymentIntentModel> createPaymentIntent({
    required int requestId,
    required double amount,
  }) async {
    final response = await _dio.post<dynamic>(
      ApiConstants.aidRequestPaymentIntent(requestId),
      data: {'amount': amount},
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid payment intent response');
    }

    return AidRequestPaymentIntentModel.fromJson(data);
  }
}
