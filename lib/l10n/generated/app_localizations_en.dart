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
  String get email => 'Email';

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
  String get completed => 'Completed';

  @override
  String get noCompletedAidCases => 'No completed aid cases';

  @override
  String get aboutAtharAssociation => 'About Athar Association';

  @override
  String get aboutAtharAssociationDescription =>
      'Athar Association supports orphans and families in need through programs and initiatives that aim to improve their lives.';

  @override
  String get female => 'Female';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get selectDateOfBirth => 'Select date of birth';

  @override
  String get completedAidCases => 'Completed Cases';

  @override
  String get dateOfBirthHint => 'YYYY-MM-DD';

  @override
  String get dateOfBirthRequired => 'Please select your date of birth';

  @override
  String get invalidDateOfBirth => 'The date of birth is invalid';

  @override
  String get dateOfBirthFutureInvalid =>
      'Date of birth cannot be in the future';

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
  String get socialStatus => 'Social Status';

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
  String get employmentStatus => 'Employment Status';

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
  String get welcomeBackName => 'Welcome back, Sarah';

  @override
  String get welcomeComma => 'Welcome,';

  @override
  String get sampleUserSarah => 'Sarah';

  @override
  String get specialAppeal => 'Special appeal';

  @override
  String get sponsorAnOrphanToday => 'Sponsor an orphan\ntoday';

  @override
  String get sponsorAnOrphanDescription =>
      'Change a child\'s life with monthly support, education, and healthcare.';

  @override
  String get learnMore => 'Learn more';

  @override
  String get supportAreas => 'Support areas';

  @override
  String get viewAll => 'View all';

  @override
  String get smallProjects => 'Small projects';

  @override
  String get education => 'Education';

  @override
  String get orphanFund => 'Orphan fund';

  @override
  String get health => 'Health';

  @override
  String get food => 'Food';

  @override
  String get title => 'My Donations';

  @override
  String get total => 'Total Donations';

  @override
  String get all => 'All';

  @override
  String get retry => 'Retry';

  @override
  String get totalDonaited => 'Total Donations';

  @override
  String get sponsorship => 'Sponsorship';

  @override
  String get walletTopUp => 'Wallet Top-up';

  @override
  String get walletBalance => 'Wallet Balance';

  @override
  String get operation => 'Transaction';

  @override
  String get empty => 'No transactions';

  @override
  String get sponsor => 'sponsor';

  @override
  String get loadError => 'Failed to load donation history';

  @override
  String get housing => 'Housing';

  @override
  String get loggingOut => 'Logging out...';

  @override
  String get followDonations => 'Follow your requests and donations';

  @override
  String get changeAppAppearance => 'Change app appearance';

  @override
  String get languageAndAppearance => 'Language and appearance';

  @override
  String get communityInitiatives => 'Community initiatives';

  @override
  String get communityInitiativesDescription =>
      'Work with local leaders to build a sustainable future through collaborative giving.';

  @override
  String get explorePortal => 'Explore portal';

  @override
  String get totalImpact => 'Total impact';

  @override
  String get livesImpacted => 'Lives impacted';

  @override
  String get sampleChildrenCount => '12 children';

  @override
  String get menu => 'Menu';

  @override
  String get impact => 'Impact';

  @override
  String get home => 'Home';

  @override
  String get wallet => 'Wallet';

  @override
  String get sponsorships => 'Sponsorships';

  @override
  String get trackRequest => 'Track request';

  @override
  String get account => 'Account';

  @override
  String get settings => 'Settings';

  @override
  String get newAidRequest => 'Submit a new aid request';

  @override
  String get healthRequest => 'Health request';

  @override
  String get healthRequestSubtitle => 'Treatment and medicine';

  @override
  String get foodRequest => 'Food request';

  @override
  String get foodRequestSubtitle => 'Food baskets';

  @override
  String get housingRequest => 'Housing request';

  @override
  String get housingRequestSubtitle => 'Home improvement or rent';

  @override
  String get educationRequest => 'Education request';

  @override
  String get educationRequestSubtitle => 'Fees and books';

  @override
  String get projectSupport => 'Project support';

  @override
  String get projectSupportSubtitle => 'Funding and development';

  @override
  String get completedProjectsTitle => 'Projects completed by the association';

  @override
  String get waterWellProject => 'Water well drilling';

  @override
  String get schoolBuildingProject => 'School building';

  @override
  String get medicalComplexProject => 'Medical complex';

  @override
  String get aboutAssociationTitle =>
      'Al Athar Association... Every Act of Giving Leaves an Impact';

  @override
  String get aboutAssociationDescription =>
      'At our association, we strive to provide comprehensive support to people in need and build a future shaped by social solidarity and mercy through innovative development and relief programs.';

  @override
  String get ourVision => 'Our vision';

  @override
  String get ourVisionDescription =>
      'We aim to be a leading association in humanitarian work and help build a caring community where every person receives the support and care they need.';

  @override
  String get ourMission => 'Our mission';

  @override
  String get ourMissionDescription =>
      'We provide humanitarian aid and services efficiently and transparently, reaching the most vulnerable groups through development initiatives that create positive and lasting impact.';

  @override
  String get beneficiariesNeedSupport => 'People in need of support';

  @override
  String get individual => 'person';

  @override
  String get individuals => 'people';

  @override
  String get currencyRiyal => 'Riyal';

  @override
  String get currentStep => 'Current step';

  @override
  String get lastStep => 'Final step';

  @override
  String stepOfTotal(int currentStep, int totalSteps) {
    return '$currentStep of $totalSteps';
  }

  @override
  String get dataPrivacy => 'Data privacy';

  @override
  String get dataPrivacyDescription =>
      'All uploaded data is handled with full confidentiality and privacy according to security standards.';

  @override
  String get whyWeAskData => 'Why do we ask for this information?';

  @override
  String get whyWeAskDataDescription =>
      'We care about accurate data to ensure aid reaches eligible people as quickly as possible and with dignity.';

  @override
  String get applicantInfoTitle => 'Applicant information';

  @override
  String get fatherName => 'Father\'s name';

  @override
  String get fatherNameHint => 'Example: Ahmad';

  @override
  String get familyName => 'Family name';

  @override
  String get familyNameHint => 'Example: Darwish';

  @override
  String get age => 'Age';

  @override
  String get ageHint => 'Example: 35';

  @override
  String get address => 'Address';

  @override
  String get addressHint => 'Example: Damascus - Mazzeh';

  @override
  String get jobStatus => 'Employment status';

  @override
  String get working => 'Working';

  @override
  String get notWorking => 'Unemployed';

  @override
  String get continueButton => 'Continue';

  @override
  String get fillAllDataCorrectly =>
      'Please make sure all information is filled correctly';

  @override
  String get selectGender => 'Please select gender';

  @override
  String get selectSocialStatus => 'Please select marital status';

  @override
  String get selectJobStatus => 'Please select employment status';

  @override
  String get invalidAge => 'Please enter a valid age';

  @override
  String get unsupportedRequestType =>
      'This request type is not currently supported';

  @override
  String requiredField(String fieldName) {
    return 'Please enter $fieldName';
  }

  @override
  String fieldTooShort(String fieldName) {
    return '$fieldName is too short';
  }

  @override
  String get ageRequired => 'Please enter age';

  @override
  String get ageNumbersOnly => 'Please enter age using numbers';

  @override
  String get phoneValidRequired => 'Please enter a valid phone number';

  @override
  String get housingRequestDetails => 'Housing request details';

  @override
  String get currentHousingStatus => 'Current housing status';

  @override
  String get ownedHousing => 'Owned';

  @override
  String get rentedHousing => 'Rented';

  @override
  String get noHousing => 'No housing';

  @override
  String get currentRentValue => 'Current rent value, if any';

  @override
  String get currentResidenceDetails => 'Current residence details';

  @override
  String get currentResidenceHint => 'City, neighborhood, street name';

  @override
  String get housingSupportReason =>
      'Reason for no shelter or need for support';

  @override
  String get housingSupportReasonHint =>
      'Please write a detailed explanation of the case...';

  @override
  String get requestedHousingSpecs =>
      'Requested or current housing specifications';

  @override
  String get requestedHousingSpecsHint => 'Rooms count, floor, nearby services';

  @override
  String get attachProofDocuments => 'Attach proof documents';

  @override
  String get housingDocumentsDescription =>
      'Lease contract, current housing photos, or any documents supporting the request (JPG, PDF)';

  @override
  String get housingQuote =>
      '\"We strive to provide a safe and dignified environment for every family\"';

  @override
  String get submitRequestForReview => 'Submit request for review';

  @override
  String get healthRequestDetails => 'Health request details';

  @override
  String get medicalAidTypeRequired => 'Please select the type of medical aid';

  @override
  String get healthDescriptionRequired =>
      'Please enter a health condition description';

  @override
  String get validCostRequired => 'Please enter a valid cost';

  @override
  String get medicalAttachmentRequired =>
      'Please attach at least one report or prescription';

  @override
  String get duplicateFiles => 'Selected files were already added';

  @override
  String get filesAccessFailed => 'Could not access the selected files';

  @override
  String get fileSelectionFailed => 'Could not select files. Please try again.';

  @override
  String get medicalAidType => 'Required medical aid type';

  @override
  String get medicineInsurance => 'Medicine Coverage';

  @override
  String get surgery => 'Surgery';

  @override
  String get medicalDevices => 'Medical Devices';

  @override
  String get healthDescription => 'Detailed health condition description';

  @override
  String get healthDescriptionHint =>
      'Please mention the diagnosis and symptoms clearly...';

  @override
  String get treatmentExpectedCost => 'Expected treatment cost';

  @override
  String get medicalReportsUpload =>
      'Attach medical reports and official prescriptions';

  @override
  String get uploadFilesOrCapture => 'Upload files or take photos';

  @override
  String get medicalReportsUploadDescription =>
      'Please attach clear photos of reports and prescriptions';

  @override
  String get deleteAttachment => 'Delete attachment';

  @override
  String get fileReadyForUpload => 'File ready for upload';

  @override
  String get educationRequestDetails => 'Education request details';

  @override
  String get educationLevel => 'Education level';

  @override
  String get schoolLevel => 'School';

  @override
  String get universityLevel => 'University';

  @override
  String get institutionName => 'School / university name';

  @override
  String get institutionNameHint => 'Enter the name here...';

  @override
  String get gradeOrYear => 'Grade / academic year';

  @override
  String get selectGradeHint => 'Select grade...';

  @override
  String get requestedAssistanceType => 'Requested assistance type';

  @override
  String get schoolClothes => 'School clothes';

  @override
  String get studySupplies => 'Study supplies';

  @override
  String get universityFees => 'University fees';

  @override
  String get other => 'Other';

  @override
  String get primaryStage => 'Primary stage';

  @override
  String get middleStage => 'Middle stage';

  @override
  String get secondaryStage => 'Secondary stage';

  @override
  String get firstUniversityYear => 'First university year';

  @override
  String get secondUniversityYear => 'Second university year';

  @override
  String get caseDescription => 'Detailed case description';

  @override
  String get educationDescriptionHint =>
      'Tell us about your educational need so we can provide the best support...';

  @override
  String get expectedTotalCost => 'Expected total cost';

  @override
  String get profileTitle => 'My Account';

  @override
  String ageWithYears(int years) {
    return '$years years';
  }

  @override
  String get workStatus => 'Work status';

  @override
  String get employedStatus => 'Employed';

  @override
  String get unemployedStatus => 'Unemployed';

  @override
  String get caseDetails => 'Case details';

  @override
  String get activeCases => 'Active cases';

  @override
  String availableCases(int count) {
    return '$count available';
  }

  @override
  String get urgent => 'Urgent';

  @override
  String supportCategoryDescription(String category) {
    return 'Support urgent needs and development campaigns for $category.';
  }

  @override
  String remainingAmount(String amount) {
    return 'Remaining: $amount SAR';
  }

  @override
  String get collected => 'Collected';

  @override
  String get target => 'Target';

  @override
  String get requiredAmount => 'Required amount';

  @override
  String get amountCollected => 'Amount collected';

  @override
  String get amountRemaining => 'Remaining';

  @override
  String completionPercentage(num percentage) {
    return 'Completion rate $percentage%';
  }

  @override
  String get donateNow => 'Donate now';

  @override
  String get donationCheckoutTitle => 'Complete donation';

  @override
  String get aidRequestDonation => 'Aid request donation';

  @override
  String get donationAmountUsd => 'Donation amount in USD';

  @override
  String get donationAmountHint => 'Example: 25';

  @override
  String get invalidDonationAmount =>
      'Enter a positive amount that does not exceed the remaining amount.';

  @override
  String get completeDonation => 'Complete secure payment';

  @override
  String get stripePaymentSheetNotice =>
      'Card details are entered only in Stripe\'s secure payment sheet.';

  @override
  String get paymentCompletedRefresh =>
      'Payment completed. Refreshing request details...';

  @override
  String get paymentCanceled => 'Payment was canceled.';

  @override
  String get stripePaymentError =>
      'Stripe could not complete the payment. Please try again.';

  @override
  String get stripePublishableKeyMissing =>
      'Stripe publishable key is missing. Run the Flutter with Stripe launch configuration.';

  @override
  String get stripePublishableKeyInvalid =>
      'Stripe publishable key must start with pk_test_.';

  @override
  String get paymentAmountMustBePositive =>
      'The donation amount must be greater than zero.';

  @override
  String get paymentAmountExceedsRemaining =>
      'The donation amount cannot exceed the remaining amount.';

  @override
  String get currentWalletBalance => 'Current wallet balance';

  @override
  String get topUpWallet => 'Top up wallet';

  @override
  String get walletBalanceLoading => 'Loading balance...';

  @override
  String get couldNotLoadWalletBalance => 'Could not load balance';

  @override
  String get walletBalanceUnavailable => 'Balance is currently unavailable';

  @override
  String get mySponsorships => 'My sponsorships';

  @override
  String get manageCurrentSponsoredOrphans =>
      'Manage currently sponsored orphans';

  @override
  String get addNewSponsorship => 'Add a new sponsorship';

  @override
  String get currentSponsorships => 'Current sponsorships';

  @override
  String get overview => 'Overview';

  @override
  String get sponsoredChildrenCount => 'Currently sponsored children';

  @override
  String sponsoredChildrenTotal(int count) {
    return '$count';
  }

  @override
  String get sponsoredList => 'Sponsored list';

  @override
  String get noSponsorshipsForStatus => 'No sponsorships with this status';

  @override
  String get sponsorshipUnderReview => 'Sponsorship under review';

  @override
  String get filterSponsorships => 'Filter sponsorships';

  @override
  String get allSponsorships => 'All sponsorships';

  @override
  String get activeStatus => 'Active';

  @override
  String get sponsorshipsPageDescription =>
      'Manage your sponsorships and support children';

  @override
  String get active => 'Active';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get myAccount => 'My Account';

  @override
  String get donor => 'Donor';

  @override
  String get unspecified => 'Unspecified';

  @override
  String get myDonations => 'My Donations';

  @override
  String get myDonationsSubtitle => 'Track your requests and donations';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get appearanceSubtitle => 'Change app appearance';

  @override
  String get logout => 'Log out';

  @override
  String get logoutLoading => 'Logging out...';

  @override
  String get logoutConfirmation => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get logoutError => 'An error occurred while logging out';

  @override
  String get availableForSponsorship => 'Available for sponsorship';

  @override
  String get supportAChild => 'Sponsor a child';

  @override
  String get startNewSponsorshipDescription =>
      'Start a new sponsorship and support a child';

  @override
  String get chooseOrphanAndStartSponsorship =>
      'Choose a child and start a sponsorship request';

  @override
  String get walletBalanceUsedForSponsorship =>
      'Your wallet balance is used when you submit a sponsorship request';

  @override
  String get sponsorshipWalletEmptyTitle => 'Wallet Empty';

  @override
  String get sponsorshipWalletEmptyMessage =>
      'You cannot submit a sponsorship request because your wallet is empty. Please top up your wallet and try again.';

  @override
  String get givingImpactDescription =>
      'Educational meals were provided this month thanks to your giving';

  @override
  String get newSponsorshipRequest => 'New sponsorship request';

  @override
  String get changeChildLife => 'Help change a child\'s life';

  @override
  String get completeTrust => 'Complete trust';

  @override
  String get completeTrustDescription =>
      'All data and information are handled with the highest privacy and security standards according to Sharia guidelines.';

  @override
  String get sponsorshipTermsTitle => 'Sponsorship terms and conditions';

  @override
  String get sponsorshipTermWalletBalance =>
      'The wallet must have enough balance to cover 4 months of sponsorship in advance, with the sponsorship amount deducted automatically each month.';

  @override
  String get sponsorshipTermReservedBalance =>
      'Once the sponsorship balance is reserved in advance for the specified orphan\'s expenses, it may not be used for other purposes.';

  @override
  String get sponsorshipTermLowBalance =>
      'The sponsorship is cancelled automatically if the balance drops below two months\' value without compensating the concerned amount.';

  @override
  String get sponsorshipTermOrphanSelection =>
      'The orphan is selected by management based on need and priority lists to ensure fairness and cover the most affected cases.';

  @override
  String get sponsorshipTermFilesAccess =>
      'The orphan profile and periodic reports are fully available only through the account dashboard after the request is approved.';

  @override
  String get acceptSponsorshipTerms => 'Confirm and accept terms';

  @override
  String get orphanSponsorshipVirtue => 'The virtue of sponsoring orphans';

  @override
  String get orphanSponsorshipHadith =>
      'Sahl ibn Sa\'d, may Allah be pleased with him, reported that the Messenger of Allah said: \"I and the sponsor of an orphan will be in Paradise like this,\" and he gestured with his index and middle fingers, separating them slightly.';

  @override
  String get narratedByBukhari => 'Narrated by Al-Bukhari';

  @override
  String get sponsorshipThankYou => 'May Allah reward you and forgive you';

  @override
  String get sponsorshipRequestSuccessMessage =>
      'Your sponsorship request has been received successfully and is now being reviewed by the relevant department.\n\nThe app will notify you once the request is accepted and approved so you can follow the orphan\'s status.';

  @override
  String get backToHome => 'Back to home';

  @override
  String digitalNumber(String id) {
    return 'Digital number: $id';
  }

  @override
  String get underCareNow => 'Currently under care and support';

  @override
  String get familyAndPersonalData => 'Family and personal data';

  @override
  String get motherName => 'Mother\'s name';

  @override
  String get familyStatus => 'Family status';

  @override
  String get sampleFamilyStatusDescription =>
      'Fatherless orphan, lives with his mother in a rented home.';

  @override
  String get educationAndHealthStatus => 'Education and health status';

  @override
  String get healthStatus => 'Health status';

  @override
  String get healthy => 'Healthy';

  @override
  String get schoolGrade => 'School grade';

  @override
  String get fourthGrade => 'Fourth grade';

  @override
  String get healthDetails => 'Health details';

  @override
  String get sampleHealthDetails =>
      'Healthy and, praise be to Allah, does not suffer from chronic diseases.';

  @override
  String get guardianAndOfficialsData => 'Guardian and officials data';

  @override
  String get guardian => 'Guardian';

  @override
  String get contactNumber => 'Contact number';

  @override
  String get siblingsCount => 'Number of siblings';

  @override
  String get sampleSiblingsCount => '3 siblings';

  @override
  String get renewSponsorshipOrDonate => 'Renew sponsorship or donate';

  @override
  String get orphanSponsorshipDetails => 'Sponsorship Details';

  @override
  String get orphanPersonalData => 'Personal Data';

  @override
  String get sponsorshipData => 'Sponsorship Data';

  @override
  String get orphanName => 'Name';

  @override
  String get birthDate => 'Date of birth';

  @override
  String get orphanClass => 'Class';

  @override
  String get talent => 'Talent';

  @override
  String get monthlySponsorshipAmount => 'Monthly amount';

  @override
  String get sponsorshipStatusLabel => 'Sponsorship status';

  @override
  String get sponsorshipStartDate => 'Sponsorship start date';

  @override
  String get sponsorshipEndDate => 'Sponsorship end date';

  @override
  String get sponsorshipCreatedDate => 'Sponsorship creation date';

  @override
  String get sponsorshipRejectionReason => 'Rejection reason';

  @override
  String get sponsorshipCancellationSource => 'Cancellation source';

  @override
  String get sponsorshipStatusPending => 'Pending';

  @override
  String get sponsorshipStatusAccepted => 'Accepted';

  @override
  String get sponsorshipStatusRejected => 'Rejected';

  @override
  String get sponsorshipStatusCancelled => 'Cancelled';

  @override
  String get confirmMonthlySponsorshipPayment =>
      'Confirm monthly sponsorship payment';

  @override
  String get monthlySponsorshipPaymentConfirmation =>
      'Do you want to pay the monthly sponsorship from your wallet balance? The system will determine the amount.';

  @override
  String get confirmPayment => 'Confirm payment';

  @override
  String get cancelSponsorship => 'Cancel Sponsorship';

  @override
  String get cancelSponsorshipConfirmation =>
      'Are you sure you want to cancel this sponsorship?';

  @override
  String get goBack => 'Back';

  @override
  String get noOrphanDataTitle => 'No orphan information is available now';

  @override
  String get noOrphanDataDescription =>
      'The sponsorship request is still pending, and no orphan has been assigned to you yet.';

  @override
  String get annualReportsTitle => 'Annual reports';

  @override
  String get annualReportsSubtitle => 'View the latest update about the orphan';

  @override
  String annualReportYear(int year) {
    return 'Annual report $year';
  }

  @override
  String annualReportNumber(int number) {
    return 'Report no. $number';
  }

  @override
  String get viewReport => 'View report';

  @override
  String get noAnnualReportsYet => 'No annual reports yet';

  @override
  String get annualReportsLoading => 'Loading annual reports...';

  @override
  String get annualReportsLoadFailed => 'Could not load annual reports';

  @override
  String annualReportPreviewTitle(int year) {
    return 'Annual report $year';
  }

  @override
  String get reportImageLoadFailed => 'Could not load the report image';

  @override
  String get saveAnnualReportDialogTitle => 'Save annual report';

  @override
  String downloadReportSuccess(String fileName) {
    return '$fileName was saved successfully';
  }

  @override
  String get downloadReportFailed => 'Could not download the report';

  @override
  String get close => 'Close';

  @override
  String loginSuccess(String firstName) {
    return 'Logged in successfully. Welcome, $firstName';
  }

  @override
  String get appPreferences => 'App preferences';

  @override
  String get changeAppLanguage => 'Change app language';

  @override
  String get appearance => 'Appearance';

  @override
  String get accountSection => 'Account';

  @override
  String get changePasswordSubtitle => 'Update account password';

  @override
  String get logoutSubtitle => 'Sign out of the current account';

  @override
  String get chooseLanguage => 'Choose app language';

  @override
  String get togetherWeMakeImpact => 'Together, We Make an Impact';

  @override
  String get renewedHope => 'Renewed Hope';

  @override
  String get givingMakesDifference => 'Giving Makes a Difference';

  @override
  String get noCompletedProjects =>
      'There are no completed projects at the moment';

  @override
  String get riyal => 'SAR';

  @override
  String get profileLoadError => 'Unable to load profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get beneficiary => 'Beneficiary';

  @override
  String get years => 'years';

  @override
  String get residence => 'Place of Residence';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get profileAccountHint =>
      'Your account information registered with the association is displayed here.';

  @override
  String get alternateAddressLoadError =>
      'Unable to load the address in the other language';

  @override
  String get loadBothAddressesBeforeSave =>
      'Both language addresses must be loaded before saving changes';

  @override
  String get unsupportedGenderValue =>
      'The current gender value is not supported';

  @override
  String get unsupportedSocialStatusValue =>
      'The current social status value is not supported';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get savingChanges => 'Saving...';

  @override
  String get changePhoto => 'Change photo';

  @override
  String get profilePhotoOptionalHint =>
      'The photo is optional and will only change if you select a new one';

  @override
  String get bilingualAddress => 'Address in both languages';

  @override
  String get arabicAddress => 'Address in Arabic';

  @override
  String get arabicAddressHint => 'Enter the address in Arabic';

  @override
  String get englishAddress => 'Address in English';

  @override
  String get englishAddressHint => 'Enter the address in English';

  @override
  String get loadingAlternateAddress =>
      'Loading the address in the other language...';

  @override
  String get readOnlyData => 'Read-only information';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get currentPassword => 'Current password';

  @override
  String get currentPasswordRequired => 'Current password is required';

  @override
  String get requestTrackingTitle => 'Track Requests';

  @override
  String get allRequests => 'All';

  @override
  String get pendingRequests => 'Under Review';

  @override
  String get acceptedRequests => 'Accepted';

  @override
  String get rejectedRequests => 'Rejected';

  @override
  String get cancelledRequests => 'Cancelled';

  @override
  String get cancelRequestTitle => 'Cancel Request';

  @override
  String cancelRequestConfirmation(int requestId) {
    return 'Are you sure you want to cancel request #$requestId?\nYou will not be able to undo this action.';
  }

  @override
  String get confirmCancelRequest => 'Yes, Cancel Request';

  @override
  String get requestCancelledTitle => 'Request Cancelled';

  @override
  String get requestsLoadError => 'Unable to Load Requests';

  @override
  String get noRequestsForStatus => 'There are no requests with this status';

  @override
  String requestNumber(int requestId) {
    return 'Request #$requestId';
  }

  @override
  String get requestType => 'Request Type';

  @override
  String get subCategory => 'Subcategory';

  @override
  String get aidType => 'Aid Type';

  @override
  String get cost => 'Cost';

  @override
  String get submissionDate => 'Submission Date';

  @override
  String amountRiyal(String amount) {
    return '$amount SAR';
  }

  @override
  String get editRequest => 'Edit Request';

  @override
  String get fundingProgress => 'Funding Progress';

  @override
  String fundingAmountOf(String current, String total) {
    return '$current of $total SAR';
  }

  @override
  String get rejectionReason => 'Rejection Reason';

  @override
  String get noRejectionReason => 'No rejection reason was provided';

  @override
  String get requestWasCancelled => 'This request has been cancelled';

  @override
  String get selfApplicant => 'For myself';

  @override
  String get otherApplicant => 'For someone else';

  @override
  String get whoIsRequestFor => 'Who are you submitting this aid request for?';

  @override
  String get chooseApplicantBeforeFilling =>
      'Choose the applicant before filling in the information';

  @override
  String get loadingProfileData => 'Loading profile information...';

  @override
  String get profileAutoFilled =>
      'Your account information was filled in automatically. You can edit any field before continuing.';

  @override
  String get profileAutoFillError =>
      'Unable to load profile information. You can try again or choose another person.';

  @override
  String get selectApplicantType =>
      'Please choose who you want to submit the aid request for';

  @override
  String get waitForProfileLoading =>
      'Please wait until your information is loaded';

  @override
  String get editApplicantInfo => 'Edit applicant information';

  @override
  String get personalStatus => 'Personal status';

  @override
  String get contactInformation => 'Contact information';

  @override
  String get applicantCreateDescription =>
      'First choose who the request is for, then enter the applicant information accurately.';

  @override
  String get applicantEditDescription =>
      'You can edit the applicant information, then continue to the aid details to update them.';

  @override
  String get arabicAddressLabel => 'Address (Arabic)';

  @override
  String get arabicAddressExample => 'Example: Damascus - Mazzeh - Main Street';

  @override
  String get englishAddressLabel => 'Address (English)';

  @override
  String get englishAddressExample =>
      'Example: Damascus - Al Mazzeh - Main Street';

  @override
  String get arabicAddressRequired => 'Please enter the address in Arabic';

  @override
  String get arabicAddressOnly => 'Please write the address in Arabic only';

  @override
  String get englishAddressRequired => 'Please enter the address in English';

  @override
  String get englishAddressOnly => 'Please write the address in English only';

  @override
  String get phoneRequiredApplicant => 'Please enter the phone number';

  @override
  String get aidRequestTitle => 'Aid request';

  @override
  String get editAidRequestTitle => 'Edit aid request';

  @override
  String aidRequestWithType(String requestType) {
    return '$requestType request';
  }

  @override
  String editAidRequestWithType(String requestType) {
    return 'Edit $requestType request';
  }

  @override
  String get continueToRequestDetails => 'Continue to request details';

  @override
  String get continueToEditRequestDetails => 'Continue to edit request details';

  @override
  String get editEducationRequestDetails => 'Edit Education Request Details';

  @override
  String get academicAchievement => 'Academic Achievement';

  @override
  String get highSchool => 'High School';

  @override
  String get diploma => 'Diploma';

  @override
  String get bachelor => 'Bachelor\'s Degree';

  @override
  String get master => 'Master\'s Degree';

  @override
  String get thirdUniversityYear => 'Third University Year';

  @override
  String get fourthUniversityYear => 'Fourth University Year';

  @override
  String get fifthUniversityYear => 'Fifth University Year';

  @override
  String get sixthUniversityYear => 'Sixth University Year';

  @override
  String get institutionNameArabic => 'School / University Name (Arabic)';

  @override
  String get institutionNameArabicHint => 'Example: Damascus University';

  @override
  String get institutionNameEnglish => 'School / University Name (English)';

  @override
  String get institutionNameEnglishHint => 'Example: Damascus University';

  @override
  String get educationDetailsArabic => 'Education Request Details (Arabic)';

  @override
  String get educationDetailsArabicHint =>
      'Explain the educational need in Arabic...';

  @override
  String get educationDetailsEnglish => 'Education Request Details (English)';

  @override
  String get educationDetailsEnglishHint =>
      'Explain the educational need in English...';

  @override
  String get educationDocuments => 'Attach Educational Documents';

  @override
  String get addNewFiles => 'Add New Files';

  @override
  String get addNewFilesDescription =>
      'You can add new documents. Existing documents will remain unchanged.';

  @override
  String get educationDocumentsDescription =>
      'Please attach clear photos of documents or proof of enrollment.';

  @override
  String get newFiles => 'New Files';

  @override
  String get attachedFiles => 'Attached Files';

  @override
  String get existingAttachedFiles => 'Currently Attached Files';

  @override
  String get existingAttachment => 'Previously Attached File';

  @override
  String get educationEditInfo =>
      'The current request data has been loaded. Edit the fields you want to change, then save your changes.';

  @override
  String get selectAcademicAchievement =>
      'Please select the academic achievement';

  @override
  String get selectGradeOrYear => 'Please select the grade or academic year';

  @override
  String get educationDocumentRequired => 'Please attach at least one document';

  @override
  String get requestIdUnavailable =>
      'Unable to determine the request ID to update';

  @override
  String get schoolOrUniversityName => 'School or university name';

  @override
  String get educationCaseDetails => 'Education request details';

  @override
  String enterFieldInArabic(String fieldName) {
    return 'Please enter $fieldName in Arabic';
  }

  @override
  String fieldArabicOnly(String fieldName) {
    return 'Please write $fieldName in Arabic only';
  }

  @override
  String enterFieldInEnglish(String fieldName) {
    return 'Please enter $fieldName in English';
  }

  @override
  String fieldEnglishOnly(String fieldName) {
    return 'Please write $fieldName in English only';
  }

  @override
  String get editFoodRequestDetails => 'Edit Food Request Details';

  @override
  String get foodRequestDetails => 'Food Request Details';

  @override
  String get foodAidType => 'Required Food Assistance Type';

  @override
  String get foodBasket => 'Food Basket';

  @override
  String get babyMilk => 'Baby Milk';

  @override
  String get foodDetailsArabic => 'Food Request Details (Arabic)';

  @override
  String get foodDetailsArabicHint =>
      'Explain the type of need and the family\'s current situation in Arabic...';

  @override
  String get foodDetailsEnglish => 'Food Request Details (English)';

  @override
  String get foodDetailsEnglishHint =>
      'Explain the family situation and food needs in English...';

  @override
  String get expectedFoodCost => 'Expected Cost';

  @override
  String get supportingDocuments => 'Attach Supporting Documents';

  @override
  String get addNewDocuments => 'Add New Documents';

  @override
  String get foodNewDocumentsDescription =>
      'New attachments are optional as long as the existing attachments remain available';

  @override
  String get foodDocumentsDescription =>
      'Please attach any documents that support the food request';

  @override
  String get foodDecorativeMessage =>
      'Together, we help provide food for every family in need';

  @override
  String get selectFoodAidType => 'Please select the food assistance type';

  @override
  String get invalidIndividualsCount =>
      'Please enter a valid number of individuals';

  @override
  String get foodDocumentRequired => 'Please attach at least one document';

  @override
  String get foodArabicDetailsRequired =>
      'Please enter the request details in Arabic';

  @override
  String get foodArabicDetailsShort =>
      'Please provide clearer details in Arabic';

  @override
  String get foodArabicDetailsMustContainArabic =>
      'The Arabic details must contain Arabic letters';

  @override
  String get foodArabicDetailsNoEnglish =>
      'Please write the Arabic details without English letters';

  @override
  String get foodEnglishDetailsRequired =>
      'Please enter the request details in English';

  @override
  String get foodEnglishDetailsShort =>
      'Please provide clearer details in English';

  @override
  String get foodEnglishDetailsMustContainEnglish =>
      'The English details must contain English letters';

  @override
  String get foodEnglishDetailsNoArabic =>
      'Please write the English details without Arabic letters';

  @override
  String get editHealthRequestDetails => 'Edit Health Request Details';

  @override
  String get healthDetailsArabic => 'Health Details (Arabic)';

  @override
  String get healthDetailsArabicHint =>
      'Describe the diagnosis and symptoms in Arabic...';

  @override
  String get healthDetailsEnglish => 'Health Details (English)';

  @override
  String get healthDetailsEnglishHint =>
      'Describe the diagnosis and symptoms in English...';

  @override
  String get addNewMedicalDocuments =>
      'Add New Medical Reports or Prescriptions';

  @override
  String get medicalNewDocumentsDescription =>
      'New attachments are optional as long as the existing attachments remain available';

  @override
  String get healthArabicDetailsRequired =>
      'Please enter the health details in Arabic';

  @override
  String get healthArabicDetailsShort =>
      'Please provide clearer health details in Arabic';

  @override
  String get healthArabicDetailsMustContainArabic =>
      'The Arabic details must contain Arabic letters';

  @override
  String get healthArabicDetailsNoEnglish =>
      'Please write the Arabic details without English letters';

  @override
  String get healthEnglishDetailsRequired =>
      'Please enter the health details in English';

  @override
  String get healthEnglishDetailsShort =>
      'Please provide clearer health details in English';

  @override
  String get healthEnglishDetailsMustContainEnglish =>
      'The English details must contain English letters';

  @override
  String get healthEnglishDetailsNoArabic =>
      'Please write the English details without Arabic letters';

  @override
  String get homeProvision => 'Home Provision';

  @override
  String get rentAssistance => 'Rent Assistance';

  @override
  String get homeRepairs => 'Home Repairs';

  @override
  String get editHousingRequestDetails => 'Edit Housing Request Details';

  @override
  String get housingAidType => 'Required Housing Assistance Type';

  @override
  String get chooseHousingAidTypeHint =>
      'Choose the housing assistance type to display the required fields';

  @override
  String get housingEditInfo =>
      'The current request data has been loaded. The housing assistance type is fixed, and you can edit the remaining fields before saving your changes.';

  @override
  String get currentResidenceArabic => 'Current Residence (Arabic)';

  @override
  String get currentResidenceArabicHint =>
      'Example: Damascus - Mezzeh - temporary housing';

  @override
  String get currentResidenceEnglish => 'Current Residence (English)';

  @override
  String get currentResidenceEnglishHint =>
      'Example: Damascus - Mezzeh - temporary housing';

  @override
  String get housingSupportReasonArabic =>
      'Reason for Requesting Housing (Arabic)';

  @override
  String get housingSupportReasonArabicHint =>
      'Explain why housing assistance is needed in Arabic...';

  @override
  String get housingSupportReasonEnglish =>
      'Reason for Requesting Housing (English)';

  @override
  String get housingSupportReasonEnglishHint =>
      'Explain why housing assistance is needed in English...';

  @override
  String get requestedHousingSpecsArabic =>
      'Required Housing Specifications (Arabic)';

  @override
  String get requestedHousingSpecsArabicHint =>
      'Example: two rooms, close to school...';

  @override
  String get requestedHousingSpecsEnglish =>
      'Required Housing Specifications (English)';

  @override
  String get requestedHousingSpecsEnglishHint =>
      'Example: two rooms, close to school...';

  @override
  String get currentHousingSituation => 'Current Housing Situation';

  @override
  String get currentHousingSituationArabic =>
      'Current Housing Situation (Arabic)';

  @override
  String get currentHousingSituationArabicHint =>
      'Describe the damage and required repairs in Arabic...';

  @override
  String get currentHousingSituationEnglish =>
      'Current Housing Situation (English)';

  @override
  String get currentHousingSituationEnglishHint =>
      'Describe the damage and required repairs in English...';

  @override
  String get housingDetailsArabic => 'Housing Request Details (Arabic)';

  @override
  String get housingDetailsArabicHint =>
      'Explain the housing situation and need in Arabic...';

  @override
  String get housingDetailsEnglish => 'Housing Request Details (English)';

  @override
  String get housingDetailsEnglishHint =>
      'Explain the housing situation and need in English...';

  @override
  String get expectedHousingCost => 'Expected Cost';

  @override
  String get selectHousingAidType =>
      'Please select the housing assistance type';

  @override
  String get validCurrentRent => 'Please enter a valid current rent amount';

  @override
  String get housingDocumentRequired => 'Please attach at least one document';

  @override
  String get editSmallProjectRequestDetails => 'Edit Small Project Details';

  @override
  String get smallProjectRequestDetails => 'Small Project Details';

  @override
  String get projectInformation => 'Project Information';

  @override
  String get projectNameArabic => 'Project Name (Arabic)';

  @override
  String get projectNameArabicHint => 'Example: مخبز منزلي';

  @override
  String get projectNameEnglish => 'Project Name (English)';

  @override
  String get projectNameEnglishHint => 'Example: Home bakery';

  @override
  String get projectCategoryArabic => 'Project Category (Arabic)';

  @override
  String get projectCategoryArabicHint => 'Example: إنتاج غذائي';

  @override
  String get projectCategoryEnglish => 'Project Category (English)';

  @override
  String get projectCategoryEnglishHint => 'Example: Food production';

  @override
  String get numberOfPeopleSupported => 'Expected Number of People Supported';

  @override
  String get numberOfPeopleSupportedHint => 'Example: 3';

  @override
  String get projectDetailsArabic => 'Project Details (Arabic)';

  @override
  String get projectDetailsArabicHint =>
      'Explain the project idea, goals, and expected benefit in Arabic...';

  @override
  String get projectDetailsEnglish => 'Project Details (English)';

  @override
  String get projectDetailsEnglishHint =>
      'Explain the project idea, goals, and expected benefit in English...';

  @override
  String get expectedProjectCost => 'Expected Cost';

  @override
  String get smallProjectNewDocumentsDescription =>
      'New attachments are optional as long as the existing attachments remain available';

  @override
  String get smallProjectDocumentsDescription =>
      'Feasibility study, photos, invoices, or any documents supporting the project';

  @override
  String get smallProjectDecorativeMessage =>
      'We support small projects to help families build a sustainable income';

  @override
  String get smallProjectEditInfo =>
      'The current request data has been loaded. Edit the fields you want to change, then save your changes.';

  @override
  String get projectNameArabicRequired =>
      'Please enter the project name in Arabic';

  @override
  String get projectNameArabicShort => 'The Arabic project name is too short';

  @override
  String get projectNameEnglishRequired =>
      'Please enter the project name in English';

  @override
  String get projectNameEnglishShort => 'The English project name is too short';

  @override
  String get projectCategoryArabicRequired =>
      'Please enter the project category in Arabic';

  @override
  String get projectCategoryArabicShort =>
      'The Arabic project category is too short';

  @override
  String get projectCategoryEnglishRequired =>
      'Please enter the project category in English';

  @override
  String get projectCategoryEnglishShort =>
      'The English project category is too short';

  @override
  String get validSupportedPeopleCount =>
      'Please enter a valid number of people to be supported';

  @override
  String get projectDetailsArabicRequired =>
      'Please enter the project details in Arabic';

  @override
  String get projectDetailsArabicShort =>
      'Please provide clearer project details in Arabic';

  @override
  String get projectDetailsEnglishRequired =>
      'Please enter the project details in English';

  @override
  String get projectDetailsEnglishShort =>
      'Please provide clearer project details in English';

  @override
  String get smallProjectDocumentRequired =>
      'Please attach at least one document';

  @override
  String get smallProjectFilesUnavailable =>
      'The selected files were already added or could not be accessed';

  @override
  String get arabicFieldMustContainArabic =>
      'The Arabic field must contain Arabic letters';

  @override
  String get arabicFieldNoEnglish =>
      'Please write the Arabic field without English letters';

  @override
  String get englishFieldMustContainEnglish =>
      'The English field must contain English letters';

  @override
  String get englishFieldNoArabic =>
      'Please write the English field without Arabic letters';

  @override
  String get loadingRequestData => 'Loading request data...';

  @override
  String get pleaseWaitMoment => 'Please wait a moment';

  @override
  String get requestDetailsLoadFailed => 'Could not load request details';

  @override
  String get back => 'Back';

  @override
  String get zakatCalculator => 'Zakat Calculator';

  @override
  String get zakatConditionsTitle => 'Conditions for Zakat';

  @override
  String get zakatConditionNisab =>
      'The wealth must reach the required Nisab threshold.';

  @override
  String get zakatConditionOwnership =>
      'The wealth must be fully owned by its owner.';

  @override
  String get zakatConditionYear =>
      'A full lunar year must pass for wealth that requires Hawl.';

  @override
  String get zakatCalculatorDisclaimer =>
      'This calculator is for guidance only. For special cases, consult a qualified Islamic authority.';

  @override
  String get chooseZakatType => 'Choose Zakat Type';

  @override
  String get chooseZakatTypeHint =>
      'Choose the type of Zakat you want to calculate';

  @override
  String get zakatMoney => 'Money Zakat';

  @override
  String get zakatMoneySubtitle => 'Calculate Zakat on cash and money';

  @override
  String get zakatGold => 'Gold Zakat';

  @override
  String get zakatGoldSubtitle =>
      'Calculate Zakat based on gold weight in grams';

  @override
  String get zakatSilver => 'Silver Zakat';

  @override
  String get zakatSilverSubtitle =>
      'Calculate Zakat based on silver weight in grams';

  @override
  String get calculateZakat => 'Calculate Zakat';

  @override
  String get zakatMoneyInputTitle => 'Enter Your Money Amount';

  @override
  String get zakatMoneyInputDescription =>
      'Enter the amount of money you own and today\'s gold gram price to check the Nisab threshold.';

  @override
  String get zakatGoldInputTitle => 'Enter Gold Weight in Grams';

  @override
  String get zakatGoldInputDescription =>
      'Enter the weight of gold you own and today\'s gold gram price.';

  @override
  String get zakatSilverInputTitle => 'Enter Silver Weight in Grams';

  @override
  String get zakatSilverInputDescription =>
      'Enter the weight of silver you own and today\'s silver gram price.';

  @override
  String get moneyAmount => 'Money Amount';

  @override
  String get goldWeight => 'Gold Weight in Grams';

  @override
  String get silverWeight => 'Silver Weight in Grams';

  @override
  String get goldGramPriceToday => 'Today\'s Gold Gram Price';

  @override
  String get silverGramPriceToday => 'Today\'s Silver Gram Price';

  @override
  String get zakatValidAmountRequired =>
      'Please enter a valid value greater than zero';

  @override
  String get zakatValidGramPriceRequired =>
      'Please enter a valid gram price greater than zero';

  @override
  String get zakatDueTitle => 'Zakat is Due';

  @override
  String get zakatNotDueTitle => 'Zakat is Not Due';

  @override
  String get zakatTypeLabel => 'Zakat Type';

  @override
  String get zakatAssetValue => 'Asset Value';

  @override
  String get zakatNisabValue => 'Nisab Value';

  @override
  String get zakatRateLabel => 'Zakat Rate';

  @override
  String get zakatDueAmount => 'Zakat Due';

  @override
  String get calculateAgain => 'Calculate Again';

  @override
  String get donateZakatAmount => 'Donate Zakat amount';

  @override
  String get zakatDonationSheetTitle => 'Choose donation fund';

  @override
  String get zakatDonationAmount => 'Zakat amount';

  @override
  String get zakatOrphanSupportFundOption => 'Orphan Support Fund';

  @override
  String get zakatQuickDonationFundOption => 'Quick Donation Fund';
}
