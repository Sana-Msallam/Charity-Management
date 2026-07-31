import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Al Athar Association'**
  String get appTitle;

  /// No description provided for @associationName.
  ///
  /// In en, this message translates to:
  /// **'Al Athar Association'**
  String get associationName;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get phoneRequired;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'The phone number is invalid'**
  String get invalidPhoneNumber;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @createNewAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a new account'**
  String get createNewAccount;

  /// No description provided for @createDonorAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a donor account'**
  String get createDonorAccount;

  /// No description provided for @createBeneficiaryAccount.
  ///
  /// In en, this message translates to:
  /// **'Create a beneficiary account'**
  String get createBeneficiaryAccount;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get or;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get continueAsGuest;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @countrySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the country name'**
  String get countrySearchHint;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get changeLanguage;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @donorWelcome.
  ///
  /// In en, this message translates to:
  /// **'We are happy to have you join the giving journey'**
  String get donorWelcome;

  /// No description provided for @beneficiaryWelcome.
  ///
  /// In en, this message translates to:
  /// **'Enter your information to join the beneficiary care program'**
  String get beneficiaryWelcome;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Sarah'**
  String get firstNameHint;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Mohammad'**
  String get lastNameHint;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get lastNameRequired;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get email;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'The email address is invalid'**
  String get invalidEmail;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordMin6.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMin6;

  /// No description provided for @passwordMin8.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMin8;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @otpSent.
  ///
  /// In en, this message translates to:
  /// **'The verification code was sent successfully'**
  String get otpSent;

  /// No description provided for @otpSentToPhone.
  ///
  /// In en, this message translates to:
  /// **'The verification code was sent to your phone number'**
  String get otpSentToPhone;

  /// No description provided for @accountActivation.
  ///
  /// In en, this message translates to:
  /// **'Account activation'**
  String get accountActivation;

  /// No description provided for @otpInstructions.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit code sent to {phoneNumber}'**
  String otpInstructions(String phoneNumber);

  /// No description provided for @otpRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete verification code'**
  String get otpRequired;

  /// No description provided for @otpResendRequested.
  ///
  /// In en, this message translates to:
  /// **'A new verification code was requested'**
  String get otpResendRequested;

  /// No description provided for @phoneVerified.
  ///
  /// In en, this message translates to:
  /// **'Phone number verified successfully'**
  String get phoneVerified;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @resendAfter.
  ///
  /// In en, this message translates to:
  /// **'Resend after {seconds} seconds'**
  String resendAfter(int seconds);

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the phone number linked to your account and we will send you a code to reset your password.'**
  String get forgotPasswordDescription;

  /// No description provided for @phoneWithCountryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get phoneWithCountryRequired;

  /// No description provided for @countryCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Include the country code, for example +963'**
  String get countryCodeRequired;

  /// No description provided for @invalidFullPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'The phone number is invalid'**
  String get invalidFullPhoneNumber;

  /// No description provided for @sendingCode.
  ///
  /// In en, this message translates to:
  /// **'Sending code...'**
  String get sendingCode;

  /// No description provided for @sendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Send verification code'**
  String get sendVerificationCode;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verificationCode;

  /// No description provided for @verificationCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the verification code'**
  String get verificationCodeHint;

  /// No description provided for @verificationCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the verification code'**
  String get verificationCodeRequired;

  /// No description provided for @invalidVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'The verification code is invalid'**
  String get invalidVerificationCode;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @newPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get newPasswordRequired;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @changingPassword.
  ///
  /// In en, this message translates to:
  /// **'Changing password...'**
  String get changingPassword;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @accountCreated.
  ///
  /// In en, this message translates to:
  /// **'Your account was created successfully'**
  String get accountCreated;

  /// No description provided for @pendingApprovalMessage.
  ///
  /// In en, this message translates to:
  /// **'Your request is currently under review.\nYou can log in after a staff member approves your account.'**
  String get pendingApprovalMessage;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get backToLogin;

  /// No description provided for @residentialAddress.
  ///
  /// In en, this message translates to:
  /// **'Residential address'**
  String get residentialAddress;

  /// No description provided for @selectResidentialAddress.
  ///
  /// In en, this message translates to:
  /// **'Select your residential address'**
  String get selectResidentialAddress;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select your residential address'**
  String get addressRequired;

  /// No description provided for @familyStatementPhoto.
  ///
  /// In en, this message translates to:
  /// **'Family statement photo'**
  String get familyStatementPhoto;

  /// No description provided for @personalPhoto.
  ///
  /// In en, this message translates to:
  /// **'Personal photo'**
  String get personalPhoto;

  /// No description provided for @tapToSelectPhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap to select a photo'**
  String get tapToSelectPhoto;

  /// No description provided for @personalPhotoRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a personal photo'**
  String get personalPhotoRequired;

  /// No description provided for @familyStatementRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select the family statement photo'**
  String get familyStatementRequired;

  /// No description provided for @imageSelectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not select the image'**
  String get imageSelectionFailed;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @socialStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital status'**
  String get socialStatus;

  /// No description provided for @selectStatus.
  ///
  /// In en, this message translates to:
  /// **'Select status'**
  String get selectStatus;

  /// No description provided for @single.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get single;

  /// No description provided for @married.
  ///
  /// In en, this message translates to:
  /// **'Married'**
  String get married;

  /// No description provided for @divorced.
  ///
  /// In en, this message translates to:
  /// **'Divorced'**
  String get divorced;

  /// No description provided for @widowed.
  ///
  /// In en, this message translates to:
  /// **'Widowed'**
  String get widowed;

  /// No description provided for @numberOfChildren.
  ///
  /// In en, this message translates to:
  /// **'Number of children'**
  String get numberOfChildren;

  /// No description provided for @childrenRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the number of children'**
  String get childrenRequired;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @monthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'Monthly income'**
  String get monthlyIncome;

  /// No description provided for @incomeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the monthly income'**
  String get incomeRequired;

  /// No description provided for @invalidIncome.
  ///
  /// In en, this message translates to:
  /// **'The monthly income is invalid'**
  String get invalidIncome;

  /// No description provided for @syrianPound.
  ///
  /// In en, this message translates to:
  /// **'SYP'**
  String get syrianPound;

  /// No description provided for @employmentStatus.
  ///
  /// In en, this message translates to:
  /// **'Employment status'**
  String get employmentStatus;

  /// No description provided for @employed.
  ///
  /// In en, this message translates to:
  /// **'Employed'**
  String get employed;

  /// No description provided for @unemployed.
  ///
  /// In en, this message translates to:
  /// **'Unemployed'**
  String get unemployed;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @connectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'The connection timed out. Please try again.'**
  String get connectionTimeout;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Could not connect to the server. Check your internet connection.'**
  String get connectionError;

  /// No description provided for @badRequest.
  ///
  /// In en, this message translates to:
  /// **'The submitted data is invalid.'**
  String get badRequest;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session is unauthorized. Please log in again.'**
  String get unauthorized;

  /// No description provided for @forbidden.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this action.'**
  String get forbidden;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'The requested resource was not found.'**
  String get notFound;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'A server error occurred. Please try again later.'**
  String get serverError;

  /// No description provided for @invalidServerResponse.
  ///
  /// In en, this message translates to:
  /// **'The server response is invalid.'**
  String get invalidServerResponse;

  /// No description provided for @missingLoginToken.
  ///
  /// In en, this message translates to:
  /// **'The login token was not received.'**
  String get missingLoginToken;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Code verification failed.'**
  String get verificationFailed;

  /// No description provided for @operationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Operation completed successfully'**
  String get operationSuccessful;

  /// No description provided for @addressMazzeh.
  ///
  /// In en, this message translates to:
  /// **'Mazzeh'**
  String get addressMazzeh;

  /// No description provided for @addressMidan.
  ///
  /// In en, this message translates to:
  /// **'Midan'**
  String get addressMidan;

  /// No description provided for @addressMuhajireen.
  ///
  /// In en, this message translates to:
  /// **'Muhajireen'**
  String get addressMuhajireen;

  /// No description provided for @addressAfif.
  ///
  /// In en, this message translates to:
  /// **'Afif'**
  String get addressAfif;

  /// No description provided for @addressRuknAlDin.
  ///
  /// In en, this message translates to:
  /// **'Rukn al-Din'**
  String get addressRuknAlDin;

  /// No description provided for @addressSahnaya.
  ///
  /// In en, this message translates to:
  /// **'Sahnaya'**
  String get addressSahnaya;

  /// No description provided for @addressMalki.
  ///
  /// In en, this message translates to:
  /// **'Al-Malki'**
  String get addressMalki;

  /// No description provided for @addressBaghdadStreet.
  ///
  /// In en, this message translates to:
  /// **'Baghdad Street'**
  String get addressBaghdadStreet;

  /// No description provided for @addressKafrSousa.
  ///
  /// In en, this message translates to:
  /// **'Kafr Sousa'**
  String get addressKafrSousa;

  /// No description provided for @addressBarzeh.
  ///
  /// In en, this message translates to:
  /// **'Barzeh'**
  String get addressBarzeh;

  /// No description provided for @addressShaalan.
  ///
  /// In en, this message translates to:
  /// **'Shaalan'**
  String get addressShaalan;

  /// No description provided for @addressHamraStreet.
  ///
  /// In en, this message translates to:
  /// **'Hamra Street'**
  String get addressHamraStreet;

  /// No description provided for @addressMaysat.
  ///
  /// In en, this message translates to:
  /// **'Maysat'**
  String get addressMaysat;

  /// No description provided for @addressSalihiyah.
  ///
  /// In en, this message translates to:
  /// **'Al-Salihiyah'**
  String get addressSalihiyah;

  /// No description provided for @addressMazraa.
  ///
  /// In en, this message translates to:
  /// **'Al-Mazraa'**
  String get addressMazraa;

  /// No description provided for @addressRuralDamascus.
  ///
  /// In en, this message translates to:
  /// **'Rural Damascus'**
  String get addressRuralDamascus;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully. Welcome, {firstName}'**
  String loginSuccess(String firstName);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
