import 'package:charity_management/Donor/model/quick_donation_fund_payment_intent_model.dart';
import 'package:charity_management/Donor/model/quick_donation_fund_wallet_donation_model.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:dio/dio.dart';

class QuickDonationFundService {
  QuickDonationFundService({Dio? dio}) : _dio = dio ?? DioClient.dio;

  final Dio _dio;

  Future<QuickDonationFundPaymentIntentModel> createPaymentIntent({
    required double amount,
  }) async {
    final response = await _dio.post<dynamic>(
      ApiConstants.quickDonationFundPaymentIntent,
      data: {'amount': amount},
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid quick donation fund payment intent response',
      );
    }

    return QuickDonationFundPaymentIntentModel.fromJson(data);
  }

  Future<QuickDonationFundWalletDonationModel> donateFromWallet({
    required double amount,
  }) async {
    final response = await _dio.post<dynamic>(
      ApiConstants.quickDonationFundWallet,
      data: {'amount': amount.toStringAsFixed(2)},
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid quick donation fund wallet response',
      );
    }

    return QuickDonationFundWalletDonationModel.fromJson(data);
  }
}
