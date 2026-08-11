import 'package:charity_management/Payment/model/wallet_aid_request_donation_model.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:dio/dio.dart';

class WalletAidRequestDonationService {
  WalletAidRequestDonationService({Dio? dio}) : _dio = dio ?? DioClient.dio;

  final Dio _dio;

  Future<WalletAidRequestDonationModel> donate({
    required int requestId,
    required double amount,
  }) async {
    final response = await _dio.post<dynamic>(
      ApiConstants.walletDonateAidRequest(requestId),
      data: {'amount': amount.toStringAsFixed(2)},
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid wallet donation response');
    }

    return WalletAidRequestDonationModel.fromJson(data);
  }
}
