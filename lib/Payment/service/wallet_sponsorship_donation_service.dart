import 'package:charity_management/Payment/model/wallet_sponsorship_donation_model.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/constants/dio_client.dart';
import 'package:dio/dio.dart';

class WalletSponsorshipDonationService {
  WalletSponsorshipDonationService({Dio? dio}) : _dio = dio ?? DioClient.dio;

  final Dio _dio;

  Future<WalletSponsorshipDonationModel> donate({
    required int sponsorshipId,
  }) async {
    final response = await _dio.post<dynamic>(
      ApiConstants.walletDonateSponsorship(sponsorshipId),
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException(
        'Invalid wallet sponsorship donation response',
      );
    }

    return WalletSponsorshipDonationModel.fromJson(data);
  }
}
