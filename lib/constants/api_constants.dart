class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://192.168.2.125:3000';

  static const String login = '/auth/login/client';

  static const String registerDonor = '/auth/register/donor';
  static const String verifyOtp = '/auth/register/verify-otp';

  static const String healthRequest = '/requests/health';
  static const String educationRequest =
    '/requests/education';
    static const String housingRequest =
    '/requests/housing';
    static const String foodRequest =
    '/requests/food';
      static const String smallProjectRequest = '/requests/small-projects';

}
