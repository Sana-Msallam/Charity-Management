import 'package:charity_management/features/Beneficiary/Help_request/health_request/cubit/health_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/model/applicant_info_model.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/screen/health_request_page.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/service/health_request_service.dart';

// عدّلي هذا المسار حسب مكان ملف CustomTextField عندك
import 'package:charity_management/widgets/custom_text_field.dart';

import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/routes/app_routes.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplicantInfoPage extends StatefulWidget {
  const ApplicantInfoPage({super.key, required this.requestType});

  final String requestType;

  @override
  State<ApplicantInfoPage> createState() {
    return _ApplicantInfoPageState();
  }
}

class _ApplicantInfoPageState extends State<ApplicantInfoPage> {
  // المفتاح الخاص بالـ Form، نستخدمه لفحص الحقول
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers الخاصة بالحقول
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _fatherNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _ageController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _addressController = TextEditingController();

  // القيم التي يختارها المستخدم
  String? _selectedGender;
  String? _selectedSocialStatus;
  String? _selectedJobStatus;

  // خيارات الجنس
  final List<String> _genderOptions = ['ذكر', 'أنثى'];

  // خيارات الحالة الاجتماعية
  final List<String> _socialStatusOptions = ['أعزب', 'متزوج', 'أرمل', 'مطلق'];

  // خيارات الحالة الوظيفية
  final List<String> _jobStatusOptions = ['يعمل', 'عاطل عن العمل'];

  @override
  void initState() {
    super.initState();

    debugPrint('======================================');
    debugPrint('ApplicantInfoPage opened');
    debugPrint('Request type: ${widget.requestType}');
    debugPrint('======================================');
  }

  @override
  void dispose() {
    // حذف Controllers من الذاكرة عند إغلاق الصفحة
    _firstNameController.dispose();
    _fatherNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _addressController.dispose();

    debugPrint('ApplicantInfoPage disposed');

    super.dispose();
  }

  // يتم استدعاؤها عند الضغط على زر متابعة
  void _continueToRequestDetails() {
    debugPrint('======================================');
    debugPrint('Continue button clicked');

    // إغلاق لوحة المفاتيح
    FocusScope.of(context).unfocus();

    // فحص جميع TextFormField الموجودة داخل Form
    final bool isFormValid = _formKey.currentState?.validate() ?? false;

    debugPrint('Form validation result: $isFormValid');
    debugPrint('Selected gender: $_selectedGender');
    debugPrint('Selected social status: $_selectedSocialStatus');
    debugPrint('Selected job status: $_selectedJobStatus');

    if (!isFormValid) {
      _showMessage(AppLocalizations.of(context).fillAllDataCorrectly);

      return;
    }

    // فحص اختيار الجنس
    if (_selectedGender == null) {
      _showMessage(AppLocalizations.of(context).selectGender);

      return;
    }

    // فحص اختيار الحالة الاجتماعية
    if (_selectedSocialStatus == null) {
      _showMessage(AppLocalizations.of(context).selectSocialStatus);

      return;
    }

    // فحص اختيار الحالة الوظيفية
    if (_selectedJobStatus == null) {
      _showMessage(AppLocalizations.of(context).selectJobStatus);

      return;
    }

    // تحويل العمر من String إلى int
    final int? age = int.tryParse(_ageController.text.trim());

    if (age == null || age <= 0 || age > 120) {
      _showMessage(AppLocalizations.of(context).invalidAge);

      return;
    }

    // إنشاء Object يحتوي معلومات مقدم الطلب
    final ApplicantInfoModel applicantInfo = ApplicantInfoModel(
      firstName: _firstNameController.text.trim(),

      fatherName: _fatherNameController.text.trim(),

      lastName: _lastNameController.text.trim(),

      age: age,

      gender: _selectedGender!,

      socialStatus: _selectedSocialStatus!,

      phoneNumber: _phoneController.text.trim(),

      address: _addressController.text.trim(),

      // إذا اختار عاطل عن العمل تصبح true
      isUnemployed: _selectedJobStatus == 'عاطل عن العمل',
    );

    _printApplicantInfo(applicantInfo);

    // نفتح صفحة الطلب الصحي فقط إذا كان نوع الطلب صحي
    if (widget.requestType.trim() == 'صحي') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) {
            return BlocProvider(
              create: (_) {
                return HealthCubit(HealthRequestService());
              },
              child: HealthRequestPage(applicantInfo: applicantInfo),
            );
          },
        ),
      );

      return;
    }

    // إذا كان نوع الطلب غير صحي
    if (widget.requestType.trim() == 'تعليمي') {
      Navigator.pushNamed(context, AppRoutes.educationRequest);

      return;
    }

    if (widget.requestType.trim() == 'سكني') {
      Navigator.pushNamed(context, AppRoutes.housingRequest);

      return;
    }

    _showMessage(AppLocalizations.of(context).unsupportedRequestType);
  }

  // طباعة البيانات في Console للتأكد منها
  void _printApplicantInfo(ApplicantInfoModel applicantInfo) {
    debugPrint('======================================');
    debugPrint('ApplicantInfoModel created');
    debugPrint('firstName: ${applicantInfo.firstName}');
    debugPrint('fatherName: ${applicantInfo.fatherName}');
    debugPrint('lastName: ${applicantInfo.lastName}');
    debugPrint('age: ${applicantInfo.age}');
    debugPrint('gender: ${applicantInfo.gender}');
    debugPrint('socialStatus: ${applicantInfo.socialStatus}');
    debugPrint('phoneNumber: ${applicantInfo.phoneNumber}');
    debugPrint('address: ${applicantInfo.address}');
    debugPrint('isUnemployed: ${applicantInfo.isUnemployed}');
    debugPrint('======================================');
  }

  // إظهار رسالة في أسفل الشاشة
  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  // التحقق من الحقول النصية العادية
  String? _requiredTextValidator(String? value, String fieldName) {
    final l10n = AppLocalizations.of(context);
    final String text = value?.trim() ?? '';

    if (text.isEmpty) {
      return l10n.requiredField(fieldName);
    }

    if (text.length < 2) {
      return l10n.fieldTooShort(fieldName);
    }

    return null;
  }

  // التحقق من العمر
  String? _validateAge(String? value) {
    final l10n = AppLocalizations.of(context);
    final String text = value?.trim() ?? '';

    if (text.isEmpty) {
      return l10n.ageRequired;
    }

    final int? age = int.tryParse(text);

    if (age == null) {
      return l10n.ageNumbersOnly;
    }

    if (age <= 0 || age > 120) {
      return l10n.invalidAge;
    }

    return null;
  }

  // التحقق من رقم الهاتف
  String? _validatePhone(String? value) {
    final l10n = AppLocalizations.of(context);
    final String text = value?.trim() ?? '';

    if (text.isEmpty) {
      return l10n.phoneWithCountryRequired;
    }

    // حذف الفراغات والشرطات من الرقم
    final String normalizedPhone = text.replaceAll(' ', '').replaceAll('-', '');

    // يسمح بالأرقام وإشارة +
    final RegExp phonePattern = RegExp(r'^[0-9+]{7,15}$');

    if (!phonePattern.hasMatch(normalizedPhone)) {
      return l10n.phoneValidRequired;
    }

    return null;
  }

  // عنوان صغير فوق خيارات ChoiceChip
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.brandGray,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: AppTextStyles.fontFamily,
        ),
      ),
    );
  }

  // بناء خيارات الاختيار
  Widget _buildChoiceChips({
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
    required String Function(String) labelFor,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((String option) {
        final bool isSelected = selectedValue == option;

        return ChoiceChip(
          label: Text(labelFor(option)),

          selected: isSelected,

          onSelected: (_) {
            debugPrint('Selected option: $option');

            onSelected(option);
          },

          labelStyle: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.brandGray,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontFamily: AppTextStyles.fontFamily,
          ),

          selectedColor: AppColors.primaryContainer,

          backgroundColor: Colors.white,

          side: BorderSide(
            color: isSelected
                ? AppColors.primary
                : AppColors.brandGray.withOpacity(0.25),
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final genderLabels = {'ذكر': l10n.male, 'أنثى': l10n.female};
    final socialStatusLabels = {
      'أعزب': l10n.single,
      'متزوج': l10n.married,
      'أرمل': l10n.widowed,
      'مطلق': l10n.divorced,
    };
    final jobStatusLabels = {
      'يعمل': l10n.working,
      'عاطل عن العمل': l10n.notWorking,
    };

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,

        elevation: 0,

        scrolledUnderElevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_forward, color: AppColors.primary),
        ),

        title: Text(
          l10n.applicantInfoTitle,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontFamily: AppTextStyles.fontFamily,
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // الاسم الأول
                CustomTextField(
                  label: l10n.firstName,
                  hint: l10n.lastNameHint,
                  controller: _firstNameController,
                  validator: (String? value) {
                    return _requiredTextValidator(value, l10n.firstName);
                  },
                ),

                const SizedBox(height: 16),

                // اسم الأب
                CustomTextField(
                  label: l10n.fatherName,
                  hint: l10n.fatherNameHint,
                  controller: _fatherNameController,
                  validator: (String? value) {
                    return _requiredTextValidator(value, l10n.fatherName);
                  },
                ),

                const SizedBox(height: 16),

                // الكنية
                CustomTextField(
                  label: l10n.familyName,
                  hint: l10n.familyNameHint,
                  controller: _lastNameController,
                  validator: (String? value) {
                    return _requiredTextValidator(value, l10n.familyName);
                  },
                ),

                const SizedBox(height: 16),

                // العمر
                CustomTextField(
                  label: l10n.age,
                  hint: l10n.ageHint,
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  isLtr: true,
                  validator: _validateAge,
                ),

                const SizedBox(height: 24),

                // الجنس
                _buildSectionTitle(l10n.gender),

                _buildChoiceChips(
                  options: _genderOptions,
                  selectedValue: _selectedGender,
                  labelFor: (value) => genderLabels[value] ?? value,
                  onSelected: (String value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // الحالة الاجتماعية
                _buildSectionTitle(l10n.socialStatus),

                _buildChoiceChips(
                  options: _socialStatusOptions,
                  selectedValue: _selectedSocialStatus,
                  labelFor: (value) => socialStatusLabels[value] ?? value,
                  onSelected: (String value) {
                    setState(() {
                      _selectedSocialStatus = value;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // الحالة الوظيفية
                _buildSectionTitle(l10n.jobStatus),

                _buildChoiceChips(
                  options: _jobStatusOptions,
                  selectedValue: _selectedJobStatus,
                  labelFor: (value) => jobStatusLabels[value] ?? value,
                  onSelected: (String value) {
                    setState(() {
                      _selectedJobStatus = value;
                    });
                  },
                ),

                const SizedBox(height: 24),

                // رقم الهاتف
                CustomTextField(
                  label: l10n.phoneNumber,
                  hint: '+963 9xxxxxxxx',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  suffixIcon: Icons.phone_outlined,
                  isLtr: true,
                  validator: _validatePhone,
                ),

                const SizedBox(height: 16),

                // العنوان
                CustomTextField(
                  label: l10n.address,
                  hint: l10n.addressHint,
                  controller: _addressController,
                  suffixIcon: Icons.location_on_outlined,
                  maxLines: 2,
                  validator: (String? value) {
                    return _requiredTextValidator(value, l10n.address);
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      // زر المتابعة أسفل الصفحة
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),

            border: Border(
              top: BorderSide(color: AppColors.brandGray.withOpacity(0.1)),
            ),
          ),

          child: ElevatedButton(
            onPressed: _continueToRequestDetails,

            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryContainer,

              foregroundColor: AppColors.primary,

              minimumSize: const Size(double.infinity, 56),

              elevation: 0,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  l10n.continueButton,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTextStyles.fontFamily,
                  ),
                ),

                const SizedBox(width: 10),

                const Icon(Icons.arrow_back),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
