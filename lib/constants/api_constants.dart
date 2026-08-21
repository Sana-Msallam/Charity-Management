class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://buying-trained-ratios-hoping.trycloudflare.com';
  // static const String baseUrl = 'http://192.168.1.13:3000';

  static const String login = '/auth/login/client';

  static const String registerDonor = '/auth/register/donor';
  static const String registerBeneficiary = '/auth/register/beneficiary';
  static const String verifyOtp = '/auth/register/verify-otp';
  static const String requestPasswordResetOtp =
      '/auth/forgot-password/request-otp';
  static const String notificationRegistration = '/notifications/registration';
  static const String notifications = '/notifications';
  static const String unreadNotificationsCount = '/notifications/unread-count';
  static const String readAllNotifications = '/notifications/read-all';
  static String readNotification(int id) => '/notifications/$id/read';

  static const String resetPassword = '/auth/forgot-password/reset';

  static const String healthRequest = '/requests/health';
  static const String educationRequest = '/requests/education';
  static const String housingRequest = '/requests/housing';
  static const String foodRequest = '/requests/food';
  static const String smallProjectRequest = '/requests/small-projects';

  static const String profile = '/api/profile';

  static const String aidRequests = '/donor/public/aid-requests';

  static const String walletTopUpPaymentIntent =
      '/wallet/top-up/payment-intent';

  static const String walletBalance = '/wallet/balance';

  static String aidRequestPaymentIntent(int requestId) =>
      '/payments/aid-requests/$requestId/payment-intent';

  static const String completedAidRequests =
      '/donor/public/aid-requests/completed';

  static const String sponsorships = '/sponsorships';
  static const String cancelSponsorship = '/sponsorships';
  static String annualReports(int sponsorshipId) =>
      '/sponsorships/$sponsorshipId/annual-reports';
  static const String completedAidCases =
      '/public/statistics/completed-aid-cases';
  static const String logout = '/auth/logout';

  static String walletDonateAidRequest(int requestId) =>
      '/wallet/donate/aid-requests/$requestId';

  static String walletDonateSponsorship(int sponsorshipId) =>
      '/wallet/donate/sponsorships/$sponsorshipId';

  static const String orphanSupportFundPaymentIntent =
      '/api/donor/sponsorship-fund/payment-intent';

  static const String orphanSupportFundWallet =
      '/api/donor/sponsorship-fund/wallet';

  static const String quickDonationFundPaymentIntent =
      '/api/donor/quick-aid-fund/payment-intent';

  static const String quickDonationFundWallet =
      '/api/donor/quick-aid-fund/wallet';
}
