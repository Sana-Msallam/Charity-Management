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

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @noCompletedAidCases.
  ///
  /// In en, this message translates to:
  /// **'No completed aid cases'**
  String get noCompletedAidCases;

  /// No description provided for @aboutAtharAssociation.
  ///
  /// In en, this message translates to:
  /// **'About Athar Association'**
  String get aboutAtharAssociation;

  /// No description provided for @aboutAtharAssociationDescription.
  ///
  /// In en, this message translates to:
  /// **'Athar Association supports orphans and families in need through programs and initiatives that aim to improve their lives.'**
  String get aboutAtharAssociationDescription;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirth;

  /// No description provided for @selectDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Select date of birth'**
  String get selectDateOfBirth;

  /// No description provided for @completedAidCases.
  ///
  /// In en, this message translates to:
  /// **'Completed Cases'**
  String get completedAidCases;

  /// No description provided for @dateOfBirthHint.
  ///
  /// In en, this message translates to:
  /// **'YYYY-MM-DD'**
  String get dateOfBirthHint;

  /// No description provided for @dateOfBirthRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select your date of birth'**
  String get dateOfBirthRequired;

  /// No description provided for @invalidDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'The date of birth is invalid'**
  String get invalidDateOfBirth;

  /// No description provided for @dateOfBirthFutureInvalid.
  ///
  /// In en, this message translates to:
  /// **'Date of birth cannot be in the future'**
  String get dateOfBirthFutureInvalid;

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

  /// No description provided for @welcomeBackName.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, Sarah'**
  String get welcomeBackName;

  /// No description provided for @welcomeComma.
  ///
  /// In en, this message translates to:
  /// **'Welcome,'**
  String get welcomeComma;

  /// No description provided for @sampleUserSarah.
  ///
  /// In en, this message translates to:
  /// **'Sarah'**
  String get sampleUserSarah;

  /// No description provided for @specialAppeal.
  ///
  /// In en, this message translates to:
  /// **'Special appeal'**
  String get specialAppeal;

  /// No description provided for @sponsorAnOrphanToday.
  ///
  /// In en, this message translates to:
  /// **'Sponsor an orphan\ntoday'**
  String get sponsorAnOrphanToday;

  /// No description provided for @sponsorAnOrphanDescription.
  ///
  /// In en, this message translates to:
  /// **'Change a child\'s life with monthly support, education, and healthcare.'**
  String get sponsorAnOrphanDescription;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get learnMore;

  /// No description provided for @supportAreas.
  ///
  /// In en, this message translates to:
  /// **'Support areas'**
  String get supportAreas;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @smallProjects.
  ///
  /// In en, this message translates to:
  /// **'Small projects'**
  String get smallProjects;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @orphanFund.
  ///
  /// In en, this message translates to:
  /// **'Orphan fund'**
  String get orphanFund;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'My Donations'**
  String get title;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total Donations'**
  String get total;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @totalDonaited.
  ///
  /// In en, this message translates to:
  /// **'Total Donations'**
  String get totalDonaited;

  /// No description provided for @sponsorship.
  ///
  /// In en, this message translates to:
  /// **'Sponsorship'**
  String get sponsorship;

  /// No description provided for @walletTopUp.
  ///
  /// In en, this message translates to:
  /// **'Wallet Top-up'**
  String get walletTopUp;

  /// No description provided for @aidRequestDonation.
  ///
  /// In en, this message translates to:
  /// **'Aid Request'**
  String get aidRequestDonation;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance'**
  String get walletBalance;

  /// No description provided for @operation.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get operation;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'No transactions'**
  String get empty;

  /// No description provided for @sponsor.
  ///
  /// In en, this message translates to:
  /// **'sponsor'**
  String get sponsor;

  /// No description provided for @loadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load donation history'**
  String get loadError;

  /// No description provided for @housing.
  ///
  /// In en, this message translates to:
  /// **'Housing'**
  String get housing;

  /// No description provided for @loggingOut.
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get loggingOut;

  /// No description provided for @followDonations.
  ///
  /// In en, this message translates to:
  /// **'Follow your requests and donations'**
  String get followDonations;

  /// No description provided for @changeAppAppearance.
  ///
  /// In en, this message translates to:
  /// **'Change app appearance'**
  String get changeAppAppearance;

  /// No description provided for @languageAndAppearance.
  ///
  /// In en, this message translates to:
  /// **'Language and appearance'**
  String get languageAndAppearance;

  /// No description provided for @communityInitiatives.
  ///
  /// In en, this message translates to:
  /// **'Community initiatives'**
  String get communityInitiatives;

  /// No description provided for @communityInitiativesDescription.
  ///
  /// In en, this message translates to:
  /// **'Work with local leaders to build a sustainable future through collaborative giving.'**
  String get communityInitiativesDescription;

  /// No description provided for @explorePortal.
  ///
  /// In en, this message translates to:
  /// **'Explore portal'**
  String get explorePortal;

  /// No description provided for @totalImpact.
  ///
  /// In en, this message translates to:
  /// **'Total impact'**
  String get totalImpact;

  /// No description provided for @livesImpacted.
  ///
  /// In en, this message translates to:
  /// **'Lives impacted'**
  String get livesImpacted;

  /// No description provided for @sampleChildrenCount.
  ///
  /// In en, this message translates to:
  /// **'12 children'**
  String get sampleChildrenCount;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @impact.
  ///
  /// In en, this message translates to:
  /// **'Impact'**
  String get impact;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @sponsorships.
  ///
  /// In en, this message translates to:
  /// **'Sponsorships'**
  String get sponsorships;

  /// No description provided for @trackRequest.
  ///
  /// In en, this message translates to:
  /// **'Track request'**
  String get trackRequest;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @newAidRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit a new aid request'**
  String get newAidRequest;

  /// No description provided for @healthRequest.
  ///
  /// In en, this message translates to:
  /// **'Health request'**
  String get healthRequest;

  /// No description provided for @healthRequestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Treatment and medicine'**
  String get healthRequestSubtitle;

  /// No description provided for @foodRequest.
  ///
  /// In en, this message translates to:
  /// **'Food request'**
  String get foodRequest;

  /// No description provided for @foodRequestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Food baskets'**
  String get foodRequestSubtitle;

  /// No description provided for @housingRequest.
  ///
  /// In en, this message translates to:
  /// **'Housing request'**
  String get housingRequest;

  /// No description provided for @housingRequestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Home improvement or rent'**
  String get housingRequestSubtitle;

  /// No description provided for @educationRequest.
  ///
  /// In en, this message translates to:
  /// **'Education request'**
  String get educationRequest;

  /// No description provided for @educationRequestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fees and books'**
  String get educationRequestSubtitle;

  /// No description provided for @projectSupport.
  ///
  /// In en, this message translates to:
  /// **'Project support'**
  String get projectSupport;

  /// No description provided for @projectSupportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Funding and development'**
  String get projectSupportSubtitle;

  /// No description provided for @completedProjectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Projects completed by the association'**
  String get completedProjectsTitle;

  /// No description provided for @waterWellProject.
  ///
  /// In en, this message translates to:
  /// **'Water well drilling'**
  String get waterWellProject;

  /// No description provided for @schoolBuildingProject.
  ///
  /// In en, this message translates to:
  /// **'School building'**
  String get schoolBuildingProject;

  /// No description provided for @medicalComplexProject.
  ///
  /// In en, this message translates to:
  /// **'Medical complex'**
  String get medicalComplexProject;

  /// No description provided for @aboutAssociationTitle.
  ///
  /// In en, this message translates to:
  /// **'About the association'**
  String get aboutAssociationTitle;

  /// No description provided for @aboutAssociationDescription.
  ///
  /// In en, this message translates to:
  /// **'At our association, we strive to provide comprehensive support to people in need and build a future shaped by social solidarity and mercy through innovative development and relief programs.'**
  String get aboutAssociationDescription;

  /// No description provided for @ourVision.
  ///
  /// In en, this message translates to:
  /// **'Our vision'**
  String get ourVision;

  /// No description provided for @ourVisionDescription.
  ///
  /// In en, this message translates to:
  /// **'We aim to be a leading association in humanitarian work and help build a caring community where every person receives the support and care they need.'**
  String get ourVisionDescription;

  /// No description provided for @ourMission.
  ///
  /// In en, this message translates to:
  /// **'Our mission'**
  String get ourMission;

  /// No description provided for @ourMissionDescription.
  ///
  /// In en, this message translates to:
  /// **'We provide humanitarian aid and services efficiently and transparently, reaching the most vulnerable groups through development initiatives that create positive and lasting impact.'**
  String get ourMissionDescription;

  /// No description provided for @beneficiariesNeedSupport.
  ///
  /// In en, this message translates to:
  /// **'People in need of support'**
  String get beneficiariesNeedSupport;

  /// No description provided for @individual.
  ///
  /// In en, this message translates to:
  /// **'person'**
  String get individual;

  /// No description provided for @individuals.
  ///
  /// In en, this message translates to:
  /// **'people'**
  String get individuals;

  /// No description provided for @currencyRiyal.
  ///
  /// In en, this message translates to:
  /// **'Riyal'**
  String get currencyRiyal;

  /// No description provided for @currentStep.
  ///
  /// In en, this message translates to:
  /// **'Current step'**
  String get currentStep;

  /// No description provided for @lastStep.
  ///
  /// In en, this message translates to:
  /// **'Final step'**
  String get lastStep;

  /// No description provided for @stepOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{currentStep} of {totalSteps}'**
  String stepOfTotal(int currentStep, int totalSteps);

  /// No description provided for @dataPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Data privacy'**
  String get dataPrivacy;

  /// No description provided for @dataPrivacyDescription.
  ///
  /// In en, this message translates to:
  /// **'All uploaded data is handled with full confidentiality and privacy according to security standards.'**
  String get dataPrivacyDescription;

  /// No description provided for @whyWeAskData.
  ///
  /// In en, this message translates to:
  /// **'Why do we ask for this information?'**
  String get whyWeAskData;

  /// No description provided for @whyWeAskDataDescription.
  ///
  /// In en, this message translates to:
  /// **'We care about accurate data to ensure aid reaches eligible people as quickly as possible and with dignity.'**
  String get whyWeAskDataDescription;

  /// No description provided for @applicantInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Applicant information'**
  String get applicantInfoTitle;

  /// No description provided for @fatherName.
  ///
  /// In en, this message translates to:
  /// **'Father\'s name'**
  String get fatherName;

  /// No description provided for @fatherNameHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Ahmad'**
  String get fatherNameHint;

  /// No description provided for @familyName.
  ///
  /// In en, this message translates to:
  /// **'Family name'**
  String get familyName;

  /// No description provided for @familyNameHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Darwish'**
  String get familyNameHint;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @ageHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 35'**
  String get ageHint;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Damascus - Mazzeh'**
  String get addressHint;

  /// No description provided for @jobStatus.
  ///
  /// In en, this message translates to:
  /// **'Employment status'**
  String get jobStatus;

  /// No description provided for @working.
  ///
  /// In en, this message translates to:
  /// **'Working'**
  String get working;

  /// No description provided for @notWorking.
  ///
  /// In en, this message translates to:
  /// **'Unemployed'**
  String get notWorking;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @fillAllDataCorrectly.
  ///
  /// In en, this message translates to:
  /// **'Please make sure all information is filled correctly'**
  String get fillAllDataCorrectly;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Please select gender'**
  String get selectGender;

  /// No description provided for @selectSocialStatus.
  ///
  /// In en, this message translates to:
  /// **'Please select marital status'**
  String get selectSocialStatus;

  /// No description provided for @selectJobStatus.
  ///
  /// In en, this message translates to:
  /// **'Please select employment status'**
  String get selectJobStatus;

  /// No description provided for @invalidAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid age'**
  String get invalidAge;

  /// No description provided for @unsupportedRequestType.
  ///
  /// In en, this message translates to:
  /// **'This request type is not currently supported'**
  String get unsupportedRequestType;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Please enter {fieldName}'**
  String requiredField(String fieldName);

  /// No description provided for @fieldTooShort.
  ///
  /// In en, this message translates to:
  /// **'{fieldName} is too short'**
  String fieldTooShort(String fieldName);

  /// No description provided for @ageRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter age'**
  String get ageRequired;

  /// No description provided for @ageNumbersOnly.
  ///
  /// In en, this message translates to:
  /// **'Please enter age using numbers'**
  String get ageNumbersOnly;

  /// No description provided for @phoneValidRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneValidRequired;

  /// No description provided for @housingRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Housing request details'**
  String get housingRequestDetails;

  /// No description provided for @currentHousingStatus.
  ///
  /// In en, this message translates to:
  /// **'Current housing status'**
  String get currentHousingStatus;

  /// No description provided for @ownedHousing.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get ownedHousing;

  /// No description provided for @rentedHousing.
  ///
  /// In en, this message translates to:
  /// **'Rented'**
  String get rentedHousing;

  /// No description provided for @noHousing.
  ///
  /// In en, this message translates to:
  /// **'No housing'**
  String get noHousing;

  /// No description provided for @currentRentValue.
  ///
  /// In en, this message translates to:
  /// **'Current rent value, if any'**
  String get currentRentValue;

  /// No description provided for @currentResidenceDetails.
  ///
  /// In en, this message translates to:
  /// **'Current residence details'**
  String get currentResidenceDetails;

  /// No description provided for @currentResidenceHint.
  ///
  /// In en, this message translates to:
  /// **'City, neighborhood, street name'**
  String get currentResidenceHint;

  /// No description provided for @housingSupportReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for no shelter or need for support'**
  String get housingSupportReason;

  /// No description provided for @housingSupportReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Please write a detailed explanation of the case...'**
  String get housingSupportReasonHint;

  /// No description provided for @requestedHousingSpecs.
  ///
  /// In en, this message translates to:
  /// **'Requested or current housing specifications'**
  String get requestedHousingSpecs;

  /// No description provided for @requestedHousingSpecsHint.
  ///
  /// In en, this message translates to:
  /// **'Rooms count, floor, nearby services'**
  String get requestedHousingSpecsHint;

  /// No description provided for @attachProofDocuments.
  ///
  /// In en, this message translates to:
  /// **'Attach proof documents'**
  String get attachProofDocuments;

  /// No description provided for @housingDocumentsDescription.
  ///
  /// In en, this message translates to:
  /// **'Lease contract, current housing photos, or any documents supporting the request (JPG, PDF)'**
  String get housingDocumentsDescription;

  /// No description provided for @housingQuote.
  ///
  /// In en, this message translates to:
  /// **'\"We strive to provide a safe and dignified environment for every family\"'**
  String get housingQuote;

  /// No description provided for @submitRequestForReview.
  ///
  /// In en, this message translates to:
  /// **'Submit request for review'**
  String get submitRequestForReview;

  /// No description provided for @healthRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Health request details'**
  String get healthRequestDetails;

  /// No description provided for @medicalAidTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select the type of medical aid'**
  String get medicalAidTypeRequired;

  /// No description provided for @healthDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a health condition description'**
  String get healthDescriptionRequired;

  /// No description provided for @validCostRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid cost'**
  String get validCostRequired;

  /// No description provided for @medicalAttachmentRequired.
  ///
  /// In en, this message translates to:
  /// **'Please attach at least one report or prescription'**
  String get medicalAttachmentRequired;

  /// No description provided for @duplicateFiles.
  ///
  /// In en, this message translates to:
  /// **'Selected files were already added'**
  String get duplicateFiles;

  /// No description provided for @filesAccessFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not access the selected files'**
  String get filesAccessFailed;

  /// No description provided for @fileSelectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not select files. Please try again.'**
  String get fileSelectionFailed;

  /// No description provided for @medicalAidType.
  ///
  /// In en, this message translates to:
  /// **'Required medical aid type'**
  String get medicalAidType;

  /// No description provided for @medicineInsurance.
  ///
  /// In en, this message translates to:
  /// **'Medicine insurance'**
  String get medicineInsurance;

  /// No description provided for @surgery.
  ///
  /// In en, this message translates to:
  /// **'Surgery'**
  String get surgery;

  /// No description provided for @medicalDevices.
  ///
  /// In en, this message translates to:
  /// **'Medical devices'**
  String get medicalDevices;

  /// No description provided for @healthDescription.
  ///
  /// In en, this message translates to:
  /// **'Detailed health condition description'**
  String get healthDescription;

  /// No description provided for @healthDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Please mention the diagnosis and symptoms clearly...'**
  String get healthDescriptionHint;

  /// No description provided for @treatmentExpectedCost.
  ///
  /// In en, this message translates to:
  /// **'Expected treatment cost'**
  String get treatmentExpectedCost;

  /// No description provided for @medicalReportsUpload.
  ///
  /// In en, this message translates to:
  /// **'Attach medical reports and official prescriptions'**
  String get medicalReportsUpload;

  /// No description provided for @uploadFilesOrCapture.
  ///
  /// In en, this message translates to:
  /// **'Upload files or take photos'**
  String get uploadFilesOrCapture;

  /// No description provided for @medicalReportsUploadDescription.
  ///
  /// In en, this message translates to:
  /// **'Please attach clear photos of reports and prescriptions'**
  String get medicalReportsUploadDescription;

  /// No description provided for @deleteAttachment.
  ///
  /// In en, this message translates to:
  /// **'Delete attachment'**
  String get deleteAttachment;

  /// No description provided for @fileReadyForUpload.
  ///
  /// In en, this message translates to:
  /// **'File ready for upload'**
  String get fileReadyForUpload;

  /// No description provided for @educationRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Education request details'**
  String get educationRequestDetails;

  /// No description provided for @educationLevel.
  ///
  /// In en, this message translates to:
  /// **'Education level'**
  String get educationLevel;

  /// No description provided for @schoolLevel.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get schoolLevel;

  /// No description provided for @universityLevel.
  ///
  /// In en, this message translates to:
  /// **'University'**
  String get universityLevel;

  /// No description provided for @institutionName.
  ///
  /// In en, this message translates to:
  /// **'School / university name'**
  String get institutionName;

  /// No description provided for @institutionNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the name here...'**
  String get institutionNameHint;

  /// No description provided for @gradeOrYear.
  ///
  /// In en, this message translates to:
  /// **'Grade / academic year'**
  String get gradeOrYear;

  /// No description provided for @selectGradeHint.
  ///
  /// In en, this message translates to:
  /// **'Select grade...'**
  String get selectGradeHint;

  /// No description provided for @requestedAssistanceType.
  ///
  /// In en, this message translates to:
  /// **'Requested assistance type'**
  String get requestedAssistanceType;

  /// No description provided for @schoolClothes.
  ///
  /// In en, this message translates to:
  /// **'School clothes'**
  String get schoolClothes;

  /// No description provided for @studySupplies.
  ///
  /// In en, this message translates to:
  /// **'Study supplies'**
  String get studySupplies;

  /// No description provided for @universityFees.
  ///
  /// In en, this message translates to:
  /// **'University fees'**
  String get universityFees;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @primaryStage.
  ///
  /// In en, this message translates to:
  /// **'Primary stage'**
  String get primaryStage;

  /// No description provided for @middleStage.
  ///
  /// In en, this message translates to:
  /// **'Middle stage'**
  String get middleStage;

  /// No description provided for @secondaryStage.
  ///
  /// In en, this message translates to:
  /// **'Secondary stage'**
  String get secondaryStage;

  /// No description provided for @firstUniversityYear.
  ///
  /// In en, this message translates to:
  /// **'First university year'**
  String get firstUniversityYear;

  /// No description provided for @secondUniversityYear.
  ///
  /// In en, this message translates to:
  /// **'Second university year'**
  String get secondUniversityYear;

  /// No description provided for @caseDescription.
  ///
  /// In en, this message translates to:
  /// **'Detailed case description'**
  String get caseDescription;

  /// No description provided for @educationDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your educational need so we can provide the best support...'**
  String get educationDescriptionHint;

  /// No description provided for @expectedTotalCost.
  ///
  /// In en, this message translates to:
  /// **'Expected total cost'**
  String get expectedTotalCost;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get profileTitle;

  /// No description provided for @ageWithYears.
  ///
  /// In en, this message translates to:
  /// **'{years} years'**
  String ageWithYears(int years);

  /// No description provided for @workStatus.
  ///
  /// In en, this message translates to:
  /// **'Work status'**
  String get workStatus;

  /// No description provided for @employedStatus.
  ///
  /// In en, this message translates to:
  /// **'Employed'**
  String get employedStatus;

  /// No description provided for @unemployedStatus.
  ///
  /// In en, this message translates to:
  /// **'Unemployed'**
  String get unemployedStatus;

  /// No description provided for @caseDetails.
  ///
  /// In en, this message translates to:
  /// **'Case details'**
  String get caseDetails;

  /// No description provided for @activeCases.
  ///
  /// In en, this message translates to:
  /// **'Active cases'**
  String get activeCases;

  /// No description provided for @availableCases.
  ///
  /// In en, this message translates to:
  /// **'{count} available'**
  String availableCases(int count);

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @supportCategoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Support urgent needs and development campaigns for {category}.'**
  String supportCategoryDescription(String category);

  /// No description provided for @remainingAmount.
  ///
  /// In en, this message translates to:
  /// **'Remaining amount: {amount}'**
  String remainingAmount(String amount);

  /// No description provided for @collected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get collected;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @requiredAmount.
  ///
  /// In en, this message translates to:
  /// **'Required amount'**
  String get requiredAmount;

  /// No description provided for @amountCollected.
  ///
  /// In en, this message translates to:
  /// **'Amount collected'**
  String get amountCollected;

  /// No description provided for @amountRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get amountRemaining;

  /// No description provided for @completionPercentage.
  ///
  /// In en, this message translates to:
  /// **'Completion rate {percentage}%'**
  String completionPercentage(num percentage);

  /// No description provided for @donateNow.
  ///
  /// In en, this message translates to:
  /// **'Donate now'**
  String get donateNow;

  /// No description provided for @currentWalletBalance.
  ///
  /// In en, this message translates to:
  /// **'Current wallet balance'**
  String get currentWalletBalance;

  /// No description provided for @topUpWallet.
  ///
  /// In en, this message translates to:
  /// **'Top up wallet'**
  String get topUpWallet;

  /// No description provided for @mySponsorships.
  ///
  /// In en, this message translates to:
  /// **'My sponsorships'**
  String get mySponsorships;

  /// No description provided for @manageCurrentSponsoredOrphans.
  ///
  /// In en, this message translates to:
  /// **'Manage currently sponsored orphans'**
  String get manageCurrentSponsoredOrphans;

  /// No description provided for @addNewSponsorship.
  ///
  /// In en, this message translates to:
  /// **'Add a new sponsorship'**
  String get addNewSponsorship;

  /// No description provided for @currentSponsorships.
  ///
  /// In en, this message translates to:
  /// **'Current sponsorships'**
  String get currentSponsorships;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @sponsoredChildrenCount.
  ///
  /// In en, this message translates to:
  /// **'Currently sponsored children'**
  String get sponsoredChildrenCount;

  /// No description provided for @sponsoredChildrenTotal.
  ///
  /// In en, this message translates to:
  /// **'{count}'**
  String sponsoredChildrenTotal(int count);

  /// No description provided for @sponsoredList.
  ///
  /// In en, this message translates to:
  /// **'Sponsored list'**
  String get sponsoredList;

  /// No description provided for @activeStatus.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get activeStatus;

  /// No description provided for @sponsorshipsPageDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your sponsorships and support children'**
  String get sponsorshipsPageDescription;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @donor.
  ///
  /// In en, this message translates to:
  /// **'Donor'**
  String get donor;

  /// No description provided for @unspecified.
  ///
  /// In en, this message translates to:
  /// **'Unspecified'**
  String get unspecified;

  /// No description provided for @myDonations.
  ///
  /// In en, this message translates to:
  /// **'My Donations'**
  String get myDonations;

  /// No description provided for @myDonationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track your requests and donations'**
  String get myDonationsSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @appearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change app appearance'**
  String get appearanceSubtitle;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutLoading.
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get logoutLoading;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logoutError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while logging out'**
  String get logoutError;

  /// No description provided for @availableForSponsorship.
  ///
  /// In en, this message translates to:
  /// **'Available for sponsorship'**
  String get availableForSponsorship;

  /// No description provided for @supportAChild.
  ///
  /// In en, this message translates to:
  /// **'Sponsor a child'**
  String get supportAChild;

  /// No description provided for @startNewSponsorshipDescription.
  ///
  /// In en, this message translates to:
  /// **'Start a new sponsorship and support a child'**
  String get startNewSponsorshipDescription;

  /// No description provided for @chooseOrphanAndStartSponsorship.
  ///
  /// In en, this message translates to:
  /// **'Choose a child and start a sponsorship request'**
  String get chooseOrphanAndStartSponsorship;

  /// No description provided for @walletBalanceUsedForSponsorship.
  ///
  /// In en, this message translates to:
  /// **'Your wallet balance is used when you submit a sponsorship request'**
  String get walletBalanceUsedForSponsorship;

  /// No description provided for @givingImpactDescription.
  ///
  /// In en, this message translates to:
  /// **'Educational meals were provided this month thanks to your giving'**
  String get givingImpactDescription;

  /// No description provided for @newSponsorshipRequest.
  ///
  /// In en, this message translates to:
  /// **'New sponsorship request'**
  String get newSponsorshipRequest;

  /// No description provided for @changeChildLife.
  ///
  /// In en, this message translates to:
  /// **'Help change a child\'s life'**
  String get changeChildLife;

  /// No description provided for @completeTrust.
  ///
  /// In en, this message translates to:
  /// **'Complete trust'**
  String get completeTrust;

  /// No description provided for @completeTrustDescription.
  ///
  /// In en, this message translates to:
  /// **'All data and information are handled with the highest privacy and security standards according to Sharia guidelines.'**
  String get completeTrustDescription;

  /// No description provided for @sponsorshipTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sponsorship terms and conditions'**
  String get sponsorshipTermsTitle;

  /// No description provided for @sponsorshipTermWalletBalance.
  ///
  /// In en, this message translates to:
  /// **'The wallet must have enough balance to cover 4 months of sponsorship in advance, with the sponsorship amount deducted automatically each month.'**
  String get sponsorshipTermWalletBalance;

  /// No description provided for @sponsorshipTermReservedBalance.
  ///
  /// In en, this message translates to:
  /// **'Once the sponsorship balance is reserved in advance for the specified orphan\'s expenses, it may not be used for other purposes.'**
  String get sponsorshipTermReservedBalance;

  /// No description provided for @sponsorshipTermLowBalance.
  ///
  /// In en, this message translates to:
  /// **'The sponsorship is cancelled automatically if the balance drops below two months\' value without compensating the concerned amount.'**
  String get sponsorshipTermLowBalance;

  /// No description provided for @sponsorshipTermOrphanSelection.
  ///
  /// In en, this message translates to:
  /// **'The orphan is selected by management based on need and priority lists to ensure fairness and cover the most affected cases.'**
  String get sponsorshipTermOrphanSelection;

  /// No description provided for @sponsorshipTermFilesAccess.
  ///
  /// In en, this message translates to:
  /// **'The orphan profile and periodic reports are fully available only through the account dashboard after the request is approved.'**
  String get sponsorshipTermFilesAccess;

  /// No description provided for @acceptSponsorshipTerms.
  ///
  /// In en, this message translates to:
  /// **'Confirm and accept terms'**
  String get acceptSponsorshipTerms;

  /// No description provided for @orphanSponsorshipVirtue.
  ///
  /// In en, this message translates to:
  /// **'The virtue of sponsoring orphans'**
  String get orphanSponsorshipVirtue;

  /// No description provided for @orphanSponsorshipHadith.
  ///
  /// In en, this message translates to:
  /// **'Sahl ibn Sa\'d, may Allah be pleased with him, reported that the Messenger of Allah said: \"I and the sponsor of an orphan will be in Paradise like this,\" and he gestured with his index and middle fingers, separating them slightly.'**
  String get orphanSponsorshipHadith;

  /// No description provided for @narratedByBukhari.
  ///
  /// In en, this message translates to:
  /// **'Narrated by Al-Bukhari'**
  String get narratedByBukhari;

  /// No description provided for @sponsorshipThankYou.
  ///
  /// In en, this message translates to:
  /// **'May Allah reward you and forgive you'**
  String get sponsorshipThankYou;

  /// No description provided for @sponsorshipRequestSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your sponsorship request has been received successfully and is now being reviewed by the relevant department.\n\nThe app will notify you once the request is accepted and approved so you can follow the orphan\'s status.'**
  String get sponsorshipRequestSuccessMessage;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backToHome;

  /// No description provided for @digitalNumber.
  ///
  /// In en, this message translates to:
  /// **'Digital number: {id}'**
  String digitalNumber(String id);

  /// No description provided for @underCareNow.
  ///
  /// In en, this message translates to:
  /// **'Currently under care and support'**
  String get underCareNow;

  /// No description provided for @familyAndPersonalData.
  ///
  /// In en, this message translates to:
  /// **'Family and personal data'**
  String get familyAndPersonalData;

  /// No description provided for @motherName.
  ///
  /// In en, this message translates to:
  /// **'Mother\'s name'**
  String get motherName;

  /// No description provided for @familyStatus.
  ///
  /// In en, this message translates to:
  /// **'Family status'**
  String get familyStatus;

  /// No description provided for @sampleFamilyStatusDescription.
  ///
  /// In en, this message translates to:
  /// **'Fatherless orphan, lives with his mother in a rented home.'**
  String get sampleFamilyStatusDescription;

  /// No description provided for @educationAndHealthStatus.
  ///
  /// In en, this message translates to:
  /// **'Education and health status'**
  String get educationAndHealthStatus;

  /// No description provided for @healthStatus.
  ///
  /// In en, this message translates to:
  /// **'Health status'**
  String get healthStatus;

  /// No description provided for @healthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get healthy;

  /// No description provided for @schoolGrade.
  ///
  /// In en, this message translates to:
  /// **'School grade'**
  String get schoolGrade;

  /// No description provided for @fourthGrade.
  ///
  /// In en, this message translates to:
  /// **'Fourth grade'**
  String get fourthGrade;

  /// No description provided for @healthDetails.
  ///
  /// In en, this message translates to:
  /// **'Health details'**
  String get healthDetails;

  /// No description provided for @sampleHealthDetails.
  ///
  /// In en, this message translates to:
  /// **'Healthy and, praise be to Allah, does not suffer from chronic diseases.'**
  String get sampleHealthDetails;

  /// No description provided for @guardianAndOfficialsData.
  ///
  /// In en, this message translates to:
  /// **'Guardian and officials data'**
  String get guardianAndOfficialsData;

  /// No description provided for @guardian.
  ///
  /// In en, this message translates to:
  /// **'Guardian'**
  String get guardian;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact number'**
  String get contactNumber;

  /// No description provided for @siblingsCount.
  ///
  /// In en, this message translates to:
  /// **'Number of siblings'**
  String get siblingsCount;

  /// No description provided for @sampleSiblingsCount.
  ///
  /// In en, this message translates to:
  /// **'3 siblings'**
  String get sampleSiblingsCount;

  /// No description provided for @renewSponsorshipOrDonate.
  ///
  /// In en, this message translates to:
  /// **'Renew sponsorship or donate'**
  String get renewSponsorshipOrDonate;

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
