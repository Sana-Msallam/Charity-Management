class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://192.168.1.13:3000';

  static const String login = '/auth/login/client';

  static const String registerDonor = '/auth/register/donor';
  static const String registerBeneficiary = '/auth/register/beneficiary';
  static const String verifyOtp = '/auth/register/verify-otp';
  static const String requestPasswordResetOtp =
      '/auth/forgot-password/request-otp';

  static const String resetPassword = '/auth/forgot-password/reset';

  static const String healthRequest = '/requests/health';
  static const String educationRequest = '/requests/education';
  static const String housingRequest = '/requests/housing';
  static const String foodRequest = '/requests/food';
  static const String smallProjectRequest = '/requests/small-projects';

  static const String profile = '/api/profile';

  static const String aidRequests = '/donor/public/aid-requests';

  static String aidRequestPaymentIntent(int requestId) =>
      '/payments/aid-requests/$requestId/payment-intent';

  static const String completedAidRequests =
      '/donor/public/aid-requests/completed';

  static const String sponsorships = '/sponsorships';
  static const String cancelSponsorship = '/sponsorships';
  static const String completedAidCases =
      '/public/statistics/completed-aid-cases';
  static const String logout = '/auth/logout';
}
