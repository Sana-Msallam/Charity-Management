// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Al Athar Association';

  @override
  String get associationName => 'Al Athar Association';

  @override
  String get login => 'Login';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get password => 'Password';

  @override
  String get phoneRequired => 'Please enter your phone number';

  @override
  String get invalidPhoneNumber => 'The phone number is invalid';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get createNewAccount => 'Create a new account';

  @override
  String get createDonorAccount => 'Create a donor account';

  @override
  String get createBeneficiaryAccount => 'Create a beneficiary account';

  @override
  String get or => 'Or';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get search => 'Search';

  @override
  String get countrySearchHint => 'Enter the country name';

  @override
  String get changeLanguage => 'العربية';

  @override
  String get createAccount => 'Create account';

  @override
  String get donorWelcome => 'We are happy to have you join the giving journey';

  @override
  String get beneficiaryWelcome =>
      'Enter your information to join the beneficiary care program';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get firstNameHint => 'Example: Sarah';

  @override
  String get lastNameHint => 'Example: Mohammad';

  @override
  String get firstNameRequired => 'Please enter your first name';

  @override
  String get lastNameRequired => 'Please enter your last name';

  @override
  String get email => 'Email address';

  @override
  String get emailRequired => 'Please enter your email address';

  @override
  String get invalidEmail => 'The email address is invalid';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get confirmPasswordRequired => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get passwordMin6 => 'Password must be at least 6 characters';

  @override
  String get passwordMin8 => 'Password must be at least 8 characters';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get otpSent => 'The verification code was sent successfully';

  @override
  String get otpSentToPhone =>
      'The verification code was sent to your phone number';

  @override
  String get accountActivation => 'Account activation';

  @override
  String otpInstructions(String phoneNumber) {
    return 'Enter the 4-digit code sent to $phoneNumber';
  }

  @override
  String get otpRequired => 'Please enter the complete verification code';

  @override
  String get otpResendRequested => 'A new verification code was requested';

  @override
  String get phoneVerified => 'Phone number verified successfully';

  @override
  String get confirm => 'Confirm';

  @override
  String get resendCode => 'Resend code';

  @override
  String resendAfter(int seconds) {
    return 'Resend after $seconds seconds';
  }

  @override
  String get forgotPasswordTitle => 'Forgot password';

  @override
  String get forgotPasswordDescription =>
      'Enter the phone number linked to your account and we will send you a code to reset your password.';

  @override
  String get phoneWithCountryRequired => 'Please enter your phone number';

  @override
  String get countryCodeRequired =>
      'Include the country code, for example +963';

  @override
  String get invalidFullPhoneNumber => 'The phone number is invalid';

  @override
  String get sendingCode => 'Sending code...';

  @override
  String get sendVerificationCode => 'Send verification code';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get verificationCode => 'Verification code';

  @override
  String get verificationCodeHint => 'Enter the verification code';

  @override
  String get verificationCodeRequired => 'Please enter the verification code';

  @override
  String get invalidVerificationCode => 'The verification code is invalid';

  @override
  String get newPassword => 'New password';

  @override
  String get newPasswordRequired => 'Please enter a new password';

  @override
  String get confirmNewPassword => 'Confirm new password';

  @override
  String get changingPassword => 'Changing password...';

  @override
  String get changePassword => 'Change password';

  @override
  String get accountCreated => 'Your account was created successfully';

  @override
  String get pendingApprovalMessage =>
      'Your request is currently under review.\nYou can log in after a staff member approves your account.';

  @override
  String get backToLogin => 'Back to login';

  @override
  String get residentialAddress => 'Residential address';

  @override
  String get selectResidentialAddress => 'Select your residential address';

  @override
  String get addressRequired => 'Please select your residential address';

  @override
  String get familyStatementPhoto => 'Family statement photo';

  @override
  String get personalPhoto => 'Personal photo';

  @override
  String get tapToSelectPhoto => 'Tap to select a photo';

  @override
  String get personalPhotoRequired => 'Please select a personal photo';

  @override
  String get familyStatementRequired =>
      'Please select the family statement photo';

  @override
  String get imageSelectionFailed => 'Could not select the image';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get socialStatus => 'Marital status';

  @override
  String get selectStatus => 'Select status';

  @override
  String get single => 'Single';

  @override
  String get married => 'Married';

  @override
  String get divorced => 'Divorced';

  @override
  String get widowed => 'Widowed';

  @override
  String get numberOfChildren => 'Number of children';

  @override
  String get childrenRequired => 'Please enter the number of children';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get monthlyIncome => 'Monthly income';

  @override
  String get incomeRequired => 'Please enter the monthly income';

  @override
  String get invalidIncome => 'The monthly income is invalid';

  @override
  String get syrianPound => 'SYP';

  @override
  String get employmentStatus => 'Employment status';

  @override
  String get employed => 'Employed';

  @override
  String get unemployed => 'Unemployed';

  @override
  String get unexpectedError => 'An unexpected error occurred';

  @override
  String get connectionTimeout => 'The connection timed out. Please try again.';

  @override
  String get connectionError =>
      'Could not connect to the server. Check your internet connection.';

  @override
  String get badRequest => 'The submitted data is invalid.';

  @override
  String get unauthorized =>
      'Your session is unauthorized. Please log in again.';

  @override
  String get forbidden => 'You do not have permission to perform this action.';

  @override
  String get notFound => 'The requested resource was not found.';

  @override
  String get serverError => 'A server error occurred. Please try again later.';

  @override
  String get invalidServerResponse => 'The server response is invalid.';

  @override
  String get missingLoginToken => 'The login token was not received.';

  @override
  String get verificationFailed => 'Code verification failed.';

  @override
  String get operationSuccessful => 'Operation completed successfully';

  @override
  String get addressMazzeh => 'Mazzeh';

  @override
  String get addressMidan => 'Midan';

  @override
  String get addressMuhajireen => 'Muhajireen';

  @override
  String get addressAfif => 'Afif';

  @override
  String get addressRuknAlDin => 'Rukn al-Din';

  @override
  String get addressSahnaya => 'Sahnaya';

  @override
  String get addressMalki => 'Al-Malki';

  @override
  String get addressBaghdadStreet => 'Baghdad Street';

  @override
  String get addressKafrSousa => 'Kafr Sousa';

  @override
  String get addressBarzeh => 'Barzeh';

  @override
  String get addressShaalan => 'Shaalan';

  @override
  String get addressHamraStreet => 'Hamra Street';

  @override
  String get addressMaysat => 'Maysat';

  @override
  String get addressSalihiyah => 'Al-Salihiyah';

  @override
  String get addressMazraa => 'Al-Mazraa';

  @override
  String get addressRuralDamascus => 'Rural Damascus';

  @override
  String loginSuccess(String firstName) {
    return 'Logged in successfully. Welcome, $firstName';
  }
}
