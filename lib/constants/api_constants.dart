class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://register-length-assembly-noted.trycloudflare.com';
  // static const String baseUrl ="http://192.168.1.13:3000";

  static const String login = '/auth/login/client';

  static const String registerDonor = '/auth/register/donor';
  static const String registerBeneficiary = '/auth/register/beneficiary';
  static const String verifyOtp = '/auth/register/verify-otp';
  static const String requestPasswordResetOtp =
      '/auth/forgot-password/request-otp';

  static const String resetPassword = '/auth/forgot-password/reset';

  static const String healthRequest = '/requests/health';

  static const String profile = '/api/profile';

  static const String aidRequests = '/donor/public/aid-requests';

  static const String walletTopUpPaymentIntent =
      '/wallet/top-up/payment-intent';

  static const String walletBalance = '/wallet/balance';

  static String aidRequestPaymentIntent(int requestId) =>
      '/payments/aid-requests/$requestId/payment-intent';

  static String walletDonateAidRequest(int requestId) =>
      '/wallet/donate/aid-requests/$requestId';

  static const String orphanSupportFundPaymentIntent =
      '/api/donor/sponsorship-fund/payment-intent';

  static const String orphanSupportFundWallet =
      '/api/donor/sponsorship-fund/wallet';
}
