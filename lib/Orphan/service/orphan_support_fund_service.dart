import 'package:charity_management/Orphan/model/orphan_support_fund_payment_intent_model.dart';
import 'package:charity_management/Orphan/model/orphan_support_fund_wallet_donation_model.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:dio/dio.dart';

class OrphanSupportFundService {
  OrphanSupportFundService({Dio? dio}) : _dio = dio ?? DioClient.dio;

  final Dio _dio;

  Future<OrphanSupportFundPaymentIntentModel> createPaymentIntent({
    required double amount,
  }) async {
    final response = await _dio.post<dynamic>(
      ApiConstants.orphanSupportFundPaymentIntent,
      data: {'amount': amount},
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid orphan support fund payment intent response',
      );
    }

    return OrphanSupportFundPaymentIntentModel.fromJson(data);
  }

  Future<OrphanSupportFundWalletDonationModel> donateFromWallet({
    required double amount,
  }) async {
    final response = await _dio.post<dynamic>(
      ApiConstants.orphanSupportFundWallet,
      data: {'amount': amount.toStringAsFixed(2)},
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid orphan support fund wallet response',
      );
    }

    return OrphanSupportFundWalletDonationModel.fromJson(data);
  }
}
