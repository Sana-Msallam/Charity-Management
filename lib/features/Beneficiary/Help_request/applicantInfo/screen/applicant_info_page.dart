import 'package:charity_management/features/Beneficiary/Help_request/applicantInfo/model/applicant_info_model.dart';

import 'package:charity_management/features/Beneficiary/Help_request/education_request/cubit/education_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/education_request/screen/education_request_page.dart';
import 'package:charity_management/features/Beneficiary/Help_request/education_request/service/education_request_service.dart';

import 'package:charity_management/features/Beneficiary/Help_request/food_request/cubit/food_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/food_request/screen/food_request_page.dart';
import 'package:charity_management/features/Beneficiary/Help_request/food_request/service/food_request_service.dart';

import 'package:charity_management/features/Beneficiary/Help_request/health_request/cubit/health_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/screen/health_request_page.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/service/health_request_service.dart';

import 'package:charity_management/features/Beneficiary/Help_request/housing_request/cubit/housing_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/housing_request/screen/housing_request_page.dart';
import 'package:charity_management/features/Beneficiary/Help_request/housing_request/service/housing_request_service.dart';
import 'package:charity_management/features/Beneficiary/Help_request/smaal_project_request/cubit/small_project_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/smaal_project_request/screen/small_project_screen.dart';
import 'package:charity_management/features/Beneficiary/Help_request/smaal_project_request/service/small_project_service.dart';
import 'package:charity_management/features/components/custom_step_Indicator.dart';
import 'package:charity_management/features/components/education_components.dart';

import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/widgets/custom_text_field.dart';

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _fatherNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _ageController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _addressArController = TextEditingController();

  final TextEditingController _addressEnController = TextEditingController();
  String? _selectedGender;
  String? _selectedSocialStatus;
  String? _selectedJobStatus;

  final List<String> _genderOptions = ['ذكر', 'أنثى'];

  final List<String> _socialStatusOptions = ['أعزب', 'متزوج', 'أرمل', 'مطلق'];

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
    _firstNameController.dispose();
    _fatherNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _addressArController.dispose();
    _addressEnController.dispose();
    debugPrint('ApplicantInfoPage disposed');

    super.dispose();
  }

  void _continueToRequestDetails() {
    debugPrint('======================================');
    debugPrint('Continue button clicked');

    FocusScope.of(context).unfocus();

    final bool isFormValid = _formKey.currentState?.validate() ?? false;

    debugPrint('Form validation result: $isFormValid');

    debugPrint('Selected gender: $_selectedGender');

    debugPrint(
      'Selected social status: '
      '$_selectedSocialStatus',
    );

    debugPrint(
      'Selected job status: '
      '$_selectedJobStatus',
    );

    if (!isFormValid) {
      _showMessage('يرجى التأكد من تعبئة جميع البيانات بشكل صحيح');

      return;
    }

    if (_selectedGender == null) {
      _showMessage('يرجى اختيار الجنس');

      return;
    }

    if (_selectedSocialStatus == null) {
      _showMessage('يرجى اختيار الحالة الاجتماعية');

      return;
    }

    if (_selectedJobStatus == null) {
      _showMessage('يرجى اختيار الحالة الوظيفية');

      return;
    }

    final int? age = int.tryParse(_ageController.text.trim());

    if (age == null || age <= 0 || age > 120) {
      _showMessage('يرجى إدخال عمر صحيح');

      return;
    }

    final ApplicantInfoModel applicantInfo = ApplicantInfoModel(
      firstName: _firstNameController.text.trim(),

      fatherName: _fatherNameController.text.trim(),

      lastName: _lastNameController.text.trim(),

      age: age,

      gender: _selectedGender!,

      socialStatus: _selectedSocialStatus!,

      phoneNumber: _phoneController.text.trim(),

      addressAr: _addressArController.text.trim(),

      addressEn: _addressEnController.text.trim(),

      isUnemployed: _selectedJobStatus == 'عاطل عن العمل',
    );

    _printApplicantInfo(applicantInfo);

    final String normalizedRequestType = widget.requestType.trim();

    debugPrint(
      'Normalized request type: '
      '$normalizedRequestType',
    );

    if (normalizedRequestType == 'صحي') {
      _openHealthRequestPage(applicantInfo);

      return;
    }

    if (normalizedRequestType == 'تعليمي') {
      _openEducationRequestPage(applicantInfo);

      return;
    }

    if (normalizedRequestType == 'سكني' || normalizedRequestType == 'سكن') {
      _openHousingRequestPage(applicantInfo);

      return;
    }

    if (normalizedRequestType == 'غذائي' || normalizedRequestType == 'غذاء') {
      _openFoodRequestPage(applicantInfo);

      return;
    }
    if (normalizedRequestType == 'مشروع صغير' ||
        normalizedRequestType == 'مشاريع صغيرة' ||
        normalizedRequestType == 'مشروع' ||
        normalizedRequestType == 'دعم المشاريع') {
      _openSmallProjectRequestPage(applicantInfo);

      return;
    }

    debugPrint(
      'Unsupported request type: '
      '$normalizedRequestType',
    );

    _showMessage('نوع الطلب غير مدعوم حالياً');
  }

  void _openHealthRequestPage(ApplicantInfoModel applicantInfo) {
    debugPrint('======================================');
    debugPrint('Opening HealthRequestPage');
    debugPrint('======================================');

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
  }

  void _openEducationRequestPage(ApplicantInfoModel applicantInfo) {
    debugPrint('======================================');
    debugPrint('Opening EducationRequestPage');
    debugPrint('======================================');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider(
            create: (_) {
              return EducationCubit(EducationRequestService());
            },
            child: EducationRequestPage(applicantInfo: applicantInfo),
          );
        },
      ),
    );
  }

  void _openHousingRequestPage(ApplicantInfoModel applicantInfo) {
    debugPrint('======================================');
    debugPrint('Opening HousingRequestPage');
    debugPrint('======================================');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider(
            create: (_) {
              return HousingCubit(HousingRequestService());
            },
            child: HousingRequestPage(applicantInfo: applicantInfo),
          );
        },
      ),
    );
  }

  void _openFoodRequestPage(ApplicantInfoModel applicantInfo) {
    debugPrint('======================================');
    debugPrint('Opening FoodRequestPage');
    debugPrint('======================================');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider(
            create: (_) {
              return FoodCubit(FoodRequestService());
            },
            child: FoodRequestPage(applicantInfo: applicantInfo),
          );
        },
      ),
    );
  }

  void _openSmallProjectRequestPage(ApplicantInfoModel applicantInfo) {
    debugPrint('======================================');
    debugPrint('Opening SmallProjectRequestPage');
    debugPrint('======================================');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider(
            create: (_) {
              return SmallProjectCubit(SmallProjectRequestService());
            },
            child: SmallProjectRequestPage(applicantInfo: applicantInfo),
          );
        },
      ),
    );
  }

  void _printApplicantInfo(ApplicantInfoModel applicantInfo) {
    debugPrint('======================================');
    debugPrint('ApplicantInfoModel created');

    debugPrint('firstName: ${applicantInfo.firstName}');

    debugPrint('fatherName: ${applicantInfo.fatherName}');

    debugPrint('lastName: ${applicantInfo.lastName}');

    debugPrint('age: ${applicantInfo.age}');

    debugPrint('gender: ${applicantInfo.gender}');

    debugPrint(
      'socialStatus: '
      '${applicantInfo.socialStatus}',
    );

    debugPrint(
      'phoneNumber: '
      '${applicantInfo.phoneNumber}',
    );

    debugPrint('addressAr: ${applicantInfo.addressAr}');

    debugPrint('addressEn: ${applicantInfo.addressEn}');

    debugPrint(
      'isUnemployed: '
      '${applicantInfo.isUnemployed}',
    );

    debugPrint('======================================');
  }

  String? _validateArabicText(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'يرجى إدخال العنوان باللغة العربية';
    }

    if (RegExp(r'[A-Za-z]').hasMatch(text)) {
      return 'يرجى كتابة العنوان بالعربية فقط';
    }

    return null;
  }

  String? _validateEnglishText(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Please enter the address in English';
    }

    if (RegExp(r'[\u0600-\u06FF]').hasMatch(text)) {
      return 'Please write the address in English only';
    }

    return null;
  }

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          content: Text(
            message,
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
          ),
        ),
      );
  }

  String? _requiredTextValidator(String? value, String fieldName) {
    final String text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'يرجى إدخال $fieldName';
    }

    if (text.length < 2) {
      return '$fieldName قصير جداً';
    }

    return null;
  }

  String? _validateAge(String? value) {
    final String text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'يرجى إدخال العمر';
    }

    final int? age = int.tryParse(text);

    if (age == null) {
      return 'يرجى إدخال العمر بالأرقام';
    }

    if (age <= 0 || age > 120) {
      return 'يرجى إدخال عمر صحيح';
    }

    return null;
  }

  String? _validatePhone(String? value) {
    final String text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'يرجى إدخال رقم الهاتف';
    }

    final String normalizedPhone = text.replaceAll(' ', '').replaceAll('-', '');

    final RegExp phonePattern = RegExp(r'^[0-9+]{7,15}$');

    if (!phonePattern.hasMatch(normalizedPhone)) {
      return 'يرجى إدخال رقم هاتف صحيح';
    }

    return null;
  }

  IconData _getRequestIcon() {
    final String type = widget.requestType.trim();

    if (type == 'صحي') {
      return Icons.health_and_safety_outlined;
    }

    if (type == 'تعليمي') {
      return Icons.school_outlined;
    }

    if (type == 'سكني' || type == 'سكن') {
      return Icons.home_work_outlined;
    }

    if (type == 'غذائي' || type == 'غذاء') {
      return Icons.shopping_basket_outlined;
    }
    if (type == 'مشروع صغير' ||
        type == 'مشاريع صغيرة' ||
        type == 'مشروع' ||
        type == 'دعم المشاريع') {
      return Icons.storefront_outlined;
    }

    return Icons.volunteer_activism_outlined;
  }

  String _getRequestTitle() {
    final String type = widget.requestType.trim();

    if (type.isEmpty) {
      return 'طلب مساعدة';
    }

    return 'طلب $type';
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.45),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.18),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(_getRequestIcon(), color: AppColors.primary, size: 28),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getRequestTitle(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTextStyles.fontFamily,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'أدخل معلومات مقدم الطلب بدقة، ثم انتقل إلى تفاصيل المساعدة المطلوبة.',
                  style: TextStyle(
                    color: AppColors.brandGray,
                    fontSize: 13,
                    height: 1.5,
                    fontFamily: AppTextStyles.fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.brandGray.withOpacity(0.16),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 21),
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTextStyles.fontFamily,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ...children,
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 10),
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

  Widget _buildChoiceChips({
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((String option) {
        final bool isSelected = selectedValue == option;

        return InkWell(
          onTap: () {
            onSelected(option);
          },
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryContainer.withOpacity(0.75)
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.brandGray.withOpacity(0.3),
                width: isSelected ? 1.5 : 1.15,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.brandGray.withOpacity(0.55),
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 13, color: Colors.white)
                      : null,
                ),

                const SizedBox(width: 8),

                Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.brandGray,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontFamily: AppTextStyles.fontFamily,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildResponsiveFields({
    required Widget first,
    required Widget second,
  }) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth >= 600) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: first),

              const SizedBox(width: 16),

              Expanded(child: second),
            ],
          );
        }

        return Column(children: [first, const SizedBox(height: 16), second]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,

        appBar: AppBar(
          backgroundColor: AppColors.background,

          elevation: 0,

          scrolledUnderElevation: 0,

          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.brandGray.withOpacity(0.2)),
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),

          title: const Text(
            'معلومات مقدم الطلب',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 19,
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
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

              padding: const EdgeInsets.fromLTRB(18, 12, 18, 120),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(),

                  const SizedBox(height: 18),

                  const CustomStepIndicator(currentStep: 1, totalSteps: 2),

                  const SizedBox(height: 20),

                  _buildSectionCard(
                    title: 'المعلومات الشخصية',

                    icon: Icons.person_outline,

                    children: [
                      _buildResponsiveFields(
                        first: CustomTextField(
                          label: 'الاسم الأول',

                          hint: 'مثال: محمد',

                          controller: _firstNameController,

                          suffixIcon: Icons.person_outline,

                          validator: (String? value) {
                            return _requiredTextValidator(value, 'الاسم الأول');
                          },
                        ),

                        second: CustomTextField(
                          label: 'اسم الأب',

                          hint: 'مثال: أحمد',

                          controller: _fatherNameController,

                          suffixIcon: Icons.badge_outlined,

                          validator: (String? value) {
                            return _requiredTextValidator(value, 'اسم الأب');
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      _buildResponsiveFields(
                        first: CustomTextField(
                          label: 'الكنية',

                          hint: 'مثال: الدرويش',

                          controller: _lastNameController,

                          suffixIcon: Icons.people_outline,

                          validator: (String? value) {
                            return _requiredTextValidator(value, 'الكنية');
                          },
                        ),

                        second: CustomTextField(
                          label: 'العمر',

                          hint: 'مثال: 35',

                          controller: _ageController,

                          keyboardType: TextInputType.number,

                          suffixIcon: Icons.calendar_today_outlined,

                          isLtr: true,

                          validator: _validateAge,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _buildSectionCard(
                    title: 'الحالة الشخصية',

                    icon: Icons.assignment_ind_outlined,

                    children: [
                      _buildSectionTitle('الجنس'),

                      _buildChoiceChips(
                        options: _genderOptions,

                        selectedValue: _selectedGender,

                        onSelected: (String value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                      ),

                      const SizedBox(height: 22),

                      _buildSectionTitle('الحالة الاجتماعية'),

                      _buildChoiceChips(
                        options: _socialStatusOptions,

                        selectedValue: _selectedSocialStatus,

                        onSelected: (String value) {
                          setState(() {
                            _selectedSocialStatus = value;
                          });
                        },
                      ),

                      const SizedBox(height: 22),

                      _buildSectionTitle('الحالة الوظيفية'),

                      _buildChoiceChips(
                        options: _jobStatusOptions,

                        selectedValue: _selectedJobStatus,

                        onSelected: (String value) {
                          setState(() {
                            _selectedJobStatus = value;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  _buildSectionCard(
                    title: 'معلومات التواصل',

                    icon: Icons.contact_phone_outlined,

                    children: [
                      CustomTextField(
                        label: 'رقم الهاتف',

                        hint: '+963 9xxxxxxxx',

                        controller: _phoneController,

                        keyboardType: TextInputType.phone,

                        suffixIcon: Icons.phone_outlined,

                        isLtr: true,

                        validator: _validatePhone,
                      ),

                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'العنوان (عربي)',
                        hint: 'مثال: دمشق - المزة - الشارع الرئيسي',
                        controller: _addressArController,
                        suffixIcon: Icons.location_on_outlined,
                        maxLines: 2,
                        validator: _validateArabicText,
                      ),

                      const SizedBox(height: 16),

                      CustomTextField(
                        label: 'Address (English)',
                        hint: 'Example: Damascus - Al Mazzeh - Main Street',
                        controller: _addressEnController,
                        suffixIcon: Icons.location_on_outlined,
                        maxLines: 2,
                        isLtr: true,
                        validator: _validateEnglishText,
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  const EducationalDecorativeCard(),
                ],
              ),
            ),
          ),
        ),

        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.97),
              border: Border(
                top: BorderSide(color: AppColors.brandGray.withOpacity(0.12)),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 14,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _continueToRequestDetails,

              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,

                foregroundColor: Colors.white,

                minimumSize: const Size(double.infinity, 58),

                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),

              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'متابعة إلى تفاصيل الطلب',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTextStyles.fontFamily,
                    ),
                  ),

                  SizedBox(width: 10),

                  Icon(Icons.arrow_back, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
