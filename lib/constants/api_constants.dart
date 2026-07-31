class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://192.168.1.6:3000';

  static const String login = '/auth/login/client';

  static const String registerDonor = '/auth/register/donor';
  static const String registerBeneficiary = '/auth/register/beneficiary';
  static const String verifyOtp = '/auth/register/verify-otp';
  static const String requestPasswordResetOtp =
    '/auth/forgot-password/request-otp';

static const String resetPassword =
    '/auth/forgot-password/reset';

  static const String healthRequest = '/requests/health';

  static const String profile = '/api/profile';

  static const String aidRequests = '/donor/public/aid-requests';
}
