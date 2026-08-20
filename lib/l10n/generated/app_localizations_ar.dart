// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'جمعية الأثر';

  @override
  String get associationName => 'جمعية الأثر';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get phoneNumber => 'رقم الجوال';

  @override
  String get password => 'كلمة المرور';

  @override
  String get phoneRequired => 'الرجاء إدخال رقم الجوال';

  @override
  String get invalidPhoneNumber => 'رقم الجوال غير صحيح';

  @override
  String get passwordRequired => 'الرجاء إدخال كلمة المرور';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get createNewAccount => 'إنشاء حساب جديد';

  @override
  String get createDonorAccount => 'إنشاء حساب كمتبرع';

  @override
  String get createBeneficiaryAccount => 'إنشاء حساب كمستفيد';

  @override
  String get or => 'أو';

  @override
  String get continueAsGuest => 'الدخول كزائر';

  @override
  String get search => 'بحث';

  @override
  String get countrySearchHint => 'اكتب اسم البلد';

  @override
  String get changeLanguage => 'English';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get donorWelcome => 'يسعدنا انضمامك لرحلة العطاء';

  @override
  String get beneficiaryWelcome =>
      'سجل بياناتك للانضمام إلى برنامج رعاية المستفيدين';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get firstNameHint => 'مثال: سارة';

  @override
  String get lastNameHint => 'مثال: محمد';

  @override
  String get firstNameRequired => 'الرجاء إدخال الاسم الأول';

  @override
  String get lastNameRequired => 'الرجاء إدخال اسم العائلة';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailRequired => 'الرجاء إدخال البريد الإلكتروني';

  @override
  String get invalidEmail => 'البريد الإلكتروني غير صحيح';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordRequired => 'الرجاء تأكيد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get passwordMin6 => 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';

  @override
  String get passwordMin8 => 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟';

  @override
  String get gender => 'الجنس';

  @override
  String get male => 'ذكر';

  @override
  String get completed => 'مكتمل';

  @override
  String get noCompletedAidCases => 'لا توجد حالات مساعدة مكتملة';

  @override
  String get aboutAtharAssociation => 'عن جمعية أثر';

  @override
  String get aboutAtharAssociationDescription =>
      'جمعية أثر تسعى إلى دعم الأيتام والأسر المحتاجة من خلال برامج ومبادرات تهدف إلى تحسين حياتهم.';

  @override
  String get female => 'أنثى';

  @override
  String get dateOfBirth => 'تاريخ الميلاد';

  @override
  String get selectDateOfBirth => 'اختر تاريخ الميلاد';

  @override
  String get completedAidCases => 'الحالات المنجزة';

  @override
  String get dateOfBirthHint => 'YYYY-MM-DD';

  @override
  String get dateOfBirthRequired => 'الرجاء اختيار تاريخ الميلاد';

  @override
  String get invalidDateOfBirth => 'تاريخ الميلاد غير صحيح';

  @override
  String get dateOfBirthFutureInvalid =>
      'لا يمكن أن يكون تاريخ الميلاد في المستقبل';

  @override
  String get otpSent => 'تم إرسال رمز التحقق بنجاح';

  @override
  String get otpSentToPhone => 'تم إرسال رمز التحقق إلى رقم الجوال';

  @override
  String get accountActivation => 'تفعيل الحساب';

  @override
  String otpInstructions(String phoneNumber) {
    return 'يرجى إدخال الرمز المكون من 4 أرقام المرسل إلى الرقم $phoneNumber';
  }

  @override
  String get otpRequired => 'الرجاء إدخال رمز التحقق كاملاً';

  @override
  String get otpResendRequested => 'تم طلب إعادة إرسال الرمز';

  @override
  String get phoneVerified => 'تم التحقق من رقم الهاتف بنجاح';

  @override
  String get confirm => 'تأكيد';

  @override
  String get resendCode => 'إعادة إرسال الرمز';

  @override
  String resendAfter(int seconds) {
    return 'إعادة الإرسال بعد $seconds ثانية';
  }

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور';

  @override
  String get forgotPasswordDescription =>
      'أدخل رقم الهاتف المرتبط بحسابك، وسنرسل إليك رمزاً لإعادة تعيين كلمة المرور.';

  @override
  String get phoneWithCountryRequired => 'الرجاء إدخال رقم الهاتف';

  @override
  String get countryCodeRequired => 'يجب إدخال رمز الدولة مثل +963';

  @override
  String get invalidFullPhoneNumber => 'رقم الهاتف غير صالح';

  @override
  String get sendingCode => 'جاري إرسال الرمز...';

  @override
  String get sendVerificationCode => 'إرسال رمز التحقق';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get verificationCode => 'رمز التحقق';

  @override
  String get verificationCodeHint => 'أدخل رمز التحقق';

  @override
  String get verificationCodeRequired => 'الرجاء إدخال رمز التحقق';

  @override
  String get invalidVerificationCode => 'رمز التحقق غير صالح';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get newPasswordRequired => 'الرجاء إدخال كلمة المرور الجديدة';

  @override
  String get confirmNewPassword => 'تأكيد كلمة المرور الجديدة';

  @override
  String get changingPassword => 'جاري تغيير كلمة المرور...';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get accountCreated => 'تم إنشاء حسابك بنجاح';

  @override
  String get pendingApprovalMessage =>
      'طلبك قيد المراجعة حاليًا.\nستتمكن من تسجيل الدخول بعد موافقة الموظف على حسابك.';

  @override
  String get backToLogin => 'العودة إلى تسجيل الدخول';

  @override
  String get residentialAddress => 'عنوان السكن';

  @override
  String get selectResidentialAddress => 'اختر عنوان السكن';

  @override
  String get addressRequired => 'الرجاء اختيار عنوان السكن';

  @override
  String get familyStatementPhoto => 'صورة عن البيان العائلي';

  @override
  String get personalPhoto => 'صورة شخصية';

  @override
  String get tapToSelectPhoto => 'اضغط لاختيار صورة';

  @override
  String get personalPhotoRequired => 'الرجاء اختيار الصورة الشخصية';

  @override
  String get familyStatementRequired => 'الرجاء اختيار صورة البيان العائلي';

  @override
  String get imageSelectionFailed => 'تعذر اختيار الصورة';

  @override
  String get chooseFromGallery => 'اختيار من الاستديو';

  @override
  String get takePhoto => 'التقاط صورة بالكاميرا';

  @override
  String get socialStatus => 'الحالة الاجتماعية';

  @override
  String get selectStatus => 'اختر الحالة';

  @override
  String get single => 'أعزب';

  @override
  String get married => 'متزوج';

  @override
  String get divorced => 'مطلق';

  @override
  String get widowed => 'أرمل';

  @override
  String get numberOfChildren => 'عدد الأولاد';

  @override
  String get childrenRequired => 'أدخل عدد الأولاد';

  @override
  String get invalidNumber => 'عدد غير صحيح';

  @override
  String get monthlyIncome => 'الراتب الشهري';

  @override
  String get incomeRequired => 'الرجاء إدخال الراتب الشهري';

  @override
  String get invalidIncome => 'الراتب الشهري غير صحيح';

  @override
  String get syrianPound => 'ل.س';

  @override
  String get employmentStatus => 'حالة العمل';

  @override
  String get employed => 'يعمل';

  @override
  String get unemployed => 'عاطل عن العمل';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع';

  @override
  String get connectionTimeout => 'انتهت مهلة الاتصال، يرجى المحاولة مجدداً';

  @override
  String get connectionError => 'تعذر الاتصال بالخادم، تحقق من اتصال الإنترنت';

  @override
  String get badRequest => 'البيانات المرسلة غير صحيحة';

  @override
  String get unauthorized => 'الجلسة غير مصرح بها، يرجى تسجيل الدخول مجدداً';

  @override
  String get forbidden => 'ليس لديك صلاحية لتنفيذ هذه العملية';

  @override
  String get notFound => 'لم يتم العثور على العنصر المطلوب';

  @override
  String get serverError => 'حدث خطأ في الخادم، يرجى المحاولة لاحقاً';

  @override
  String get invalidServerResponse => 'صيغة استجابة الخادم غير صحيحة';

  @override
  String get missingLoginToken => 'لم يتم استلام رمز تسجيل الدخول';

  @override
  String get verificationFailed => 'فشل التحقق من الرمز';

  @override
  String get operationSuccessful => 'تمت العملية بنجاح';

  @override
  String get addressMazzeh => 'مزة';

  @override
  String get addressMidan => 'ميدان';

  @override
  String get addressMuhajireen => 'مهاجرين';

  @override
  String get addressAfif => 'عفيف';

  @override
  String get addressRuknAlDin => 'ركن الدين';

  @override
  String get addressSahnaya => 'صحنايا';

  @override
  String get addressMalki => 'المالكي';

  @override
  String get addressBaghdadStreet => 'شارع بغداد';

  @override
  String get addressKafrSousa => 'كفرسوسة';

  @override
  String get addressBarzeh => 'برزة';

  @override
  String get addressShaalan => 'شعلان';

  @override
  String get addressHamraStreet => 'شارع الحمرا';

  @override
  String get addressMaysat => 'ميسات';

  @override
  String get addressSalihiyah => 'الصالحية';

  @override
  String get addressMazraa => 'المزرعة';

  @override
  String get addressRuralDamascus => 'ريف دمشق';

  @override
  String get welcomeBackName => 'Welcome back, Sarah';

  @override
  String get welcomeComma => 'أهلاً بك،';

  @override
  String get sampleUserSarah => 'سارة';

  @override
  String get specialAppeal => 'نداء خاص';

  @override
  String get sponsorAnOrphanToday => 'اكفل يتيماً\nاليوم';

  @override
  String get sponsorAnOrphanDescription =>
      'غيّر حياة طفل بدعم شهري وتعليم ورعاية صحية.';

  @override
  String get learnMore => 'لمعرفة المزيد';

  @override
  String get supportAreas => 'مجالات الدعم';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get smallProjects => 'المشاريع الصغيرة';

  @override
  String get education => 'التعليم';

  @override
  String get orphanFund => 'سند اليتيم';

  @override
  String get health => 'الصحة';

  @override
  String get food => 'الغذاء';

  @override
  String get title => 'تبرعاتي';

  @override
  String get total => 'إجمالي التبرعات';

  @override
  String get all => 'الكل';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get totalDonaited => 'إجمالي التبرعات';

  @override
  String get sponsorship => 'كفالة';

  @override
  String get walletTopUp => 'شحن المحفظة';

  @override
  String get aidRequestDonation => 'تبرع لطلب مساعدة';

  @override
  String get walletBalance => 'رصيد المحفظة';

  @override
  String get operation => 'معاملة';

  @override
  String get empty => 'لا توجد معاملات';

  @override
  String get sponsor => 'كافل';

  @override
  String get loadError => 'حدث خطأ أثناء جلب سجل التبرعات';

  @override
  String get housing => 'السكن';

  @override
  String get loggingOut => 'جارٍ تسجيل الخروج...';

  @override
  String get followDonations => 'تابع تبرعاتك';

  @override
  String get changeAppAppearance => 'تغيير مظهر التطبيق';

  @override
  String get languageAndAppearance => 'اللغة والمظهر';

  @override
  String get communityInitiatives => 'المبادرات المجتمعية';

  @override
  String get communityInitiativesDescription =>
      'تكاتف مع القادة المحليين لبناء مستقبل مستدام من خلال العطاء التعاوني.';

  @override
  String get explorePortal => 'استكشف البوابة';

  @override
  String get totalImpact => 'إجمالي التأثير';

  @override
  String get livesImpacted => 'الأرواح المؤثرة';

  @override
  String get sampleChildrenCount => '12 طفل';

  @override
  String get menu => 'القائمة';

  @override
  String get impact => 'التأثير';

  @override
  String get home => 'الرئيسية';

  @override
  String get wallet => 'المحفظة';

  @override
  String get sponsorships => 'الكفالات';

  @override
  String get trackRequest => 'تتبع الطلب';

  @override
  String get account => 'الحساب';

  @override
  String get settings => 'الإعدادات';

  @override
  String get newAidRequest => 'تقديم طلب مساعدة جديد';

  @override
  String get healthRequest => 'طلب صحي';

  @override
  String get healthRequestSubtitle => 'علاج وأدوية';

  @override
  String get foodRequest => 'طلب غذائي';

  @override
  String get foodRequestSubtitle => 'سلال غذائية';

  @override
  String get housingRequest => 'طلب سكني';

  @override
  String get housingRequestSubtitle => 'تحسين المسكن أو إيجار';

  @override
  String get educationRequest => 'طلب تعليمي';

  @override
  String get educationRequestSubtitle => 'رسوم وكتب';

  @override
  String get projectSupport => 'دعم المشاريع';

  @override
  String get projectSupportSubtitle => 'تمويل وتطوير';

  @override
  String get completedProjectsTitle => 'المشاريع المنجزة من قبل الجمعية';

  @override
  String get waterWellProject => 'حفر بئر مياه';

  @override
  String get schoolBuildingProject => 'بناء مدرسة';

  @override
  String get medicalComplexProject => 'مجمع طبي';

  @override
  String get aboutAssociationTitle => 'جمعية الأثر... لأن لكل عطاء أثراً';

  @override
  String get aboutAssociationDescription =>
      'نحن في جمعيتنا نسعى لتوفير الدعم الشامل للمحتاجين، ونهدف إلى بناء مستقبل يسوده التكافل الاجتماعي والرحمة من خلال برامجنا التنموية والإغاثية المبتكرة.';

  @override
  String get ourVision => 'رؤيتنا';

  @override
  String get ourVisionDescription =>
      'نسعى إلى أن نكون جمعية رائدة في العمل الإنساني، وأن نساهم في بناء مجتمع متكافل يحصل فيه كل فرد على الدعم والرعاية التي يحتاجها.';

  @override
  String get ourMission => 'رسالتنا';

  @override
  String get ourMissionDescription =>
      'تقديم المساعدات والخدمات الإنسانية بكفاءة وشفافية، والوصول إلى الفئات الأكثر احتياجًا من خلال مبادرات تنموية تصنع أثرًا إيجابيًا ومستدامًا.';

  @override
  String get beneficiariesNeedSupport => 'عدد الأفراد المحتاجين للدعم';

  @override
  String get individual => 'فرد';

  @override
  String get individuals => 'أفراد';

  @override
  String get currencyRiyal => 'ريال';

  @override
  String get currentStep => 'الخطوة الحالية';

  @override
  String get lastStep => 'الخطوة الأخيرة';

  @override
  String stepOfTotal(int currentStep, int totalSteps) {
    return '$currentStep من $totalSteps';
  }

  @override
  String get dataPrivacy => 'خصوصية البيانات';

  @override
  String get dataPrivacyDescription =>
      'يتم التعامل مع كافة البيانات المرفوعة بمنتهى السرية والخصوصية التامة وفقاً للمعايير الأمنية.';

  @override
  String get whyWeAskData => 'لماذا نطلب هذه البيانات؟';

  @override
  String get whyWeAskDataDescription =>
      'نحرص على دقة البيانات لضمان وصول المساعدات لمستحقيها بأسرع وقت ممكن وبكل كرامة.';

  @override
  String get applicantInfoTitle => 'معلومات مقدم الطلب';

  @override
  String get fatherName => 'اسم الأب';

  @override
  String get fatherNameHint => 'مثال: أحمد';

  @override
  String get familyName => 'الكنية';

  @override
  String get familyNameHint => 'مثال: الدرويش';

  @override
  String get age => 'العمر';

  @override
  String get ageHint => 'مثال: 35';

  @override
  String get address => 'العنوان';

  @override
  String get addressHint => 'مثال: دمشق - المزة';

  @override
  String get jobStatus => 'الحالة الوظيفية';

  @override
  String get working => 'يعمل';

  @override
  String get notWorking => 'عاطل عن العمل';

  @override
  String get continueButton => 'متابعة';

  @override
  String get fillAllDataCorrectly =>
      'يرجى التأكد من تعبئة جميع البيانات بشكل صحيح';

  @override
  String get selectGender => 'يرجى اختيار الجنس';

  @override
  String get selectSocialStatus => 'يرجى اختيار الحالة الاجتماعية';

  @override
  String get selectJobStatus => 'يرجى اختيار الحالة الوظيفية';

  @override
  String get invalidAge => 'يرجى إدخال عمر صحيح';

  @override
  String get unsupportedRequestType => 'نوع الطلب غير مدعوم حالياً';

  @override
  String requiredField(String fieldName) {
    return 'يرجى إدخال $fieldName';
  }

  @override
  String fieldTooShort(String fieldName) {
    return '$fieldName قصير جداً';
  }

  @override
  String get ageRequired => 'يرجى إدخال العمر';

  @override
  String get ageNumbersOnly => 'يرجى إدخال العمر بالأرقام';

  @override
  String get phoneValidRequired => 'يرجى إدخال رقم هاتف صحيح';

  @override
  String get housingRequestDetails => 'تفاصيل الطلب السكني';

  @override
  String get currentHousingStatus => 'الوضع الحالي للسكن';

  @override
  String get ownedHousing => 'ملك';

  @override
  String get rentedHousing => 'إيجار';

  @override
  String get noHousing => 'لا يوجد سكن';

  @override
  String get currentRentValue => 'قيمة الإيجار الحالي (إن وجد)';

  @override
  String get currentResidenceDetails => 'مكان الإقامة الحالي بالتفصيل';

  @override
  String get currentResidenceHint => 'المدينة، الحي، اسم الشارع';

  @override
  String get housingSupportReason => 'سبب عدم وجود مأوى أو سبب طلب الدعم';

  @override
  String get housingSupportReasonHint => 'يرجى كتابة شرح مفصل للحالة...';

  @override
  String get requestedHousingSpecs => 'مواصفات السكن المطلوب أو الحالي';

  @override
  String get requestedHousingSpecsHint => 'عدد الغرف، الدور، الخدمات القريبة';

  @override
  String get attachProofDocuments => 'إرفاق وثائق ثبوتية';

  @override
  String get housingDocumentsDescription =>
      'عقد إيجار، صور السكن الحالي، أو أي وثائق تدعم الطلب (JPG, PDF)';

  @override
  String get housingQuote => '\"نسعى لتوفير بيئة آمنة وكريمة لكل أسرة\"';

  @override
  String get submitRequestForReview => 'إرسال الطلب للمراجعة';

  @override
  String get healthRequestDetails => 'تفاصيل الطلب الصحي';

  @override
  String get medicalAidTypeRequired => 'يرجى اختيار نوع المساعدة الطبية';

  @override
  String get healthDescriptionRequired => 'يرجى إدخال وصف الحالة الصحية';

  @override
  String get validCostRequired => 'يرجى إدخال تكلفة صحيحة';

  @override
  String get medicalAttachmentRequired =>
      'يرجى إرفاق تقرير أو وصفة طبية واحدة على الأقل';

  @override
  String get duplicateFiles => 'الملفات المحددة مضافة مسبقاً';

  @override
  String get filesAccessFailed => 'تعذر الوصول إلى الملفات المحددة';

  @override
  String get fileSelectionFailed => 'تعذر اختيار الملفات، يرجى المحاولة مجدداً';

  @override
  String get medicalAidType => 'نوع المساعدة الطبية المطلوبة';

  @override
  String get medicineInsurance => 'تأمين أدوية';

  @override
  String get surgery => 'عمل جراحي';

  @override
  String get medicalDevices => 'أجهزة طبية';

  @override
  String get healthDescription => 'وصف الحالة الصحية بالتفصيل';

  @override
  String get healthDescriptionHint => 'يرجى ذكر التشخيص والأعراض بوضوح...';

  @override
  String get treatmentExpectedCost => 'التكلفة المالية المتوقعة للعلاج';

  @override
  String get medicalReportsUpload => 'إرفاق التقارير الطبية والوصفات الرسمية';

  @override
  String get uploadFilesOrCapture => 'رفع الملفات أو التقاط صور';

  @override
  String get medicalReportsUploadDescription =>
      'يرجى إرفاق صور واضحة للتقارير والوصفات الطبية';

  @override
  String get deleteAttachment => 'حذف المرفق';

  @override
  String get fileReadyForUpload => 'ملف جاهز للرفع';

  @override
  String get educationRequestDetails => 'تفاصيل الطلب التعليمي';

  @override
  String get educationLevel => 'التحصيل الدراسي';

  @override
  String get schoolLevel => 'مدرسي';

  @override
  String get universityLevel => 'جامعي';

  @override
  String get institutionName => 'اسم المدرسة / الجامعة';

  @override
  String get institutionNameHint => 'أدخل الاسم هنا...';

  @override
  String get gradeOrYear => 'الصف / السنة الدراسية';

  @override
  String get selectGradeHint => 'اختر المرحلة...';

  @override
  String get requestedAssistanceType => 'نوع المساعدة المطلوبة';

  @override
  String get schoolClothes => 'ثياب مدرسية';

  @override
  String get studySupplies => 'مستلزمات دراسية';

  @override
  String get universityFees => 'أقساط جامعة';

  @override
  String get other => 'أخرى';

  @override
  String get primaryStage => 'المرحلة الابتدائية';

  @override
  String get middleStage => 'المرحلة المتوسطة';

  @override
  String get secondaryStage => 'المرحلة الثانوية';

  @override
  String get firstUniversityYear => 'سنة أولى جامعي';

  @override
  String get secondUniversityYear => 'سنة ثانية جامعي';

  @override
  String get caseDescription => 'وصف الحالة بالتفصيل';

  @override
  String get educationDescriptionHint =>
      'اشرح لنا حاجتك التعليمية لتقديم أفضل دعم ممكن...';

  @override
  String get expectedTotalCost => 'التكلفة الإجمالية المتوقعة';

  @override
  String get profileTitle => 'حسابي';

  @override
  String ageWithYears(int years) {
    return '$years سنة';
  }

  @override
  String get workStatus => 'حالة العمل';

  @override
  String get employedStatus => 'موظف';

  @override
  String get unemployedStatus => 'غير موظف';

  @override
  String get caseDetails => 'تفاصيل الحالة';

  @override
  String get activeCases => 'الحالات النشطة';

  @override
  String availableCases(int count) {
    return '$count متاحة';
  }

  @override
  String get urgent => 'عاجل';

  @override
  String supportCategoryDescription(String category) {
    return 'دعم المتطلبات العاجلة والحملات التنموية لـ $category.';
  }

  @override
  String remainingAmount(String amount) {
    return 'المتبقي: $amount ريال';
  }

  @override
  String get collected => 'المجمّع';

  @override
  String get target => 'الهدف';

  @override
  String get requiredAmount => 'المبلغ المطلوب';

  @override
  String get amountCollected => 'تم جمعه';

  @override
  String get amountRemaining => 'المتبقي';

  @override
  String completionPercentage(num percentage) {
    return 'نسبة الإنجاز $percentage%';
  }

  @override
  String get donateNow => 'تبرع الآن';

  @override
  String get donationCheckoutTitle => 'إتمام التبرع';

  @override
  String get aidRequestDonation => 'تبرع لطلب إعانة';

  @override
  String get donationAmountUsd => 'مبلغ التبرع بالدولار';

  @override
  String get donationAmountHint => 'مثال: 25';

  @override
  String get invalidDonationAmount =>
      'أدخل مبلغاً موجباً لا يتجاوز المبلغ المتبقي.';

  @override
  String get completeDonation => 'إتمام الدفع الآمن';

  @override
  String get stripePaymentSheetNotice =>
      'يتم إدخال بيانات البطاقة حصراً داخل واجهة Stripe الآمنة.';

  @override
  String get paymentCompletedRefresh =>
      'تم الدفع بنجاح. جارٍ تحديث تفاصيل الطلب...';

  @override
  String get paymentCanceled => 'تم إلغاء عملية الدفع.';

  @override
  String get stripePaymentError =>
      'تعذر إتمام الدفع عبر Stripe، يرجى المحاولة مجدداً.';

  @override
  String get stripePublishableKeyMissing =>
      'مفتاح Stripe publishable غير محمّل. شغّل التطبيق من إعداد Flutter with Stripe.';

  @override
  String get stripePublishableKeyInvalid =>
      'يجب أن يبدأ مفتاح Stripe publishable بـ pk_test_.';

  @override
  String get paymentAmountMustBePositive =>
      'يجب أن يكون مبلغ التبرع أكبر من الصفر.';

  @override
  String get paymentAmountExceedsRemaining =>
      'لا يمكن أن يتجاوز مبلغ التبرع المبلغ المتبقي.';

  @override
  String get currentWalletBalance => 'رصيد المحفظة الحالي';

  @override
  String get topUpWallet => 'شحن المحفظة';

  @override
  String get walletBalanceLoading => 'جاري جلب الرصيد...';

  @override
  String get couldNotLoadWalletBalance => 'تعذر جلب الرصيد';

  @override
  String get walletBalanceUnavailable => 'الرصيد غير متاح حالياً';

  @override
  String get mySponsorships => 'كفالاتي';

  @override
  String get manageCurrentSponsoredOrphans => 'إدارة الأيتام المكفولين حالياً';

  @override
  String get addNewSponsorship => 'إضافة كفالة جديدة';

  @override
  String get currentSponsorships => 'كفالاتي الحالية';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get sponsoredChildrenCount => 'عدد الأطفال المكفولين حالياً';

  @override
  String sponsoredChildrenTotal(int count) {
    return '$count';
  }

  @override
  String get sponsoredList => 'قائمة المكفولين';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get noSponsorshipsForStatus => 'لا توجد كفالات بهذه الحالة';

  @override
  String get sponsorshipUnderReview => 'الكفالة قيد المراجعة';

  @override
  String get filterSponsorships => 'تصفية الكفالات';

  @override
  String get allSponsorships => 'جميع الكفالات';

  @override
  String get activeStatus => 'نشط';

  @override
  String get sponsorshipsPageDescription => 'إدارة كفالاتك ودعم الأطفال';

  @override
  String get active => 'نشطة';

  @override
  String get personalInformation => 'المعلومات الشخصية';

  @override
  String get myAccount => 'حسابي';

  @override
  String get donor => 'متبرع';

  @override
  String get unspecified => 'غير محدد';

  @override
  String get myDonations => 'تبرعاتي';

  @override
  String get myDonationsSubtitle => 'تابعي طلباتك وتبرعاتك';

  @override
  String get language => 'اللغة';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get appearanceSubtitle => 'تغيير مظهر التطبيق';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutLoading => 'جارٍ تسجيل الخروج...';

  @override
  String get logoutConfirmation => 'هل أنت متأكد من رغبتك في تسجيل الخروج؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get logoutError => 'حدث خطأ أثناء تسجيل الخروج';

  @override
  String get availableForSponsorship => 'Available for sponsorship';

  @override
  String get supportAChild => 'اكفل طفلًا';

  @override
  String get startNewSponsorshipDescription =>
      'ابدئي كفالة جديدة وكوني سببًا في دعم طفل';

  @override
  String get chooseOrphanAndStartSponsorship =>
      'اختاري طفلًا وابدئي طلب الكفالة';

  @override
  String get walletBalanceUsedForSponsorship =>
      'يُستخدم رصيد محفظتك عند إرسال طلب الكفالة';

  @override
  String get givingImpactDescription =>
      'Educational meals were provided this month thanks to your giving';

  @override
  String get newSponsorshipRequest => 'طلب كفالة جديدة';

  @override
  String get changeChildLife => 'ساهم في تغيير حياة طفل';

  @override
  String get completeTrust => 'موثوقية تامة';

  @override
  String get completeTrustDescription =>
      'جميع البيانات والمعلومات يتم التعامل معها بأعلى معايير الخصوصية والأمان وفق الضوابط الشرعية.';

  @override
  String get sponsorshipTermsTitle => 'شروط وأحكام الكفالة';

  @override
  String get sponsorshipTermWalletBalance =>
      'يجب أن يتوفر في المحفظة رصيد يغطي 4 أشهر من الكفالة مسبقاً، على أن يتم استقطاع رصيد الكفالة شهرياً بشكل تلقائي.';

  @override
  String get sponsorshipTermReservedBalance =>
      'بمجرد تخصيص رصيد الكفالة سلفاً لمصاريف كفالة اليتيم المحددة، لا يجوز استخدامه في أغراض أخرى.';

  @override
  String get sponsorshipTermLowBalance =>
      'تلغى الكفالة تلقائياً في حال انخفاض الرصيد عن قيمة شهرين دون تعويض المبلّغ المعني.';

  @override
  String get sponsorshipTermOrphanSelection =>
      'تتم عملية اختيار اليتيم من قبل الإدارة بناءً على قوائم الاحتياج والأولوية لضمان العدالة وتغطية الحالات الأكثر تضرراً.';

  @override
  String get sponsorshipTermFilesAccess =>
      'تتاح ملفات اليتيم والتقارير الدورية بالكامل فقط عبر لوحة التحكم الخاصة بالحساب بعد اعتماد الطلب بنجاح.';

  @override
  String get acceptSponsorshipTerms => 'تأكيد وقبول الشروط';

  @override
  String get orphanSponsorshipVirtue => 'فضل كفالة الأيتام';

  @override
  String get orphanSponsorshipHadith =>
      'عن سهل بن سعد رضي الله عنه قال: قال رسول الله صلى الله عليه وسلم: \"أَنَا وَكَافِلُ الْيَتِيمِ فِي الْجَنَّةِ هَكَذَا\" وَأَشَارَ بِالسَّبَّابَةِ وَالْوُسْطَى، وَفَرَّجَ بَيْنَهُمَا شَيْئًا.';

  @override
  String get narratedByBukhari => 'رواه البخاري';

  @override
  String get sponsorshipThankYou => 'جزاك الله خيراً وغفر لك';

  @override
  String get sponsorshipRequestSuccessMessage =>
      'تم استلام طلب الكفالة الخاص بك بنجاح، ويتم الآن مراجعته وتدقيقه من قِبل القسم المختص.\n\nسيرسل لك التطبيق إشعاراً فور قبول الطلب واعتماده لتتمكن من متابعة حالة اليتيم.';

  @override
  String get backToHome => 'العودة للرئيسية';

  @override
  String digitalNumber(String id) {
    return 'الرقم الرقمي: $id';
  }

  @override
  String get underCareNow => 'تحت الرعاية والدعم حالياً';

  @override
  String get familyAndPersonalData => 'البيانات العائلية والشخصية';

  @override
  String get motherName => 'اسم الأم';

  @override
  String get familyStatus => 'الحالة العائلية';

  @override
  String get sampleFamilyStatusDescription =>
      'يتيم الأب، يعيش مع الأم في بيت مستأجر.';

  @override
  String get educationAndHealthStatus => 'الوضع التعليمي والصحي';

  @override
  String get healthStatus => 'الحالة الصحية';

  @override
  String get healthy => 'سليم';

  @override
  String get schoolGrade => 'المرحلة الدراسية';

  @override
  String get fourthGrade => 'الصف الرابع';

  @override
  String get healthDetails => 'التفاصيل الصحية';

  @override
  String get sampleHealthDetails => 'سليم، لا يعاني من أمراض مزمنة ولله الحمد.';

  @override
  String get guardianAndOfficialsData => 'بيانات ولي الأمر والمسؤولين';

  @override
  String get guardian => 'ولي الأمر';

  @override
  String get contactNumber => 'رقم التواصل';

  @override
  String get siblingsCount => 'عدد الإخوة';

  @override
  String get sampleSiblingsCount => '3 إخوة وأخوات';

  @override
  String get renewSponsorshipOrDonate => 'تجديد الكفالة أو التبرع';

  @override
  String get orphanSponsorshipDetails => 'تفاصيل الكفالة';

  @override
  String get orphanPersonalData => 'البيانات الشخصية';

  @override
  String get sponsorshipData => 'بيانات الكفالة';

  @override
  String get orphanName => 'الاسم';

  @override
  String get birthDate => 'تاريخ الميلاد';

  @override
  String get orphanClass => 'الصف';

  @override
  String get talent => 'الموهبة';

  @override
  String get monthlySponsorshipAmount => 'المبلغ الشهري';

  @override
  String get sponsorshipStatusLabel => 'حالة الكفالة';

  @override
  String get sponsorshipStartDate => 'تاريخ بدء الكفالة';

  @override
  String get sponsorshipEndDate => 'تاريخ انتهاء الكفالة';

  @override
  String get sponsorshipCreatedDate => 'تاريخ إنشاء الكفالة';

  @override
  String get sponsorshipRejectionReason => 'سبب الرفض';

  @override
  String get sponsorshipCancellationSource => 'مصدر الإلغاء';

  @override
  String get sponsorshipStatusPending => 'قيد الانتظار';

  @override
  String get sponsorshipStatusAccepted => 'مقبولة';

  @override
  String get sponsorshipStatusRejected => 'مرفوضة';

  @override
  String get sponsorshipStatusCancelled => 'ملغاة';

  @override
  String get confirmMonthlySponsorshipPayment => 'تأكيد الدفع الشهري للكفالة';

  @override
  String get monthlySponsorshipPaymentConfirmation =>
      'هل تريد دفع مبلغ الكفالة الشهري من رصيد محفظتك؟ سيتم تحديد المبلغ من قبل النظام.';

  @override
  String get confirmPayment => 'تأكيد الدفع';

  @override
  String get cancelSponsorship => 'إلغاء الكفالة';

  @override
  String get cancelSponsorshipConfirmation =>
      'هل أنت متأكد من رغبتك في إلغاء هذه الكفالة؟';

  @override
  String get goBack => 'تراجع';

  @override
  String get noOrphanDataTitle => 'لا توجد معلومات عن اليتيم حالياً';

  @override
  String get noOrphanDataDescription =>
      'طلب الكفالة ما زال قيد الانتظار ولم يتم تخصيص يتيم لك حتى الآن.';

  @override
  String loginSuccess(String firstName) {
    return 'تم تسجيل الدخول بنجاح، أهلاً $firstName';
  }

  @override
  String get appPreferences => 'تفضيلات التطبيق';

  @override
  String get changeAppLanguage => 'تغيير لغة التطبيق';

  @override
  String get appearance => 'المظهر';

  @override
  String get accountSection => 'الحساب';

  @override
  String get changePasswordSubtitle => 'تحديث كلمة مرور الحساب';

  @override
  String get logoutSubtitle => 'الخروج من الحساب الحالي';

  @override
  String get chooseLanguage => 'اختر لغة التطبيق';

  @override
  String get togetherWeMakeImpact => 'معاً نصنع أثراً';

  @override
  String get renewedHope => 'أمل يتجدد';

  @override
  String get givingMakesDifference => 'العطاء يصنع الفرق';

  @override
  String get noCompletedProjects => 'لا توجد مشاريع مكتملة حالياً';

  @override
  String get riyal => 'ريال';

  @override
  String get profileLoadError => 'تعذر تحميل الملف الشخصي';

  @override
  String get editProfile => 'تعديل البيانات';

  @override
  String get beneficiary => 'المستفيد';

  @override
  String get years => 'سنة';

  @override
  String get residence => 'مكان الإقامة';

  @override
  String get notSpecified => 'غير محدد';

  @override
  String get profileAccountHint => 'يتم عرض بيانات حسابك المسجلة لدى الجمعية.';

  @override
  String get alternateAddressLoadError => 'تعذر تحميل العنوان باللغة الأخرى';

  @override
  String get loadBothAddressesBeforeSave =>
      'يجب تحميل العنوان باللغتين قبل حفظ التعديلات';

  @override
  String get unsupportedGenderValue => 'قيمة الجنس الحالية غير مدعومة';

  @override
  String get unsupportedSocialStatusValue =>
      'قيمة الحالة الاجتماعية الحالية غير مدعومة';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get savingChanges => 'جارٍ الحفظ...';

  @override
  String get changePhoto => 'تغيير الصورة';

  @override
  String get profilePhotoOptionalHint =>
      'الصورة اختيارية، ولن تتغير إلا عند اختيار صورة جديدة';

  @override
  String get bilingualAddress => 'العنوان باللغتين';

  @override
  String get arabicAddress => 'العنوان بالعربية';

  @override
  String get arabicAddressHint => 'أدخل العنوان بالعربية';

  @override
  String get englishAddress => 'العنوان بالإنجليزية';

  @override
  String get englishAddressHint => 'أدخل العنوان بالإنجليزية';

  @override
  String get loadingAlternateAddress => 'جارٍ تحميل العنوان باللغة الأخرى...';

  @override
  String get readOnlyData => 'بيانات للعرض فقط';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get currentPasswordRequired => 'كلمة المرور الحالية مطلوبة';

  @override
  String get requestTrackingTitle => 'تتبع الطلبات';

  @override
  String get allRequests => 'الكل';

  @override
  String get pendingRequests => 'قيد المراجعة';

  @override
  String get acceptedRequests => 'المقبولة';

  @override
  String get rejectedRequests => 'المرفوضة';

  @override
  String get cancelledRequests => 'الملغاة';

  @override
  String get cancelRequestTitle => 'إلغاء الطلب';

  @override
  String cancelRequestConfirmation(int requestId) {
    return 'هل أنت متأكد من رغبتك في إلغاء الطلب رقم #$requestId؟\nلن تتمكن من التراجع عن هذه العملية.';
  }

  @override
  String get confirmCancelRequest => 'نعم، إلغاء الطلب';

  @override
  String get requestCancelledTitle => 'تم إلغاء الطلب';

  @override
  String get requestsLoadError => 'تعذر تحميل الطلبات';

  @override
  String get noRequestsForStatus => 'لا توجد طلبات في هذه الحالة';

  @override
  String requestNumber(int requestId) {
    return 'طلب #$requestId';
  }

  @override
  String get requestType => 'نوع الطلب';

  @override
  String get subCategory => 'النوع الفرعي';

  @override
  String get aidType => 'نوع المساعدة';

  @override
  String get cost => 'التكلفة';

  @override
  String get submissionDate => 'تاريخ التقديم';

  @override
  String amountRiyal(String amount) {
    return '$amount ريال';
  }

  @override
  String get editRequest => 'تعديل الطلب';

  @override
  String get fundingProgress => 'متابعة التمويل';

  @override
  String fundingAmountOf(String current, String total) {
    return '$current من $total ريال';
  }

  @override
  String get rejectionReason => 'سبب الرفض';

  @override
  String get noRejectionReason => 'لم يتم توضيح سبب الرفض';

  @override
  String get requestWasCancelled => 'تم إلغاء هذا الطلب';

  @override
  String get selfApplicant => 'لنفسي';

  @override
  String get otherApplicant => 'لشخص آخر';

  @override
  String get whoIsRequestFor => 'لمن تريد تقديم طلب الإعانة؟';

  @override
  String get chooseApplicantBeforeFilling =>
      'اختر صاحب الطلب قبل تعبئة المعلومات';

  @override
  String get loadingProfileData => 'جارٍ تحميل بيانات الملف الشخصي...';

  @override
  String get profileAutoFilled =>
      'تم تعبئة بيانات حسابك تلقائياً. يمكنك تعديل أي معلومة قبل متابعة الطلب.';

  @override
  String get profileAutoFillError =>
      'تعذر تحميل بيانات الملف الشخصي، يمكنك المحاولة مرة أخرى أو اختيار شخص آخر';

  @override
  String get selectApplicantType => 'يرجى تحديد لمن تريد تقديم طلب الإعانة';

  @override
  String get waitForProfileLoading => 'يرجى الانتظار حتى يتم تحميل بياناتك';

  @override
  String get editApplicantInfo => 'تعديل معلومات مقدم الطلب';

  @override
  String get personalStatus => 'الحالة الشخصية';

  @override
  String get contactInformation => 'معلومات التواصل';

  @override
  String get applicantCreateDescription =>
      'حدد أولاً لمن تريد تقديم الطلب، ثم أدخل معلومات مقدم الطلب بدقة.';

  @override
  String get applicantEditDescription =>
      'يمكنك تعديل معلومات مقدم الطلب، ثم الانتقال إلى تفاصيل المساعدة لتعديلها.';

  @override
  String get arabicAddressLabel => 'العنوان (عربي)';

  @override
  String get arabicAddressExample => 'مثال: دمشق - المزة - الشارع الرئيسي';

  @override
  String get englishAddressLabel => 'العنوان (إنجليزي)';

  @override
  String get englishAddressExample =>
      'Example: Damascus - Al Mazzeh - Main Street';

  @override
  String get arabicAddressRequired => 'يرجى إدخال العنوان باللغة العربية';

  @override
  String get arabicAddressOnly => 'يرجى كتابة العنوان بالعربية فقط';

  @override
  String get englishAddressRequired => 'يرجى إدخال العنوان باللغة الإنجليزية';

  @override
  String get englishAddressOnly => 'يرجى كتابة العنوان باللغة الإنجليزية فقط';

  @override
  String get phoneRequiredApplicant => 'يرجى إدخال رقم الهاتف';

  @override
  String get aidRequestTitle => 'طلب مساعدة';

  @override
  String get editAidRequestTitle => 'تعديل طلب مساعدة';

  @override
  String aidRequestWithType(String requestType) {
    return 'طلب $requestType';
  }

  @override
  String editAidRequestWithType(String requestType) {
    return 'تعديل طلب $requestType';
  }

  @override
  String get continueToRequestDetails => 'متابعة إلى تفاصيل الطلب';

  @override
  String get continueToEditRequestDetails => 'متابعة لتعديل تفاصيل الطلب';

  @override
  String get editEducationRequestDetails => 'تعديل تفاصيل الطلب التعليمي';

  @override
  String get academicAchievement => 'التحصيل الدراسي';

  @override
  String get highSchool => 'ثانوي';

  @override
  String get diploma => 'دبلوم';

  @override
  String get bachelor => 'بكالوريوس';

  @override
  String get master => 'ماجستير';

  @override
  String get thirdUniversityYear => 'سنة ثالثة جامعي';

  @override
  String get fourthUniversityYear => 'سنة رابعة جامعي';

  @override
  String get fifthUniversityYear => 'سنة خامسة جامعي';

  @override
  String get sixthUniversityYear => 'سنة سادسة جامعي';

  @override
  String get institutionNameArabic => 'اسم المدرسة / الجامعة (عربي)';

  @override
  String get institutionNameArabicHint => 'مثال: جامعة دمشق';

  @override
  String get institutionNameEnglish => 'اسم المدرسة / الجامعة (إنجليزي)';

  @override
  String get institutionNameEnglishHint => 'Example: Damascus University';

  @override
  String get educationDetailsArabic => 'تفاصيل الحالة التعليمية (عربي)';

  @override
  String get educationDetailsArabicHint =>
      'اشرح حاجتك التعليمية باللغة العربية...';

  @override
  String get educationDetailsEnglish => 'تفاصيل الحالة التعليمية (إنجليزي)';

  @override
  String get educationDetailsEnglishHint =>
      'Explain the educational need in English...';

  @override
  String get educationDocuments => 'إرفاق الوثائق التعليمية';

  @override
  String get addNewFiles => 'إضافة ملفات جديدة';

  @override
  String get addNewFilesDescription =>
      'يمكنك إضافة وثائق جديدة، أما الوثائق الحالية فستبقى كما هي';

  @override
  String get educationDocumentsDescription =>
      'يرجى إرفاق صور واضحة للوثائق أو إثبات التسجيل';

  @override
  String get newFiles => 'الملفات الجديدة';

  @override
  String get attachedFiles => 'الملفات المرفقة';

  @override
  String get existingAttachedFiles => 'الملفات المرفقة حالياً';

  @override
  String get existingAttachment => 'مرفق موجود مسبقاً';

  @override
  String get educationEditInfo =>
      'تم تحميل بيانات الطلب الحالية. عدّل الحقول التي تريد تغييرها ثم اضغط حفظ التعديلات.';

  @override
  String get selectAcademicAchievement => 'يرجى اختيار التحصيل الدراسي';

  @override
  String get selectGradeOrYear => 'يرجى اختيار الصف أو السنة الدراسية';

  @override
  String get educationDocumentRequired => 'يرجى إرفاق وثيقة واحدة على الأقل';

  @override
  String get requestIdUnavailable => 'تعذر تحديد رقم الطلب المراد تعديله';

  @override
  String get schoolOrUniversityName => 'اسم المدرسة أو الجامعة';

  @override
  String get educationCaseDetails => 'تفاصيل الحالة التعليمية';

  @override
  String enterFieldInArabic(String fieldName) {
    return 'يرجى إدخال $fieldName باللغة العربية';
  }

  @override
  String fieldArabicOnly(String fieldName) {
    return 'يرجى كتابة $fieldName باللغة العربية فقط';
  }

  @override
  String enterFieldInEnglish(String fieldName) {
    return 'يرجى إدخال $fieldName باللغة الإنجليزية';
  }

  @override
  String fieldEnglishOnly(String fieldName) {
    return 'يرجى كتابة $fieldName باللغة الإنجليزية فقط';
  }

  @override
  String get editFoodRequestDetails => 'تعديل تفاصيل الطلب الغذائي';

  @override
  String get foodRequestDetails => 'تفاصيل الطلب الغذائي';

  @override
  String get foodAidType => 'نوع المساعدة الغذائية المطلوبة';

  @override
  String get foodBasket => 'سلة غذائية';

  @override
  String get babyMilk => 'حليب أطفال';

  @override
  String get foodDetailsArabic => 'تفاصيل الحالة والاحتياج الغذائي (عربي)';

  @override
  String get foodDetailsArabicHint =>
      'اشرح نوع الاحتياج والظروف الحالية للأسرة باللغة العربية...';

  @override
  String get foodDetailsEnglish => 'تفاصيل الطلب الغذائي (إنجليزي)';

  @override
  String get foodDetailsEnglishHint =>
      'Explain the family situation and food needs in English...';

  @override
  String get expectedFoodCost => 'التكلفة المالية المتوقعة';

  @override
  String get supportingDocuments => 'إرفاق الوثائق الثبوتية';

  @override
  String get addNewDocuments => 'إضافة وثائق جديدة';

  @override
  String get foodNewDocumentsDescription =>
      'المرفقات الجديدة اختيارية ما دامت المرفقات الحالية موجودة';

  @override
  String get foodDocumentsDescription =>
      'يرجى إرفاق أي وثائق تدعم الطلب الغذائي';

  @override
  String get foodDecorativeMessage =>
      'معاً نساهم في توفير الغذاء لكل أسرة محتاجة';

  @override
  String get selectFoodAidType => 'يرجى اختيار نوع المساعدة الغذائية';

  @override
  String get invalidIndividualsCount => 'يرجى إدخال عدد أفراد صحيح';

  @override
  String get foodDocumentRequired => 'يرجى إرفاق وثيقة واحدة على الأقل';

  @override
  String get foodArabicDetailsRequired =>
      'يرجى إدخال تفاصيل الطلب باللغة العربية';

  @override
  String get foodArabicDetailsShort => 'يرجى كتابة تفاصيل أوضح باللغة العربية';

  @override
  String get foodArabicDetailsMustContainArabic =>
      'يجب أن تحتوي التفاصيل العربية على أحرف عربية';

  @override
  String get foodArabicDetailsNoEnglish =>
      'يرجى كتابة التفاصيل العربية دون أحرف إنكليزية';

  @override
  String get foodEnglishDetailsRequired =>
      'يرجى إدخال تفاصيل الطلب باللغة الإنجليزية';

  @override
  String get foodEnglishDetailsShort =>
      'يرجى كتابة تفاصيل أوضح باللغة الإنجليزية';

  @override
  String get foodEnglishDetailsMustContainEnglish =>
      'يجب أن تحتوي التفاصيل الإنجليزية على أحرف إنجليزية';

  @override
  String get foodEnglishDetailsNoArabic =>
      'يرجى كتابة التفاصيل الإنجليزية دون أحرف عربية';

  @override
  String get editHealthRequestDetails => 'تعديل تفاصيل الطلب الصحي';

  @override
  String get healthDetailsArabic => 'تفاصيل الحالة الصحية (عربي)';

  @override
  String get healthDetailsArabicHint =>
      'يرجى ذكر التشخيص والأعراض باللغة العربية...';

  @override
  String get healthDetailsEnglish => 'تفاصيل الحالة الصحية (إنجليزي)';

  @override
  String get healthDetailsEnglishHint =>
      'Describe the diagnosis and symptoms in English...';

  @override
  String get addNewMedicalDocuments => 'إضافة تقارير أو وصفات طبية جديدة';

  @override
  String get medicalNewDocumentsDescription =>
      'المرفقات الجديدة اختيارية ما دامت المرفقات الحالية موجودة';

  @override
  String get healthArabicDetailsRequired =>
      'يرجى إدخال تفاصيل الحالة الصحية باللغة العربية';

  @override
  String get healthArabicDetailsShort =>
      'يرجى كتابة تفاصيل أوضح باللغة العربية';

  @override
  String get healthArabicDetailsMustContainArabic =>
      'يجب أن تحتوي التفاصيل العربية على أحرف عربية';

  @override
  String get healthArabicDetailsNoEnglish =>
      'يرجى كتابة التفاصيل العربية دون أحرف إنكليزية';

  @override
  String get healthEnglishDetailsRequired =>
      'يرجى إدخال تفاصيل الحالة الصحية باللغة الإنجليزية';

  @override
  String get healthEnglishDetailsShort =>
      'يرجى كتابة تفاصيل أوضح باللغة الإنجليزية';

  @override
  String get healthEnglishDetailsMustContainEnglish =>
      'يجب أن تحتوي التفاصيل الإنجليزية على أحرف إنجليزية';

  @override
  String get healthEnglishDetailsNoArabic =>
      'يرجى كتابة التفاصيل الإنجليزية دون أحرف عربية';

  @override
  String get homeProvision => 'تأمين منزل';

  @override
  String get rentAssistance => 'مساعدة في إيجار البيت';

  @override
  String get homeRepairs => 'إصلاحات منزلية';

  @override
  String get editHousingRequestDetails => 'تعديل تفاصيل الطلب السكني';

  @override
  String get housingAidType => 'نوع المساعدة السكنية المطلوبة';

  @override
  String get chooseHousingAidTypeHint =>
      'اختر نوع المساعدة السكنية لعرض الحقول المطلوبة';

  @override
  String get housingEditInfo =>
      'تم تحميل بيانات الطلب الحالية. نوع المساعدة السكنية ثابت، ويمكنك تعديل بقية الحقول ثم حفظ التعديلات.';

  @override
  String get currentResidenceArabic => 'مكان الإقامة الحالي (عربي)';

  @override
  String get currentResidenceArabicHint => 'مثال: دمشق - المزة - سكن مؤقت';

  @override
  String get currentResidenceEnglish => 'مكان الإقامة الحالي (إنجليزي)';

  @override
  String get currentResidenceEnglishHint =>
      'Example: Damascus - Mezzeh - temporary housing';

  @override
  String get housingSupportReasonArabic => 'سبب طلب تأمين منزل (عربي)';

  @override
  String get housingSupportReasonArabicHint =>
      'اشرح سبب الحاجة إلى منزل باللغة العربية...';

  @override
  String get housingSupportReasonEnglish => 'سبب طلب تأمين منزل (إنجليزي)';

  @override
  String get housingSupportReasonEnglishHint =>
      'Explain why housing assistance is needed in English...';

  @override
  String get requestedHousingSpecsArabic => 'مواصفات المنزل المطلوب (عربي)';

  @override
  String get requestedHousingSpecsArabicHint =>
      'مثال: غرفتان، قريب من المدرسة...';

  @override
  String get requestedHousingSpecsEnglish => 'مواصفات المنزل المطلوب (إنجليزي)';

  @override
  String get requestedHousingSpecsEnglishHint =>
      'Example: two rooms, close to school...';

  @override
  String get currentHousingSituation => 'حالة المنزل الحالية';

  @override
  String get currentHousingSituationArabic => 'وصف حالة المنزل الحالية (عربي)';

  @override
  String get currentHousingSituationArabicHint =>
      'اشرح الأضرار والإصلاحات المطلوبة باللغة العربية...';

  @override
  String get currentHousingSituationEnglish =>
      'وصف حالة المنزل الحالية (إنجليزي)';

  @override
  String get currentHousingSituationEnglishHint =>
      'Describe the damage and required repairs in English...';

  @override
  String get housingDetailsArabic => 'تفاصيل الطلب السكني (عربي)';

  @override
  String get housingDetailsArabicHint =>
      'اشرح الحالة والحاجة إلى المساعدة باللغة العربية...';

  @override
  String get housingDetailsEnglish => 'تفاصيل الطلب السكني (إنجليزي)';

  @override
  String get housingDetailsEnglishHint =>
      'Explain the housing situation and need in English...';

  @override
  String get expectedHousingCost => 'التكلفة المالية المتوقعة';

  @override
  String get selectHousingAidType => 'يرجى اختيار نوع المساعدة السكنية';

  @override
  String get validCurrentRent => 'يرجى إدخال قيمة الإيجار الحالي بشكل صحيح';

  @override
  String get housingDocumentRequired => 'يرجى إرفاق وثيقة واحدة على الأقل';

  @override
  String get editSmallProjectRequestDetails => 'تعديل تفاصيل المشروع الصغير';

  @override
  String get smallProjectRequestDetails => 'تفاصيل المشروع الصغير';

  @override
  String get projectInformation => 'معلومات المشروع';

  @override
  String get projectNameArabic => 'اسم المشروع (عربي)';

  @override
  String get projectNameArabicHint => 'مثال: مخبز منزلي';

  @override
  String get projectNameEnglish => 'اسم المشروع (إنجليزي)';

  @override
  String get projectNameEnglishHint => 'Example: Home bakery';

  @override
  String get projectCategoryArabic => 'تصنيف المشروع (عربي)';

  @override
  String get projectCategoryArabicHint => 'مثال: إنتاج غذائي';

  @override
  String get projectCategoryEnglish => 'تصنيف المشروع (إنجليزي)';

  @override
  String get projectCategoryEnglishHint => 'Example: Food production';

  @override
  String get numberOfPeopleSupported => 'عدد الأشخاص المتوقع دعمهم';

  @override
  String get numberOfPeopleSupportedHint => 'مثال: 3';

  @override
  String get projectDetailsArabic => 'تفاصيل المشروع (عربي)';

  @override
  String get projectDetailsArabicHint =>
      'اشرح فكرة المشروع، أهدافه، وخطة الاستفادة منه باللغة العربية...';

  @override
  String get projectDetailsEnglish => 'تفاصيل المشروع (إنجليزي)';

  @override
  String get projectDetailsEnglishHint =>
      'Explain the project idea, goals, and expected benefit in English...';

  @override
  String get expectedProjectCost => 'التكلفة المالية المتوقعة';

  @override
  String get smallProjectNewDocumentsDescription =>
      'المرفقات الجديدة اختيارية ما دامت المرفقات الحالية موجودة';

  @override
  String get smallProjectDocumentsDescription =>
      'دراسة جدوى، صور، فواتير أو وثائق تدعم المشروع';

  @override
  String get smallProjectDecorativeMessage =>
      'نسعى لدعم المشاريع الصغيرة لتوفير دخل مستدام للأسر';

  @override
  String get smallProjectEditInfo =>
      'تم تحميل بيانات الطلب الحالية. عدّل الحقول التي تريد تغييرها ثم اضغط حفظ التعديلات.';

  @override
  String get projectNameArabicRequired =>
      'يرجى إدخال اسم المشروع باللغة العربية';

  @override
  String get projectNameArabicShort => 'اسم المشروع باللغة العربية قصير جداً';

  @override
  String get projectNameEnglishRequired =>
      'يرجى إدخال اسم المشروع باللغة الإنجليزية';

  @override
  String get projectNameEnglishShort =>
      'اسم المشروع باللغة الإنجليزية قصير جداً';

  @override
  String get projectCategoryArabicRequired =>
      'يرجى إدخال تصنيف المشروع باللغة العربية';

  @override
  String get projectCategoryArabicShort =>
      'تصنيف المشروع باللغة العربية قصير جداً';

  @override
  String get projectCategoryEnglishRequired =>
      'يرجى إدخال تصنيف المشروع باللغة الإنجليزية';

  @override
  String get projectCategoryEnglishShort =>
      'تصنيف المشروع باللغة الإنجليزية قصير جداً';

  @override
  String get validSupportedPeopleCount =>
      'يرجى إدخال عدد صحيح للأشخاص المستفيدين';

  @override
  String get projectDetailsArabicRequired =>
      'يرجى إدخال تفاصيل المشروع باللغة العربية';

  @override
  String get projectDetailsArabicShort =>
      'يرجى كتابة تفاصيل أوضح باللغة العربية';

  @override
  String get projectDetailsEnglishRequired =>
      'يرجى إدخال تفاصيل المشروع باللغة الإنجليزية';

  @override
  String get projectDetailsEnglishShort =>
      'يرجى كتابة تفاصيل أوضح باللغة الإنجليزية';

  @override
  String get smallProjectDocumentRequired => 'يرجى إرفاق وثيقة واحدة على الأقل';

  @override
  String get smallProjectFilesUnavailable =>
      'الملفات المحددة مضافة مسبقاً أو تعذر الوصول إليها';

  @override
  String get arabicFieldMustContainArabic =>
      'يجب أن يحتوي الحقل العربي على أحرف عربية';

  @override
  String get arabicFieldNoEnglish =>
      'يرجى كتابة الحقل العربي دون أحرف إنكليزية';

  @override
  String get englishFieldMustContainEnglish =>
      'يجب أن يحتوي الحقل الإنجليزي على أحرف إنجليزية';

  @override
  String get englishFieldNoArabic =>
      'يرجى كتابة الحقل الإنجليزي دون أحرف عربية';

  @override
  String get loadingRequestData => 'جاري تحميل بيانات الطلب...';

  @override
  String get pleaseWaitMoment => 'يرجى الانتظار قليلاً';

  @override
  String get requestDetailsLoadFailed => 'تعذر تحميل تفاصيل الطلب';

  @override
  String get back => 'رجوع';

  @override
  String get zakatCalculator => 'حاسبة الزكاة';

  @override
  String get zakatConditionsTitle => 'شروط وجوب الزكاة';

  @override
  String get zakatConditionNisab => 'أن يبلغ المال النصاب الشرعي.';

  @override
  String get zakatConditionOwnership =>
      'أن يكون المال مملوكًا لصاحبه ملكًا تامًا.';

  @override
  String get zakatConditionYear =>
      'مرور الحول في الأموال التي يشترط فيها الحول.';

  @override
  String get zakatCalculatorDisclaimer =>
      'الحاسبة وسيلة إرشادية، ويُنصح بالرجوع إلى جهة شرعية مختصة في الحالات الخاصة.';

  @override
  String get chooseZakatType => 'اختر نوع الزكاة';

  @override
  String get chooseZakatTypeHint => 'اختر النوع الذي تريد حساب زكاته';

  @override
  String get zakatMoney => 'زكاة المال';

  @override
  String get zakatMoneySubtitle => 'حساب زكاة الأموال النقدية';

  @override
  String get zakatGold => 'زكاة الذهب';

  @override
  String get zakatGoldSubtitle => 'حساب الزكاة حسب وزن الذهب بالغرام';

  @override
  String get zakatSilver => 'زكاة الفضة';

  @override
  String get zakatSilverSubtitle => 'حساب الزكاة حسب وزن الفضة بالغرام';

  @override
  String get calculateZakat => 'حساب الزكاة';

  @override
  String get zakatMoneyInputTitle => 'أدخل مقدار الأموال';

  @override
  String get zakatMoneyInputDescription =>
      'أدخل مقدار المال الذي تملكه وسعر غرام الذهب اليوم ليتم التحقق من بلوغ النصاب.';

  @override
  String get zakatGoldInputTitle => 'أدخل وزن الذهب بالغرام';

  @override
  String get zakatGoldInputDescription =>
      'أدخل وزن الذهب الذي تملكه وسعر غرام الذهب اليوم.';

  @override
  String get zakatSilverInputTitle => 'أدخل وزن الفضة بالغرام';

  @override
  String get zakatSilverInputDescription =>
      'أدخل وزن الفضة الذي تملكه وسعر غرام الفضة اليوم.';

  @override
  String get moneyAmount => 'مقدار الأموال';

  @override
  String get goldWeight => 'وزن الذهب بالغرام';

  @override
  String get silverWeight => 'وزن الفضة بالغرام';

  @override
  String get goldGramPriceToday => 'سعر غرام الذهب اليوم';

  @override
  String get silverGramPriceToday => 'سعر غرام الفضة اليوم';

  @override
  String get zakatValidAmountRequired => 'يرجى إدخال قيمة صحيحة أكبر من صفر';

  @override
  String get zakatValidGramPriceRequired =>
      'يرجى إدخال سعر غرام صحيح أكبر من صفر';

  @override
  String get zakatDueTitle => 'الزكاة واجبة';

  @override
  String get zakatNotDueTitle => 'لم تجب الزكاة';

  @override
  String get zakatTypeLabel => 'نوع الزكاة';

  @override
  String get zakatAssetValue => 'قيمة المال';

  @override
  String get zakatNisabValue => 'قيمة النصاب';

  @override
  String get zakatRateLabel => 'نسبة الزكاة';

  @override
  String get zakatDueAmount => 'مقدار الزكاة المستحقة';

  @override
  String get calculateAgain => 'إعادة الحساب';
}
