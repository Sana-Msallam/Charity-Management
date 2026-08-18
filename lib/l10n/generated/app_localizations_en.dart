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
  String get dateOfBirth => 'Date of birth';

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
  String get tryAgainLater =>
      'We couldn\'t load your donation history. Please try again.';

  @override
  String get retry => 'Retry';

  @override
  String get totalDonaited => 'Total Donations';

  @override
  String get sponsorship => 'Sponsorship';

  @override
  String get walletTopUp => 'Wallet Top-up';

  @override
  String get caseLabel => 'Case';

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
  String get aboutAssociationTitle => 'About the association';

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
  String get medicineInsurance => 'Medicine insurance';

  @override
  String get surgery => 'Surgery';

  @override
  String get medicalDevices => 'Medical devices';

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
  String get profileTitle => 'Account';

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
    return 'Remaining amount: $amount';
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
  String get currentWalletBalance => 'Current wallet balance';

  @override
  String get topUpWallet => 'Top up wallet';

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
  String loginSuccess(String firstName) {
    return 'Logged in successfully. Welcome, $firstName';
  }
}
