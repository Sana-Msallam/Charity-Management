import 'package:charity_management/Payment/model/aid_request_payment_intent_model.dart';
import 'package:charity_management/Payment/model/wallet_balance_model.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:dio/dio.dart';

class WalletTopUpService {
  WalletTopUpService({Dio? dio}) : _dio = dio ?? DioClient.dio;

  final Dio _dio;

  Future<AidRequestPaymentIntentModel> createPaymentIntent({
    required double amount,
  }) async {
    final response = await _dio.post<dynamic>(
      ApiConstants.walletTopUpPaymentIntent,
      data: {'amount': amount.toStringAsFixed(2)},
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid wallet top-up response');
    }

    return AidRequestPaymentIntentModel.fromJson(data);
  }

  Future<WalletBalanceModel> fetchBalance() async {
    final response = await _dio.get<dynamic>(ApiConstants.walletBalance);

    final responseData = response.data;
    if (responseData is! Map<String, dynamic>) {
      throw const FormatException('Invalid wallet balance response');
    }

    final data = responseData['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid wallet balance response');
    }

    return WalletBalanceModel.fromJson(data);
  }
}
