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
  /// **'Email'**
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
  /// **'Date of Birth'**
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
  /// **'Social Status'**
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
  /// **'Employment Status'**
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
  /// **'Al Athar Association... Every Act of Giving Leaves an Impact'**
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
  /// **'\$'**
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
  /// **'Medicine Coverage'**
  String get medicineInsurance;

  /// No description provided for @surgery.
  ///
  /// In en, this message translates to:
  /// **'Surgery'**
  String get surgery;

  /// No description provided for @medicalDevices.
  ///
  /// In en, this message translates to:
  /// **'Medical Devices'**
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
  /// **'My Account'**
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
  /// **'Remaining: {amount} SAR'**
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

  /// No description provided for @donationCheckoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete donation'**
  String get donationCheckoutTitle;

  /// No description provided for @aidRequestDonation.
  ///
  /// In en, this message translates to:
  /// **'Aid request donation'**
  String get aidRequestDonation;

  /// No description provided for @donationAmountUsd.
  ///
  /// In en, this message translates to:
  /// **'Donation amount in USD'**
  String get donationAmountUsd;

  /// No description provided for @donationAmountHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 25'**
  String get donationAmountHint;

  /// No description provided for @invalidDonationAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive amount that does not exceed the remaining amount.'**
  String get invalidDonationAmount;

  /// No description provided for @completeDonation.
  ///
  /// In en, this message translates to:
  /// **'Complete secure payment'**
  String get completeDonation;

  /// No description provided for @stripePaymentSheetNotice.
  ///
  /// In en, this message translates to:
  /// **'Card details are entered only in Stripe\'s secure payment sheet.'**
  String get stripePaymentSheetNotice;

  /// No description provided for @paymentCompletedRefresh.
  ///
  /// In en, this message translates to:
  /// **'Payment completed. Refreshing request details...'**
  String get paymentCompletedRefresh;

  /// No description provided for @paymentCanceled.
  ///
  /// In en, this message translates to:
  /// **'Payment was canceled.'**
  String get paymentCanceled;

  /// No description provided for @stripePaymentError.
  ///
  /// In en, this message translates to:
  /// **'Stripe could not complete the payment. Please try again.'**
  String get stripePaymentError;

  /// No description provided for @stripePublishableKeyMissing.
  ///
  /// In en, this message translates to:
  /// **'Stripe publishable key is missing. Run the Flutter with Stripe launch configuration.'**
  String get stripePublishableKeyMissing;

  /// No description provided for @stripePublishableKeyInvalid.
  ///
  /// In en, this message translates to:
  /// **'Stripe publishable key must start with pk_test_.'**
  String get stripePublishableKeyInvalid;

  /// No description provided for @paymentAmountMustBePositive.
  ///
  /// In en, this message translates to:
  /// **'The donation amount must be greater than zero.'**
  String get paymentAmountMustBePositive;

  /// No description provided for @paymentAmountExceedsRemaining.
  ///
  /// In en, this message translates to:
  /// **'The donation amount cannot exceed the remaining amount.'**
  String get paymentAmountExceedsRemaining;

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

  /// No description provided for @walletBalanceLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading balance...'**
  String get walletBalanceLoading;

  /// No description provided for @couldNotLoadWalletBalance.
  ///
  /// In en, this message translates to:
  /// **'Could not load balance'**
  String get couldNotLoadWalletBalance;

  /// No description provided for @walletBalanceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Balance is currently unavailable'**
  String get walletBalanceUnavailable;

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

  /// No description provided for @noSponsorshipsForStatus.
  ///
  /// In en, this message translates to:
  /// **'No sponsorships with this status'**
  String get noSponsorshipsForStatus;

  /// No description provided for @sponsorshipUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Sponsorship under review'**
  String get sponsorshipUnderReview;

  /// No description provided for @filterSponsorships.
  ///
  /// In en, this message translates to:
  /// **'Filter sponsorships'**
  String get filterSponsorships;

  /// No description provided for @allSponsorships.
  ///
  /// In en, this message translates to:
  /// **'All sponsorships'**
  String get allSponsorships;

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

  /// No description provided for @sponsorshipWalletEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Wallet Empty'**
  String get sponsorshipWalletEmptyTitle;

  /// No description provided for @sponsorshipWalletEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'You cannot submit a sponsorship request because your wallet is empty. Please top up your wallet and try again.'**
  String get sponsorshipWalletEmptyMessage;

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

  /// No description provided for @orphanSponsorshipDetails.
  ///
  /// In en, this message translates to:
  /// **'Sponsorship Details'**
  String get orphanSponsorshipDetails;

  /// No description provided for @orphanPersonalData.
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get orphanPersonalData;

  /// No description provided for @sponsorshipData.
  ///
  /// In en, this message translates to:
  /// **'Sponsorship Data'**
  String get sponsorshipData;

  /// No description provided for @orphanName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get orphanName;

  /// No description provided for @birthDate.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get birthDate;

  /// No description provided for @orphanClass.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get orphanClass;

  /// No description provided for @talent.
  ///
  /// In en, this message translates to:
  /// **'Talent'**
  String get talent;

  /// No description provided for @monthlySponsorshipAmount.
  ///
  /// In en, this message translates to:
  /// **'Monthly amount'**
  String get monthlySponsorshipAmount;

  /// No description provided for @sponsorshipStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Sponsorship status'**
  String get sponsorshipStatusLabel;

  /// No description provided for @sponsorshipStartDate.
  ///
  /// In en, this message translates to:
  /// **'Sponsorship start date'**
  String get sponsorshipStartDate;

  /// No description provided for @sponsorshipEndDate.
  ///
  /// In en, this message translates to:
  /// **'Sponsorship end date'**
  String get sponsorshipEndDate;

  /// No description provided for @sponsorshipCreatedDate.
  ///
  /// In en, this message translates to:
  /// **'Sponsorship creation date'**
  String get sponsorshipCreatedDate;

  /// No description provided for @sponsorshipRejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Rejection reason'**
  String get sponsorshipRejectionReason;

  /// No description provided for @sponsorshipCancellationSource.
  ///
  /// In en, this message translates to:
  /// **'Cancellation source'**
  String get sponsorshipCancellationSource;

  /// No description provided for @sponsorshipStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get sponsorshipStatusPending;

  /// No description provided for @sponsorshipStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get sponsorshipStatusAccepted;

  /// No description provided for @sponsorshipStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get sponsorshipStatusRejected;

  /// No description provided for @sponsorshipStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get sponsorshipStatusCancelled;

  /// No description provided for @confirmMonthlySponsorshipPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm monthly sponsorship payment'**
  String get confirmMonthlySponsorshipPayment;

  /// No description provided for @monthlySponsorshipPaymentConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to pay the monthly sponsorship from your wallet balance? The system will determine the amount.'**
  String get monthlySponsorshipPaymentConfirmation;

  /// No description provided for @confirmPayment.
  ///
  /// In en, this message translates to:
  /// **'Confirm payment'**
  String get confirmPayment;

  /// No description provided for @cancelSponsorship.
  ///
  /// In en, this message translates to:
  /// **'Cancel Sponsorship'**
  String get cancelSponsorship;

  /// No description provided for @cancelSponsorshipConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this sponsorship?'**
  String get cancelSponsorshipConfirmation;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get goBack;

  /// No description provided for @noOrphanDataTitle.
  ///
  /// In en, this message translates to:
  /// **'No orphan information is available now'**
  String get noOrphanDataTitle;

  /// No description provided for @noOrphanDataDescription.
  ///
  /// In en, this message translates to:
  /// **'The sponsorship request is still pending, and no orphan has been assigned to you yet.'**
  String get noOrphanDataDescription;

  /// No description provided for @annualReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Annual reports'**
  String get annualReportsTitle;

  /// No description provided for @annualReportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View the latest update about the orphan'**
  String get annualReportsSubtitle;

  /// No description provided for @annualReportYear.
  ///
  /// In en, this message translates to:
  /// **'Annual report {year}'**
  String annualReportYear(int year);

  /// No description provided for @annualReportNumber.
  ///
  /// In en, this message translates to:
  /// **'Report no. {number}'**
  String annualReportNumber(int number);

  /// No description provided for @viewReport.
  ///
  /// In en, this message translates to:
  /// **'View report'**
  String get viewReport;

  /// No description provided for @noAnnualReportsYet.
  ///
  /// In en, this message translates to:
  /// **'No annual reports yet'**
  String get noAnnualReportsYet;

  /// No description provided for @annualReportsLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading annual reports...'**
  String get annualReportsLoading;

  /// No description provided for @annualReportsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load annual reports'**
  String get annualReportsLoadFailed;

  /// No description provided for @annualReportPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Annual report {year}'**
  String annualReportPreviewTitle(int year);

  /// No description provided for @reportImageLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the report image'**
  String get reportImageLoadFailed;

  /// No description provided for @saveAnnualReportDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Save annual report'**
  String get saveAnnualReportDialogTitle;

  /// No description provided for @downloadReportSuccess.
  ///
  /// In en, this message translates to:
  /// **'{fileName} was saved successfully'**
  String downloadReportSuccess(String fileName);

  /// No description provided for @downloadReportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not download the report'**
  String get downloadReportFailed;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully. Welcome, {firstName}'**
  String loginSuccess(String firstName);

  /// No description provided for @appPreferences.
  ///
  /// In en, this message translates to:
  /// **'App preferences'**
  String get appPreferences;

  /// No description provided for @changeAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get changeAppLanguage;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update account password'**
  String get changePasswordSubtitle;

  /// No description provided for @logoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out of the current account'**
  String get logoutSubtitle;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose app language'**
  String get chooseLanguage;

  /// No description provided for @togetherWeMakeImpact.
  ///
  /// In en, this message translates to:
  /// **'Together, We Make an Impact'**
  String get togetherWeMakeImpact;

  /// No description provided for @renewedHope.
  ///
  /// In en, this message translates to:
  /// **'Renewed Hope'**
  String get renewedHope;

  /// No description provided for @givingMakesDifference.
  ///
  /// In en, this message translates to:
  /// **'Giving Makes a Difference'**
  String get givingMakesDifference;

  /// No description provided for @noCompletedProjects.
  ///
  /// In en, this message translates to:
  /// **'There are no completed projects at the moment'**
  String get noCompletedProjects;

  /// No description provided for @riyal.
  ///
  /// In en, this message translates to:
  /// **'\$'**
  String get riyal;

  /// No description provided for @profileLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load profile'**
  String get profileLoadError;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @beneficiary.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary'**
  String get beneficiary;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get years;

  /// No description provided for @residence.
  ///
  /// In en, this message translates to:
  /// **'Place of Residence'**
  String get residence;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @profileAccountHint.
  ///
  /// In en, this message translates to:
  /// **'Your account information registered with the association is displayed here.'**
  String get profileAccountHint;

  /// No description provided for @alternateAddressLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load the address in the other language'**
  String get alternateAddressLoadError;

  /// No description provided for @loadBothAddressesBeforeSave.
  ///
  /// In en, this message translates to:
  /// **'Both language addresses must be loaded before saving changes'**
  String get loadBothAddressesBeforeSave;

  /// No description provided for @unsupportedGenderValue.
  ///
  /// In en, this message translates to:
  /// **'The current gender value is not supported'**
  String get unsupportedGenderValue;

  /// No description provided for @unsupportedSocialStatusValue.
  ///
  /// In en, this message translates to:
  /// **'The current social status value is not supported'**
  String get unsupportedSocialStatusValue;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @savingChanges.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get savingChanges;

  /// No description provided for @changePhoto.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changePhoto;

  /// No description provided for @profilePhotoOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'The photo is optional and will only change if you select a new one'**
  String get profilePhotoOptionalHint;

  /// No description provided for @bilingualAddress.
  ///
  /// In en, this message translates to:
  /// **'Address in both languages'**
  String get bilingualAddress;

  /// No description provided for @arabicAddress.
  ///
  /// In en, this message translates to:
  /// **'Address in Arabic'**
  String get arabicAddress;

  /// No description provided for @arabicAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the address in Arabic'**
  String get arabicAddressHint;

  /// No description provided for @englishAddress.
  ///
  /// In en, this message translates to:
  /// **'Address in English'**
  String get englishAddress;

  /// No description provided for @englishAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the address in English'**
  String get englishAddressHint;

  /// No description provided for @loadingAlternateAddress.
  ///
  /// In en, this message translates to:
  /// **'Loading the address in the other language...'**
  String get loadingAlternateAddress;

  /// No description provided for @readOnlyData.
  ///
  /// In en, this message translates to:
  /// **'Read-only information'**
  String get readOnlyData;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @currentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Current password is required'**
  String get currentPasswordRequired;

  /// No description provided for @requestTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Requests'**
  String get requestTrackingTitle;

  /// No description provided for @allRequests.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allRequests;

  /// No description provided for @pendingRequests.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get pendingRequests;

  /// No description provided for @acceptedRequests.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get acceptedRequests;

  /// No description provided for @rejectedRequests.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejectedRequests;

  /// No description provided for @cancelledRequests.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledRequests;

  /// No description provided for @cancelRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Request'**
  String get cancelRequestTitle;

  /// No description provided for @cancelRequestConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel request {requestId}?\nYou will not be able to undo this action.'**
  String cancelRequestConfirmation(int requestId);

  /// No description provided for @confirmCancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel Request'**
  String get confirmCancelRequest;

  /// No description provided for @requestCancelledTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Cancelled'**
  String get requestCancelledTitle;

  /// No description provided for @requestsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to Load Requests'**
  String get requestsLoadError;

  /// No description provided for @noRequestsForStatus.
  ///
  /// In en, this message translates to:
  /// **'There are no requests with this status'**
  String get noRequestsForStatus;

  /// No description provided for @requestNumber.
  ///
  /// In en, this message translates to:
  /// **'Request {requestId}'**
  String requestNumber(int requestId);

  /// No description provided for @requestType.
  ///
  /// In en, this message translates to:
  /// **'Request Type'**
  String get requestType;

  /// No description provided for @subCategory.
  ///
  /// In en, this message translates to:
  /// **'Subcategory'**
  String get subCategory;

  /// No description provided for @aidType.
  ///
  /// In en, this message translates to:
  /// **'Aid Type'**
  String get aidType;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @submissionDate.
  ///
  /// In en, this message translates to:
  /// **'Submission Date'**
  String get submissionDate;

  /// No description provided for @amountRiyal.
  ///
  /// In en, this message translates to:
  /// **'{amount} \$'**
  String amountRiyal(String amount);

  /// No description provided for @editRequest.
  ///
  /// In en, this message translates to:
  /// **'Edit Request'**
  String get editRequest;

  /// No description provided for @fundingProgress.
  ///
  /// In en, this message translates to:
  /// **'Funding Progress'**
  String get fundingProgress;

  /// No description provided for @fundingAmountOf.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total} SAR'**
  String fundingAmountOf(String current, String total);

  /// No description provided for @rejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Rejection Reason'**
  String get rejectionReason;

  /// No description provided for @noRejectionReason.
  ///
  /// In en, this message translates to:
  /// **'No rejection reason was provided'**
  String get noRejectionReason;

  /// No description provided for @requestWasCancelled.
  ///
  /// In en, this message translates to:
  /// **'This request has been cancelled'**
  String get requestWasCancelled;

  /// No description provided for @selfApplicant.
  ///
  /// In en, this message translates to:
  /// **'For myself'**
  String get selfApplicant;

  /// No description provided for @otherApplicant.
  ///
  /// In en, this message translates to:
  /// **'For someone else'**
  String get otherApplicant;

  /// No description provided for @whoIsRequestFor.
  ///
  /// In en, this message translates to:
  /// **'Who are you submitting this aid request for?'**
  String get whoIsRequestFor;

  /// No description provided for @chooseApplicantBeforeFilling.
  ///
  /// In en, this message translates to:
  /// **'Choose the applicant before filling in the information'**
  String get chooseApplicantBeforeFilling;

  /// No description provided for @loadingProfileData.
  ///
  /// In en, this message translates to:
  /// **'Loading profile information...'**
  String get loadingProfileData;

  /// No description provided for @profileAutoFilled.
  ///
  /// In en, this message translates to:
  /// **'Your account information was filled in automatically. You can edit any field before continuing.'**
  String get profileAutoFilled;

  /// No description provided for @profileAutoFillError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load profile information. You can try again or choose another person.'**
  String get profileAutoFillError;

  /// No description provided for @selectApplicantType.
  ///
  /// In en, this message translates to:
  /// **'Please choose who you want to submit the aid request for'**
  String get selectApplicantType;

  /// No description provided for @waitForProfileLoading.
  ///
  /// In en, this message translates to:
  /// **'Please wait until your information is loaded'**
  String get waitForProfileLoading;

  /// No description provided for @editApplicantInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit applicant information'**
  String get editApplicantInfo;

  /// No description provided for @personalStatus.
  ///
  /// In en, this message translates to:
  /// **'Personal status'**
  String get personalStatus;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact information'**
  String get contactInformation;

  /// No description provided for @applicantCreateDescription.
  ///
  /// In en, this message translates to:
  /// **'First choose who the request is for, then enter the applicant information accurately.'**
  String get applicantCreateDescription;

  /// No description provided for @applicantEditDescription.
  ///
  /// In en, this message translates to:
  /// **'You can edit the applicant information, then continue to the aid details to update them.'**
  String get applicantEditDescription;

  /// No description provided for @arabicAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address (Arabic)'**
  String get arabicAddressLabel;

  /// No description provided for @arabicAddressExample.
  ///
  /// In en, this message translates to:
  /// **'Example: Damascus - Mazzeh - Main Street'**
  String get arabicAddressExample;

  /// No description provided for @englishAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address (English)'**
  String get englishAddressLabel;

  /// No description provided for @englishAddressExample.
  ///
  /// In en, this message translates to:
  /// **'Example: Damascus - Al Mazzeh - Main Street'**
  String get englishAddressExample;

  /// No description provided for @arabicAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the address in Arabic'**
  String get arabicAddressRequired;

  /// No description provided for @arabicAddressOnly.
  ///
  /// In en, this message translates to:
  /// **'Please write the address in Arabic only'**
  String get arabicAddressOnly;

  /// No description provided for @englishAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the address in English'**
  String get englishAddressRequired;

  /// No description provided for @englishAddressOnly.
  ///
  /// In en, this message translates to:
  /// **'Please write the address in English only'**
  String get englishAddressOnly;

  /// No description provided for @phoneRequiredApplicant.
  ///
  /// In en, this message translates to:
  /// **'Please enter the phone number'**
  String get phoneRequiredApplicant;

  /// No description provided for @aidRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Aid request'**
  String get aidRequestTitle;

  /// No description provided for @editAidRequestTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit aid request'**
  String get editAidRequestTitle;

  /// No description provided for @aidRequestWithType.
  ///
  /// In en, this message translates to:
  /// **'{requestType} request'**
  String aidRequestWithType(String requestType);

  /// No description provided for @editAidRequestWithType.
  ///
  /// In en, this message translates to:
  /// **'Edit {requestType} request'**
  String editAidRequestWithType(String requestType);

  /// No description provided for @continueToRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Continue to request details'**
  String get continueToRequestDetails;

  /// No description provided for @continueToEditRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Continue to edit request details'**
  String get continueToEditRequestDetails;

  /// No description provided for @editEducationRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Education Request Details'**
  String get editEducationRequestDetails;

  /// No description provided for @academicAchievement.
  ///
  /// In en, this message translates to:
  /// **'Academic Achievement'**
  String get academicAchievement;

  /// No description provided for @highSchool.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get highSchool;

  /// No description provided for @diploma.
  ///
  /// In en, this message translates to:
  /// **'Diploma'**
  String get diploma;

  /// No description provided for @bachelor.
  ///
  /// In en, this message translates to:
  /// **'Bachelor\'s Degree'**
  String get bachelor;

  /// No description provided for @master.
  ///
  /// In en, this message translates to:
  /// **'Master\'s Degree'**
  String get master;

  /// No description provided for @thirdUniversityYear.
  ///
  /// In en, this message translates to:
  /// **'Third University Year'**
  String get thirdUniversityYear;

  /// No description provided for @fourthUniversityYear.
  ///
  /// In en, this message translates to:
  /// **'Fourth University Year'**
  String get fourthUniversityYear;

  /// No description provided for @fifthUniversityYear.
  ///
  /// In en, this message translates to:
  /// **'Fifth University Year'**
  String get fifthUniversityYear;

  /// No description provided for @sixthUniversityYear.
  ///
  /// In en, this message translates to:
  /// **'Sixth University Year'**
  String get sixthUniversityYear;

  /// No description provided for @institutionNameArabic.
  ///
  /// In en, this message translates to:
  /// **'School / University Name (Arabic)'**
  String get institutionNameArabic;

  /// No description provided for @institutionNameArabicHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Damascus University'**
  String get institutionNameArabicHint;

  /// No description provided for @institutionNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'School / University Name (English)'**
  String get institutionNameEnglish;

  /// No description provided for @institutionNameEnglishHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Damascus University'**
  String get institutionNameEnglishHint;

  /// No description provided for @educationDetailsArabic.
  ///
  /// In en, this message translates to:
  /// **'Education Request Details (Arabic)'**
  String get educationDetailsArabic;

  /// No description provided for @educationDetailsArabicHint.
  ///
  /// In en, this message translates to:
  /// **'Explain the educational need in Arabic...'**
  String get educationDetailsArabicHint;

  /// No description provided for @educationDetailsEnglish.
  ///
  /// In en, this message translates to:
  /// **'Education Request Details (English)'**
  String get educationDetailsEnglish;

  /// No description provided for @educationDetailsEnglishHint.
  ///
  /// In en, this message translates to:
  /// **'Explain the educational need in English...'**
  String get educationDetailsEnglishHint;

  /// No description provided for @educationDocuments.
  ///
  /// In en, this message translates to:
  /// **'Attach Educational Documents'**
  String get educationDocuments;

  /// No description provided for @addNewFiles.
  ///
  /// In en, this message translates to:
  /// **'Add New Files'**
  String get addNewFiles;

  /// No description provided for @addNewFilesDescription.
  ///
  /// In en, this message translates to:
  /// **'You can add new documents. Existing documents will remain unchanged.'**
  String get addNewFilesDescription;

  /// No description provided for @educationDocumentsDescription.
  ///
  /// In en, this message translates to:
  /// **'Please attach clear photos of documents or proof of enrollment.'**
  String get educationDocumentsDescription;

  /// No description provided for @newFiles.
  ///
  /// In en, this message translates to:
  /// **'New Files'**
  String get newFiles;

  /// No description provided for @attachedFiles.
  ///
  /// In en, this message translates to:
  /// **'Attached Files'**
  String get attachedFiles;

  /// No description provided for @existingAttachedFiles.
  ///
  /// In en, this message translates to:
  /// **'Currently Attached Files'**
  String get existingAttachedFiles;

  /// No description provided for @existingAttachment.
  ///
  /// In en, this message translates to:
  /// **'Previously Attached File'**
  String get existingAttachment;

  /// No description provided for @educationEditInfo.
  ///
  /// In en, this message translates to:
  /// **'The current request data has been loaded. Edit the fields you want to change, then save your changes.'**
  String get educationEditInfo;

  /// No description provided for @selectAcademicAchievement.
  ///
  /// In en, this message translates to:
  /// **'Please select the academic achievement'**
  String get selectAcademicAchievement;

  /// No description provided for @selectGradeOrYear.
  ///
  /// In en, this message translates to:
  /// **'Please select the grade or academic year'**
  String get selectGradeOrYear;

  /// No description provided for @educationDocumentRequired.
  ///
  /// In en, this message translates to:
  /// **'Please attach at least one document'**
  String get educationDocumentRequired;

  /// No description provided for @requestIdUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unable to determine the request ID to update'**
  String get requestIdUnavailable;

  /// No description provided for @schoolOrUniversityName.
  ///
  /// In en, this message translates to:
  /// **'School or university name'**
  String get schoolOrUniversityName;

  /// No description provided for @educationCaseDetails.
  ///
  /// In en, this message translates to:
  /// **'Education request details'**
  String get educationCaseDetails;

  /// No description provided for @enterFieldInArabic.
  ///
  /// In en, this message translates to:
  /// **'Please enter {fieldName} in Arabic'**
  String enterFieldInArabic(String fieldName);

  /// No description provided for @fieldArabicOnly.
  ///
  /// In en, this message translates to:
  /// **'Please write {fieldName} in Arabic only'**
  String fieldArabicOnly(String fieldName);

  /// No description provided for @enterFieldInEnglish.
  ///
  /// In en, this message translates to:
  /// **'Please enter {fieldName} in English'**
  String enterFieldInEnglish(String fieldName);

  /// No description provided for @fieldEnglishOnly.
  ///
  /// In en, this message translates to:
  /// **'Please write {fieldName} in English only'**
  String fieldEnglishOnly(String fieldName);

  /// No description provided for @editFoodRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Food Request Details'**
  String get editFoodRequestDetails;

  /// No description provided for @foodRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Food Request Details'**
  String get foodRequestDetails;

  /// No description provided for @foodAidType.
  ///
  /// In en, this message translates to:
  /// **'Required Food Assistance Type'**
  String get foodAidType;

  /// No description provided for @foodBasket.
  ///
  /// In en, this message translates to:
  /// **'Food Basket'**
  String get foodBasket;

  /// No description provided for @babyMilk.
  ///
  /// In en, this message translates to:
  /// **'Baby Milk'**
  String get babyMilk;

  /// No description provided for @foodDetailsArabic.
  ///
  /// In en, this message translates to:
  /// **'Food Request Details (Arabic)'**
  String get foodDetailsArabic;

  /// No description provided for @foodDetailsArabicHint.
  ///
  /// In en, this message translates to:
  /// **'Explain the type of need and the family\'s current situation in Arabic...'**
  String get foodDetailsArabicHint;

  /// No description provided for @foodDetailsEnglish.
  ///
  /// In en, this message translates to:
  /// **'Food Request Details (English)'**
  String get foodDetailsEnglish;

  /// No description provided for @foodDetailsEnglishHint.
  ///
  /// In en, this message translates to:
  /// **'Explain the family situation and food needs in English...'**
  String get foodDetailsEnglishHint;

  /// No description provided for @expectedFoodCost.
  ///
  /// In en, this message translates to:
  /// **'Expected Cost'**
  String get expectedFoodCost;

  /// No description provided for @supportingDocuments.
  ///
  /// In en, this message translates to:
  /// **'Attach Supporting Documents'**
  String get supportingDocuments;

  /// No description provided for @addNewDocuments.
  ///
  /// In en, this message translates to:
  /// **'Add New Documents'**
  String get addNewDocuments;

  /// No description provided for @foodNewDocumentsDescription.
  ///
  /// In en, this message translates to:
  /// **'New attachments are optional as long as the existing attachments remain available'**
  String get foodNewDocumentsDescription;

  /// No description provided for @foodDocumentsDescription.
  ///
  /// In en, this message translates to:
  /// **'Please attach any documents that support the food request'**
  String get foodDocumentsDescription;

  /// No description provided for @foodDecorativeMessage.
  ///
  /// In en, this message translates to:
  /// **'Together, we help provide food for every family in need'**
  String get foodDecorativeMessage;

  /// No description provided for @selectFoodAidType.
  ///
  /// In en, this message translates to:
  /// **'Please select the food assistance type'**
  String get selectFoodAidType;

  /// No description provided for @invalidIndividualsCount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number of individuals'**
  String get invalidIndividualsCount;

  /// No description provided for @foodDocumentRequired.
  ///
  /// In en, this message translates to:
  /// **'Please attach at least one document'**
  String get foodDocumentRequired;

  /// No description provided for @foodArabicDetailsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the request details in Arabic'**
  String get foodArabicDetailsRequired;

  /// No description provided for @foodArabicDetailsShort.
  ///
  /// In en, this message translates to:
  /// **'Please provide clearer details in Arabic'**
  String get foodArabicDetailsShort;

  /// No description provided for @foodArabicDetailsMustContainArabic.
  ///
  /// In en, this message translates to:
  /// **'The Arabic details must contain Arabic letters'**
  String get foodArabicDetailsMustContainArabic;

  /// No description provided for @foodArabicDetailsNoEnglish.
  ///
  /// In en, this message translates to:
  /// **'Please write the Arabic details without English letters'**
  String get foodArabicDetailsNoEnglish;

  /// No description provided for @foodEnglishDetailsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the request details in English'**
  String get foodEnglishDetailsRequired;

  /// No description provided for @foodEnglishDetailsShort.
  ///
  /// In en, this message translates to:
  /// **'Please provide clearer details in English'**
  String get foodEnglishDetailsShort;

  /// No description provided for @foodEnglishDetailsMustContainEnglish.
  ///
  /// In en, this message translates to:
  /// **'The English details must contain English letters'**
  String get foodEnglishDetailsMustContainEnglish;

  /// No description provided for @foodEnglishDetailsNoArabic.
  ///
  /// In en, this message translates to:
  /// **'Please write the English details without Arabic letters'**
  String get foodEnglishDetailsNoArabic;

  /// No description provided for @editHealthRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Health Request Details'**
  String get editHealthRequestDetails;

  /// No description provided for @healthDetailsArabic.
  ///
  /// In en, this message translates to:
  /// **'Health Details (Arabic)'**
  String get healthDetailsArabic;

  /// No description provided for @healthDetailsArabicHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the diagnosis and symptoms in Arabic...'**
  String get healthDetailsArabicHint;

  /// No description provided for @healthDetailsEnglish.
  ///
  /// In en, this message translates to:
  /// **'Health Details (English)'**
  String get healthDetailsEnglish;

  /// No description provided for @healthDetailsEnglishHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the diagnosis and symptoms in English...'**
  String get healthDetailsEnglishHint;

  /// No description provided for @addNewMedicalDocuments.
  ///
  /// In en, this message translates to:
  /// **'Add New Medical Reports or Prescriptions'**
  String get addNewMedicalDocuments;

  /// No description provided for @medicalNewDocumentsDescription.
  ///
  /// In en, this message translates to:
  /// **'New attachments are optional as long as the existing attachments remain available'**
  String get medicalNewDocumentsDescription;

  /// No description provided for @healthArabicDetailsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the health details in Arabic'**
  String get healthArabicDetailsRequired;

  /// No description provided for @healthArabicDetailsShort.
  ///
  /// In en, this message translates to:
  /// **'Please provide clearer health details in Arabic'**
  String get healthArabicDetailsShort;

  /// No description provided for @healthArabicDetailsMustContainArabic.
  ///
  /// In en, this message translates to:
  /// **'The Arabic details must contain Arabic letters'**
  String get healthArabicDetailsMustContainArabic;

  /// No description provided for @healthArabicDetailsNoEnglish.
  ///
  /// In en, this message translates to:
  /// **'Please write the Arabic details without English letters'**
  String get healthArabicDetailsNoEnglish;

  /// No description provided for @healthEnglishDetailsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the health details in English'**
  String get healthEnglishDetailsRequired;

  /// No description provided for @healthEnglishDetailsShort.
  ///
  /// In en, this message translates to:
  /// **'Please provide clearer health details in English'**
  String get healthEnglishDetailsShort;

  /// No description provided for @healthEnglishDetailsMustContainEnglish.
  ///
  /// In en, this message translates to:
  /// **'The English details must contain English letters'**
  String get healthEnglishDetailsMustContainEnglish;

  /// No description provided for @healthEnglishDetailsNoArabic.
  ///
  /// In en, this message translates to:
  /// **'Please write the English details without Arabic letters'**
  String get healthEnglishDetailsNoArabic;

  /// No description provided for @homeProvision.
  ///
  /// In en, this message translates to:
  /// **'Home Provision'**
  String get homeProvision;

  /// No description provided for @rentAssistance.
  ///
  /// In en, this message translates to:
  /// **'Rent Assistance'**
  String get rentAssistance;

  /// No description provided for @homeRepairs.
  ///
  /// In en, this message translates to:
  /// **'Home Repairs'**
  String get homeRepairs;

  /// No description provided for @editHousingRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Housing Request Details'**
  String get editHousingRequestDetails;

  /// No description provided for @housingAidType.
  ///
  /// In en, this message translates to:
  /// **'Required Housing Assistance Type'**
  String get housingAidType;

  /// No description provided for @chooseHousingAidTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Choose the housing assistance type to display the required fields'**
  String get chooseHousingAidTypeHint;

  /// No description provided for @housingEditInfo.
  ///
  /// In en, this message translates to:
  /// **'The current request data has been loaded. The housing assistance type is fixed, and you can edit the remaining fields before saving your changes.'**
  String get housingEditInfo;

  /// No description provided for @currentResidenceArabic.
  ///
  /// In en, this message translates to:
  /// **'Current Residence (Arabic)'**
  String get currentResidenceArabic;

  /// No description provided for @currentResidenceArabicHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Damascus - Mezzeh - temporary housing'**
  String get currentResidenceArabicHint;

  /// No description provided for @currentResidenceEnglish.
  ///
  /// In en, this message translates to:
  /// **'Current Residence (English)'**
  String get currentResidenceEnglish;

  /// No description provided for @currentResidenceEnglishHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Damascus - Mezzeh - temporary housing'**
  String get currentResidenceEnglishHint;

  /// No description provided for @housingSupportReasonArabic.
  ///
  /// In en, this message translates to:
  /// **'Reason for Requesting Housing (Arabic)'**
  String get housingSupportReasonArabic;

  /// No description provided for @housingSupportReasonArabicHint.
  ///
  /// In en, this message translates to:
  /// **'Explain why housing assistance is needed in Arabic...'**
  String get housingSupportReasonArabicHint;

  /// No description provided for @housingSupportReasonEnglish.
  ///
  /// In en, this message translates to:
  /// **'Reason for Requesting Housing (English)'**
  String get housingSupportReasonEnglish;

  /// No description provided for @housingSupportReasonEnglishHint.
  ///
  /// In en, this message translates to:
  /// **'Explain why housing assistance is needed in English...'**
  String get housingSupportReasonEnglishHint;

  /// No description provided for @requestedHousingSpecsArabic.
  ///
  /// In en, this message translates to:
  /// **'Required Housing Specifications (Arabic)'**
  String get requestedHousingSpecsArabic;

  /// No description provided for @requestedHousingSpecsArabicHint.
  ///
  /// In en, this message translates to:
  /// **'Example: two rooms, close to school...'**
  String get requestedHousingSpecsArabicHint;

  /// No description provided for @requestedHousingSpecsEnglish.
  ///
  /// In en, this message translates to:
  /// **'Required Housing Specifications (English)'**
  String get requestedHousingSpecsEnglish;

  /// No description provided for @requestedHousingSpecsEnglishHint.
  ///
  /// In en, this message translates to:
  /// **'Example: two rooms, close to school...'**
  String get requestedHousingSpecsEnglishHint;

  /// No description provided for @currentHousingSituation.
  ///
  /// In en, this message translates to:
  /// **'Current Housing Situation'**
  String get currentHousingSituation;

  /// No description provided for @currentHousingSituationArabic.
  ///
  /// In en, this message translates to:
  /// **'Current Housing Situation (Arabic)'**
  String get currentHousingSituationArabic;

  /// No description provided for @currentHousingSituationArabicHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the damage and required repairs in Arabic...'**
  String get currentHousingSituationArabicHint;

  /// No description provided for @currentHousingSituationEnglish.
  ///
  /// In en, this message translates to:
  /// **'Current Housing Situation (English)'**
  String get currentHousingSituationEnglish;

  /// No description provided for @currentHousingSituationEnglishHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the damage and required repairs in English...'**
  String get currentHousingSituationEnglishHint;

  /// No description provided for @housingDetailsArabic.
  ///
  /// In en, this message translates to:
  /// **'Housing Request Details (Arabic)'**
  String get housingDetailsArabic;

  /// No description provided for @housingDetailsArabicHint.
  ///
  /// In en, this message translates to:
  /// **'Explain the housing situation and need in Arabic...'**
  String get housingDetailsArabicHint;

  /// No description provided for @housingDetailsEnglish.
  ///
  /// In en, this message translates to:
  /// **'Housing Request Details (English)'**
  String get housingDetailsEnglish;

  /// No description provided for @housingDetailsEnglishHint.
  ///
  /// In en, this message translates to:
  /// **'Explain the housing situation and need in English...'**
  String get housingDetailsEnglishHint;

  /// No description provided for @expectedHousingCost.
  ///
  /// In en, this message translates to:
  /// **'Expected Cost'**
  String get expectedHousingCost;

  /// No description provided for @selectHousingAidType.
  ///
  /// In en, this message translates to:
  /// **'Please select the housing assistance type'**
  String get selectHousingAidType;

  /// No description provided for @validCurrentRent.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid current rent amount'**
  String get validCurrentRent;

  /// No description provided for @housingDocumentRequired.
  ///
  /// In en, this message translates to:
  /// **'Please attach at least one document'**
  String get housingDocumentRequired;

  /// No description provided for @editSmallProjectRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Small Project Details'**
  String get editSmallProjectRequestDetails;

  /// No description provided for @smallProjectRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'Small Project Details'**
  String get smallProjectRequestDetails;

  /// No description provided for @projectInformation.
  ///
  /// In en, this message translates to:
  /// **'Project Information'**
  String get projectInformation;

  /// No description provided for @projectNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Project Name (Arabic)'**
  String get projectNameArabic;

  /// No description provided for @projectNameArabicHint.
  ///
  /// In en, this message translates to:
  /// **'Example: مخبز منزلي'**
  String get projectNameArabicHint;

  /// No description provided for @projectNameEnglish.
  ///
  /// In en, this message translates to:
  /// **'Project Name (English)'**
  String get projectNameEnglish;

  /// No description provided for @projectNameEnglishHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Home bakery'**
  String get projectNameEnglishHint;

  /// No description provided for @projectCategoryArabic.
  ///
  /// In en, this message translates to:
  /// **'Project Category (Arabic)'**
  String get projectCategoryArabic;

  /// No description provided for @projectCategoryArabicHint.
  ///
  /// In en, this message translates to:
  /// **'Example: إنتاج غذائي'**
  String get projectCategoryArabicHint;

  /// No description provided for @projectCategoryEnglish.
  ///
  /// In en, this message translates to:
  /// **'Project Category (English)'**
  String get projectCategoryEnglish;

  /// No description provided for @projectCategoryEnglishHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Food production'**
  String get projectCategoryEnglishHint;

  /// No description provided for @numberOfPeopleSupported.
  ///
  /// In en, this message translates to:
  /// **'Expected Number of People Supported'**
  String get numberOfPeopleSupported;

  /// No description provided for @numberOfPeopleSupportedHint.
  ///
  /// In en, this message translates to:
  /// **'Example: 3'**
  String get numberOfPeopleSupportedHint;

  /// No description provided for @projectDetailsArabic.
  ///
  /// In en, this message translates to:
  /// **'Project Details (Arabic)'**
  String get projectDetailsArabic;

  /// No description provided for @projectDetailsArabicHint.
  ///
  /// In en, this message translates to:
  /// **'Explain the project idea, goals, and expected benefit in Arabic...'**
  String get projectDetailsArabicHint;

  /// No description provided for @projectDetailsEnglish.
  ///
  /// In en, this message translates to:
  /// **'Project Details (English)'**
  String get projectDetailsEnglish;

  /// No description provided for @projectDetailsEnglishHint.
  ///
  /// In en, this message translates to:
  /// **'Explain the project idea, goals, and expected benefit in English...'**
  String get projectDetailsEnglishHint;

  /// No description provided for @expectedProjectCost.
  ///
  /// In en, this message translates to:
  /// **'Expected Cost'**
  String get expectedProjectCost;

  /// No description provided for @smallProjectNewDocumentsDescription.
  ///
  /// In en, this message translates to:
  /// **'New attachments are optional as long as the existing attachments remain available'**
  String get smallProjectNewDocumentsDescription;

  /// No description provided for @smallProjectDocumentsDescription.
  ///
  /// In en, this message translates to:
  /// **'Feasibility study, photos, invoices, or any documents supporting the project'**
  String get smallProjectDocumentsDescription;

  /// No description provided for @smallProjectDecorativeMessage.
  ///
  /// In en, this message translates to:
  /// **'We support small projects to help families build a sustainable income'**
  String get smallProjectDecorativeMessage;

  /// No description provided for @smallProjectEditInfo.
  ///
  /// In en, this message translates to:
  /// **'The current request data has been loaded. Edit the fields you want to change, then save your changes.'**
  String get smallProjectEditInfo;

  /// No description provided for @projectNameArabicRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the project name in Arabic'**
  String get projectNameArabicRequired;

  /// No description provided for @projectNameArabicShort.
  ///
  /// In en, this message translates to:
  /// **'The Arabic project name is too short'**
  String get projectNameArabicShort;

  /// No description provided for @projectNameEnglishRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the project name in English'**
  String get projectNameEnglishRequired;

  /// No description provided for @projectNameEnglishShort.
  ///
  /// In en, this message translates to:
  /// **'The English project name is too short'**
  String get projectNameEnglishShort;

  /// No description provided for @projectCategoryArabicRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the project category in Arabic'**
  String get projectCategoryArabicRequired;

  /// No description provided for @projectCategoryArabicShort.
  ///
  /// In en, this message translates to:
  /// **'The Arabic project category is too short'**
  String get projectCategoryArabicShort;

  /// No description provided for @projectCategoryEnglishRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the project category in English'**
  String get projectCategoryEnglishRequired;

  /// No description provided for @projectCategoryEnglishShort.
  ///
  /// In en, this message translates to:
  /// **'The English project category is too short'**
  String get projectCategoryEnglishShort;

  /// No description provided for @validSupportedPeopleCount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number of people to be supported'**
  String get validSupportedPeopleCount;

  /// No description provided for @projectDetailsArabicRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the project details in Arabic'**
  String get projectDetailsArabicRequired;

  /// No description provided for @projectDetailsArabicShort.
  ///
  /// In en, this message translates to:
  /// **'Please provide clearer project details in Arabic'**
  String get projectDetailsArabicShort;

  /// No description provided for @projectDetailsEnglishRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the project details in English'**
  String get projectDetailsEnglishRequired;

  /// No description provided for @projectDetailsEnglishShort.
  ///
  /// In en, this message translates to:
  /// **'Please provide clearer project details in English'**
  String get projectDetailsEnglishShort;

  /// No description provided for @smallProjectDocumentRequired.
  ///
  /// In en, this message translates to:
  /// **'Please attach at least one document'**
  String get smallProjectDocumentRequired;

  /// No description provided for @smallProjectFilesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The selected files were already added or could not be accessed'**
  String get smallProjectFilesUnavailable;

  /// No description provided for @arabicFieldMustContainArabic.
  ///
  /// In en, this message translates to:
  /// **'The Arabic field must contain Arabic letters'**
  String get arabicFieldMustContainArabic;

  /// No description provided for @arabicFieldNoEnglish.
  ///
  /// In en, this message translates to:
  /// **'Please write the Arabic field without English letters'**
  String get arabicFieldNoEnglish;

  /// No description provided for @englishFieldMustContainEnglish.
  ///
  /// In en, this message translates to:
  /// **'The English field must contain English letters'**
  String get englishFieldMustContainEnglish;

  /// No description provided for @englishFieldNoArabic.
  ///
  /// In en, this message translates to:
  /// **'Please write the English field without Arabic letters'**
  String get englishFieldNoArabic;

  /// No description provided for @loadingRequestData.
  ///
  /// In en, this message translates to:
  /// **'Loading request data...'**
  String get loadingRequestData;

  /// No description provided for @pleaseWaitMoment.
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment'**
  String get pleaseWaitMoment;

  /// No description provided for @requestDetailsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load request details'**
  String get requestDetailsLoadFailed;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @zakatCalculator.
  ///
  /// In en, this message translates to:
  /// **'Zakat Calculator'**
  String get zakatCalculator;

  /// No description provided for @zakatConditionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Conditions for Zakat'**
  String get zakatConditionsTitle;

  /// No description provided for @zakatConditionNisab.
  ///
  /// In en, this message translates to:
  /// **'The wealth must reach the required Nisab threshold.'**
  String get zakatConditionNisab;

  /// No description provided for @zakatConditionOwnership.
  ///
  /// In en, this message translates to:
  /// **'The wealth must be fully owned by its owner.'**
  String get zakatConditionOwnership;

  /// No description provided for @zakatConditionYear.
  ///
  /// In en, this message translates to:
  /// **'A full lunar year must pass for wealth that requires Hawl.'**
  String get zakatConditionYear;

  /// No description provided for @zakatCalculatorDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This calculator is for guidance only. For special cases, consult a qualified Islamic authority.'**
  String get zakatCalculatorDisclaimer;

  /// No description provided for @chooseZakatType.
  ///
  /// In en, this message translates to:
  /// **'Choose Zakat Type'**
  String get chooseZakatType;

  /// No description provided for @chooseZakatTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Choose the type of Zakat you want to calculate'**
  String get chooseZakatTypeHint;

  /// No description provided for @zakatMoney.
  ///
  /// In en, this message translates to:
  /// **'Money Zakat'**
  String get zakatMoney;

  /// No description provided for @zakatMoneySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Calculate Zakat on cash and money'**
  String get zakatMoneySubtitle;

  /// No description provided for @zakatGold.
  ///
  /// In en, this message translates to:
  /// **'Gold Zakat'**
  String get zakatGold;

  /// No description provided for @zakatGoldSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Calculate Zakat based on gold weight in grams'**
  String get zakatGoldSubtitle;

  /// No description provided for @zakatSilver.
  ///
  /// In en, this message translates to:
  /// **'Silver Zakat'**
  String get zakatSilver;

  /// No description provided for @zakatSilverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Calculate Zakat based on silver weight in grams'**
  String get zakatSilverSubtitle;

  /// No description provided for @calculateZakat.
  ///
  /// In en, this message translates to:
  /// **'Calculate Zakat'**
  String get calculateZakat;

  /// No description provided for @zakatMoneyInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Money Amount'**
  String get zakatMoneyInputTitle;

  /// No description provided for @zakatMoneyInputDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount of money you own and today\'s gold gram price to check the Nisab threshold.'**
  String get zakatMoneyInputDescription;

  /// No description provided for @zakatGoldInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Gold Weight in Grams'**
  String get zakatGoldInputTitle;

  /// No description provided for @zakatGoldInputDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the weight of gold you own and today\'s gold gram price.'**
  String get zakatGoldInputDescription;

  /// No description provided for @zakatSilverInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Silver Weight in Grams'**
  String get zakatSilverInputTitle;

  /// No description provided for @zakatSilverInputDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the weight of silver you own and today\'s silver gram price.'**
  String get zakatSilverInputDescription;

  /// No description provided for @moneyAmount.
  ///
  /// In en, this message translates to:
  /// **'Money Amount'**
  String get moneyAmount;

  /// No description provided for @goldWeight.
  ///
  /// In en, this message translates to:
  /// **'Gold Weight in Grams'**
  String get goldWeight;

  /// No description provided for @silverWeight.
  ///
  /// In en, this message translates to:
  /// **'Silver Weight in Grams'**
  String get silverWeight;

  /// No description provided for @goldGramPriceToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Gold Gram Price'**
  String get goldGramPriceToday;

  /// No description provided for @silverGramPriceToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Silver Gram Price'**
  String get silverGramPriceToday;

  /// No description provided for @zakatValidAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid value greater than zero'**
  String get zakatValidAmountRequired;

  /// No description provided for @zakatValidGramPriceRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid gram price greater than zero'**
  String get zakatValidGramPriceRequired;

  /// No description provided for @zakatDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Zakat is Due'**
  String get zakatDueTitle;

  /// No description provided for @zakatNotDueTitle.
  ///
  /// In en, this message translates to:
  /// **'Zakat is Not Due'**
  String get zakatNotDueTitle;

  /// No description provided for @zakatTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Zakat Type'**
  String get zakatTypeLabel;

  /// No description provided for @zakatAssetValue.
  ///
  /// In en, this message translates to:
  /// **'Asset Value'**
  String get zakatAssetValue;

  /// No description provided for @zakatNisabValue.
  ///
  /// In en, this message translates to:
  /// **'Nisab Value'**
  String get zakatNisabValue;

  /// No description provided for @zakatRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Zakat Rate'**
  String get zakatRateLabel;

  /// No description provided for @zakatDueAmount.
  ///
  /// In en, this message translates to:
  /// **'Zakat Due'**
  String get zakatDueAmount;

  /// No description provided for @calculateAgain.
  ///
  /// In en, this message translates to:
  /// **'Calculate Again'**
  String get calculateAgain;

  /// No description provided for @donateZakatAmount.
  ///
  /// In en, this message translates to:
  /// **'Donate Zakat amount'**
  String get donateZakatAmount;

  /// No description provided for @zakatDonationSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose donation fund'**
  String get zakatDonationSheetTitle;

  /// No description provided for @zakatDonationAmount.
  ///
  /// In en, this message translates to:
  /// **'Zakat amount'**
  String get zakatDonationAmount;

  /// No description provided for @zakatOrphanSupportFundOption.
  ///
  /// In en, this message translates to:
  /// **'Orphan Support Fund'**
  String get zakatOrphanSupportFundOption;

  /// No description provided for @zakatQuickDonationFundOption.
  ///
  /// In en, this message translates to:
  /// **'Quick Donation Fund'**
  String get zakatQuickDonationFundOption;
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
