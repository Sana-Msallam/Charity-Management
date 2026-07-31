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
  String get female => 'أنثى';

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
  String get employmentStatus => 'الحالة المهنية';

  @override
  String get employed => 'أعمل';

  @override
  String get unemployed => 'لا أعمل';

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
  String loginSuccess(String firstName) {
    return 'تم تسجيل الدخول بنجاح، أهلاً $firstName';
  }
}
