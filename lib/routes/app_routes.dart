class AppRoutes {
  AppRoutes._();

  static const String authGate = '/';
  static const String login = '/login';
  static const String registerDonor = '/register-donor';
  static const String registerBeneficiary = '/register-beneficiary';
  static const String otp = '/otp';
  static const String pendingApproval = '/pending-approval';
  static const String donorHome = '/donor-home';
  static const String beneficiaryHome = '/beneficiary-home';
  static const String applicantInfo = '/applicant-info';
  static const String educationRequest = '/education-request';
  static const String housingRequest = '/housing-request';
  static const String forgotPassword = '/forgot-password';
  static const String newPassword = '/new-password';
}

class OtpRouteArguments {
  const OtpRouteArguments({
    required this.countryCode,
    required this.phoneNumber,
    required this.userType,
  });

  final String countryCode;
  final String phoneNumber;
  final String userType;
}

class ApplicantInfoRouteArguments {
  const ApplicantInfoRouteArguments({required this.requestType});

  final String requestType;
}
