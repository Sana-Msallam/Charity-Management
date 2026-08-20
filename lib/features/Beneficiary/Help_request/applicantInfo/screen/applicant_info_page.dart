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

import 'package:charity_management/features/Beneficiary/profile/model/profile_model.dart';
import 'package:charity_management/features/Beneficiary/profile/service/profile_service.dart';

import 'package:charity_management/features/Beneficiary/request_tracking/model/request_details_model.dart';

import 'package:charity_management/features/components/custom_step_Indicator.dart';
import 'package:charity_management/features/components/education_components.dart';

import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/widgets/custom_text_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ApplicantInfoPage extends StatefulWidget {
  const ApplicantInfoPage({
    super.key,
    required this.requestType,
    this.requestDetails,
  });

  final String requestType;
  final RequestDetailsModel? requestDetails;

  bool get isEditMode => requestDetails != null;

  @override
  State<ApplicantInfoPage> createState() {
    return _ApplicantInfoPageState();
  }
}

class _ApplicantInfoPageState extends State<ApplicantInfoPage> {
  static const String _selfApplicant = 'SELF';
  static const String _otherApplicant = 'OTHER';

  static const String _male = 'MALE';
  static const String _female = 'FEMALE';

  static const String _single = 'SINGLE';
  static const String _married = 'MARRIED';
  static const String _widowed = 'WIDOWED';
  static const String _divorced = 'DIVORCED';

  static const String _employed = 'EMPLOYED';
  static const String _unemployed = 'UNEMPLOYED';

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController _firstNameController =
      TextEditingController();

  final TextEditingController _fatherNameController =
      TextEditingController();

  final TextEditingController _lastNameController =
      TextEditingController();

  final TextEditingController _ageController =
      TextEditingController();

  final TextEditingController _phoneController =
      TextEditingController();

  final TextEditingController _addressArController =
      TextEditingController();

  final TextEditingController _addressEnController =
      TextEditingController();

  String? _selectedGender;
  String? _selectedSocialStatus;
  String? _selectedJobStatus;
  String? _selectedApplicantType;

  bool _isLoadingProfile = false;

  // =================================================
  // INIT
  // =================================================

  @override
  void initState() {
    super.initState();

    debugPrint('======================================');
    debugPrint('ApplicantInfoPage opened');
    debugPrint('Request type: ${widget.requestType}');
    debugPrint('Edit mode: ${widget.isEditMode}');
    debugPrint(
      'Request id: ${widget.requestDetails?.id}',
    );
    debugPrint('======================================');

    if (widget.isEditMode) {
      _fillExistingApplicantInfo();
    }
  }

  // =================================================
  // FILL EXISTING REQUEST
  // =================================================

  void _fillExistingApplicantInfo() {
    final RequestDetailsModel? request =
        widget.requestDetails;

    if (request == null) {
      return;
    }

    _firstNameController.text =
        request.firstName;

    _fatherNameController.text =
        request.beneficiaryFatherName;

    _lastNameController.text =
        request.lastName;

    _ageController.text =
        request.age.toString();

    _phoneController.text =
        request.number;

    _addressArController.text =
        request.addressAr;

    _addressEnController.text =
        request.addressEn;

    _selectedGender =
        _mapGenderFromApi(
      request.gender,
    );

    _selectedSocialStatus =
        _mapSocialStatusFromApi(
      request.socialStatus,
    );

    _selectedJobStatus =
        request.isUnemployed
            ? _unemployed
            : _employed;
  }

  // =================================================
  // SELECT APPLICANT TYPE
  // =================================================

  Future<void> _selectApplicantType(
    String value,
  ) async {
    if (widget.isEditMode) {
      return;
    }

    debugPrint(
      'Applicant type selected: $value',
    );

    if (value == _otherApplicant) {
      setState(() {
        _selectedApplicantType = value;
        _isLoadingProfile = false;

        _clearApplicantInfo();
      });

      return;
    }

    if (value == _selfApplicant) {
      if (_isLoadingProfile) {
        debugPrint(
          'Profile is already loading. '
          'Duplicate request ignored.',
        );

        return;
      }

      setState(() {
        _selectedApplicantType = value;

        _clearApplicantInfo();

        _isLoadingProfile = true;
      });

      await _loadMyProfile();
    }
  }

  // =================================================
  // LOAD MY PROFILE
  // =================================================

  Future<void> _loadMyProfile() async {
    try {
      final ProfileService profileService =
          ProfileService();

      final List<ProfileModel> profiles =
          await Future.wait<ProfileModel>(
        <Future<ProfileModel>>[
          profileService.getProfile(
            languageCode: 'ar',
          ),
          profileService.getProfile(
            languageCode: 'en',
          ),
        ],
      );

      final ProfileModel profileAr =
          profiles[0];

      final ProfileModel profileEn =
          profiles[1];

      if (!mounted ||
          _selectedApplicantType !=
              _selfApplicant) {
        return;
      }

      final String languageCode =
          Localizations.localeOf(context)
              .languageCode;

      final bool isArabic =
          languageCode == 'ar';

      setState(() {
        _firstNameController.text =
            profileAr.firstName;

        // اسم الأب غير موجود بالبروفايل.
        _fatherNameController.text =
            isArabic
                ? 'محمد'
                : 'Mohammad';

        _lastNameController.text =
            profileAr.lastName;

        _ageController.text =
            profileAr.age?.toString() ?? '';

        _phoneController.text =
            profileAr.number;

        _addressArController.text =
            profileAr.address;

        _addressEnController.text =
            profileEn.address;

        _selectedGender =
            _mapGenderFromApi(
          profileAr.gender,
        );

        _selectedSocialStatus =
            _mapSocialStatusFromApi(
          profileAr.socialStatus,
        );

        _selectedJobStatus =
            profileAr.isUnemployed
                ? _unemployed
                : _employed;

        _isLoadingProfile = false;
      });

      debugPrint(
        'Applicant form auto-filled successfully',
      );

      debugPrint(
        'Address AR: ${_addressArController.text}',
      );

      debugPrint(
        'Address EN: ${_addressEnController.text}',
      );
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'AUTO-FILL PROFILE ERROR: $error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingProfile = false;
      });

      _showMessage(
        AppLocalizations.of(context)
            .profileAutoFillError,
      );
    }
  }

  // =================================================
  // CLEAR
  // =================================================

  void _clearApplicantInfo() {
    _firstNameController.clear();
    _fatherNameController.clear();
    _lastNameController.clear();
    _ageController.clear();
    _phoneController.clear();
    _addressArController.clear();
    _addressEnController.clear();

    _selectedGender = null;
    _selectedSocialStatus = null;
    _selectedJobStatus = null;
  }

  // =================================================
  // MAP API VALUES
  // =================================================

  String? _mapGenderFromApi(
    String value,
  ) {
    switch (value.trim().toUpperCase()) {
      case 'MALE':
        return _male;

      case 'FEMALE':
        return _female;

      default:
        return null;
    }
  }

  String? _mapSocialStatusFromApi(
    String value,
  ) {
    switch (value.trim().toUpperCase()) {
      case 'SINGLE':
        return _single;

      case 'MARRIED':
        return _married;

      case 'WIDOWED':
      case 'WIDOW':
        return _widowed;

      case 'DIVORCED':
        return _divorced;

      default:
        return null;
    }
  }

  // =================================================
  // LEGACY VALUES FOR APPLICANT MODEL
  //
  // نحافظ على القيم السابقة التي كانت تُمرر
  // لباقي صفحات الطلبات.
  // =================================================

  String _genderForApplicantModel() {
    switch (_selectedGender) {
      case _male:
        return 'ذكر';

      case _female:
        return 'أنثى';

      default:
        return '';
    }
  }

  String _socialStatusForApplicantModel() {
    switch (_selectedSocialStatus) {
      case _single:
        return 'أعزب';

      case _married:
        return 'متزوج';

      case _widowed:
        return 'أرمل';

      case _divorced:
        return 'مطلق';

      default:
        return '';
    }
  }

  // =================================================
  // DISPOSE
  // =================================================

  @override
  void dispose() {
    _firstNameController.dispose();
    _fatherNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _addressArController.dispose();
    _addressEnController.dispose();

    super.dispose();
  }

  // =================================================
  // CONTINUE
  // =================================================

  void _continueToRequestDetails() {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    FocusScope.of(context).unfocus();

    if (!widget.isEditMode &&
        _selectedApplicantType == null) {
      _showMessage(
        l10n.selectApplicantType,
      );

      return;
    }

    if (!widget.isEditMode &&
        _isLoadingProfile) {
      _showMessage(
        l10n.waitForProfileLoading,
      );

      return;
    }

    final bool isFormValid =
        _formKey.currentState?.validate() ??
            false;

    if (!isFormValid) {
      _showMessage(
        l10n.fillAllDataCorrectly,
      );

      return;
    }

    if (_selectedGender == null) {
      _showMessage(
        l10n.selectGender,
      );

      return;
    }

    if (_selectedSocialStatus == null) {
      _showMessage(
        l10n.selectSocialStatus,
      );

      return;
    }

    if (_selectedJobStatus == null) {
      _showMessage(
        l10n.selectJobStatus,
      );

      return;
    }

    final int? age =
        int.tryParse(
      _ageController.text.trim(),
    );

    if (age == null ||
        age <= 0 ||
        age > 120) {
      _showMessage(
        l10n.invalidAge,
      );

      return;
    }

    final ApplicantInfoModel applicantInfo =
        ApplicantInfoModel(
      firstName:
          _firstNameController.text.trim(),

      fatherName:
          _fatherNameController.text.trim(),

      lastName:
          _lastNameController.text.trim(),

      age: age,

      gender:
          _genderForApplicantModel(),

      socialStatus:
          _socialStatusForApplicantModel(),

      phoneNumber:
          _phoneController.text.trim(),

      addressAr:
          _addressArController.text.trim(),

      addressEn:
          _addressEnController.text.trim(),

      isUnemployed:
          _selectedJobStatus ==
              _unemployed,
    );

    _printApplicantInfo(
      applicantInfo,
    );

    final String normalizedRequestType =
        widget.requestType.trim();

    if (normalizedRequestType == 'صحي' ||
        normalizedRequestType
                .toLowerCase() ==
            'health') {
      _openHealthRequestPage(
        applicantInfo,
      );

      return;
    }

    if (normalizedRequestType ==
            'تعليمي' ||
        normalizedRequestType
                .toLowerCase() ==
            'education') {
      _openEducationRequestPage(
        applicantInfo,
      );

      return;
    }

    if (normalizedRequestType ==
            'سكني' ||
        normalizedRequestType == 'سكن' ||
        normalizedRequestType
                .toLowerCase() ==
            'housing') {
      _openHousingRequestPage(
        applicantInfo,
      );

      return;
    }

    if (normalizedRequestType ==
            'غذائي' ||
        normalizedRequestType == 'غذاء' ||
        normalizedRequestType
                .toLowerCase() ==
            'food') {
      _openFoodRequestPage(
        applicantInfo,
      );

      return;
    }

    if (normalizedRequestType
            .contains('مشروع') ||
        normalizedRequestType
            .contains('مشاريع') ||
        normalizedRequestType
            .toLowerCase()
            .contains('project')) {
      _openSmallProjectRequestPage(
        applicantInfo,
      );

      return;
    }

    _showMessage(
      l10n.unsupportedRequestType,
    );
  }

  // =================================================
  // NAVIGATION
  // =================================================

  void _openHealthRequestPage(
    ApplicantInfoModel applicantInfo,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider(
            create: (_) {
              return HealthCubit(
                HealthRequestService(),
              );
            },
            child: HealthRequestPage(
              applicantInfo: applicantInfo,
              requestDetails:
                  widget.requestDetails,
            ),
          );
        },
      ),
    );
  }

  void _openEducationRequestPage(
    ApplicantInfoModel applicantInfo,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider(
            create: (_) {
              return EducationCubit(
                EducationRequestService(),
              );
            },
            child: EducationRequestPage(
              applicantInfo: applicantInfo,
              requestDetails:
                  widget.requestDetails,
            ),
          );
        },
      ),
    );
  }

  void _openHousingRequestPage(
    ApplicantInfoModel applicantInfo,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider(
            create: (_) {
              return HousingCubit(
                HousingRequestService(),
              );
            },
            child: HousingRequestPage(
              applicantInfo: applicantInfo,
              requestDetails:
                  widget.requestDetails,
            ),
          );
        },
      ),
    );
  }

  void _openFoodRequestPage(
    ApplicantInfoModel applicantInfo,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider(
            create: (_) {
              return FoodCubit(
                FoodRequestService(),
              );
            },
            child: FoodRequestPage(
              applicantInfo: applicantInfo,
              requestDetails:
                  widget.requestDetails,
            ),
          );
        },
      ),
    );
  }

  void _openSmallProjectRequestPage(
    ApplicantInfoModel applicantInfo,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return BlocProvider(
            create: (_) {
              return SmallProjectCubit(
                SmallProjectRequestService(),
              );
            },
            child: SmallProjectRequestPage(
              applicantInfo: applicantInfo,
              requestDetails:
                  widget.requestDetails,
            ),
          );
        },
      ),
    );
  }

  // =================================================
  // DEBUG
  // =================================================

  void _printApplicantInfo(
    ApplicantInfoModel applicantInfo,
  ) {
    debugPrint('======================================');
    debugPrint('ApplicantInfoModel created');
    debugPrint(
      'Edit mode: ${widget.isEditMode}',
    );
    debugPrint(
      'Applicant type: $_selectedApplicantType',
    );
    debugPrint(
      'firstName: ${applicantInfo.firstName}',
    );
    debugPrint(
      'fatherName: ${applicantInfo.fatherName}',
    );
    debugPrint(
      'lastName: ${applicantInfo.lastName}',
    );
    debugPrint(
      'age: ${applicantInfo.age}',
    );
    debugPrint(
      'gender: ${applicantInfo.gender}',
    );
    debugPrint(
      'socialStatus: ${applicantInfo.socialStatus}',
    );
    debugPrint(
      'phoneNumber: ${applicantInfo.phoneNumber}',
    );
    debugPrint(
      'addressAr: ${applicantInfo.addressAr}',
    );
    debugPrint(
      'addressEn: ${applicantInfo.addressEn}',
    );
    debugPrint(
      'isUnemployed: ${applicantInfo.isUnemployed}',
    );
    debugPrint('======================================');
  }

  // =================================================
  // VALIDATORS
  // =================================================

  String? _validateArabicText(
    String? value,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String text =
        value?.trim() ?? '';

    if (text.isEmpty) {
      return l10n.arabicAddressRequired;
    }

    if (RegExp(r'[A-Za-z]')
        .hasMatch(text)) {
      return l10n.arabicAddressOnly;
    }

    return null;
  }

  String? _validateEnglishText(
    String? value,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String text =
        value?.trim() ?? '';

    if (text.isEmpty) {
      return l10n.englishAddressRequired;
    }

    if (RegExp(
      r'[\u0600-\u06FF]',
    ).hasMatch(text)) {
      return l10n.englishAddressOnly;
    }

    return null;
  }

  String? _requiredTextValidator(
    String? value,
    String fieldName,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String text =
        value?.trim() ?? '';

    if (text.isEmpty) {
      return l10n.requiredField(
        fieldName,
      );
    }

    if (text.length < 2) {
      return l10n.fieldTooShort(
        fieldName,
      );
    }

    return null;
  }

  String? _validateAge(
    String? value,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String text =
        value?.trim() ?? '';

    if (text.isEmpty) {
      return l10n.ageRequired;
    }

    final int? age =
        int.tryParse(text);

    if (age == null) {
      return l10n.ageNumbersOnly;
    }

    if (age <= 0 ||
        age > 120) {
      return l10n.invalidAge;
    }

    return null;
  }

  String? _validatePhone(
    String? value,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String text =
        value?.trim() ?? '';

    if (text.isEmpty) {
      return l10n.phoneRequiredApplicant;
    }

    final String normalizedPhone =
        text
            .replaceAll(' ', '')
            .replaceAll('-', '');

    final RegExp phonePattern =
        RegExp(
      r'^[0-9+]{7,15}$',
    );

    if (!phonePattern.hasMatch(
      normalizedPhone,
    )) {
      return l10n.phoneValidRequired;
    }

    return null;
  }

  // =================================================
  // MESSAGE
  // =================================================

  void _showMessage(
    String message,
  ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior:
              SnackBarBehavior.floating,
          margin:
              const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontFamily:
                  AppTextStyles.fontFamily,
            ),
          ),
        ),
      );
  }

  // =================================================
  // REQUEST TYPE
  // =================================================

  String _localizedRequestType(
    AppLocalizations l10n,
  ) {
    final String type =
        widget.requestType.trim();

    if (type == 'صحي' ||
        type.toLowerCase() ==
            'health') {
      return l10n.health;
    }

    if (type == 'تعليمي' ||
        type.toLowerCase() ==
            'education') {
      return l10n.education;
    }

    if (type == 'سكني' ||
        type == 'سكن' ||
        type.toLowerCase() ==
            'housing') {
      return l10n.housing;
    }

    if (type == 'غذائي' ||
        type == 'غذاء' ||
        type.toLowerCase() ==
            'food') {
      return l10n.food;
    }

    if (type.contains('مشروع') ||
        type.contains('مشاريع') ||
        type
            .toLowerCase()
            .contains('project')) {
      return l10n.projectSupport;
    }

    return type;
  }

  IconData _getRequestIcon() {
    final String type =
        widget.requestType.trim();

    if (type == 'صحي' ||
        type.toLowerCase() ==
            'health') {
      return Icons
          .health_and_safety_outlined;
    }

    if (type == 'تعليمي' ||
        type.toLowerCase() ==
            'education') {
      return Icons.school_outlined;
    }

    if (type == 'سكني' ||
        type == 'سكن' ||
        type.toLowerCase() ==
            'housing') {
      return Icons.home_work_outlined;
    }

    if (type == 'غذائي' ||
        type == 'غذاء' ||
        type.toLowerCase() ==
            'food') {
      return Icons
          .shopping_basket_outlined;
    }

    if (type.contains('مشروع') ||
        type.contains('مشاريع') ||
        type
            .toLowerCase()
            .contains('project')) {
      return Icons.storefront_outlined;
    }

    return Icons
        .volunteer_activism_outlined;
  }

  String _getRequestTitle(
    AppLocalizations l10n,
  ) {
    final String type =
        _localizedRequestType(
      l10n,
    );

    if (type.trim().isEmpty) {
      return widget.isEditMode
          ? l10n.editAidRequestTitle
          : l10n.aidRequestTitle;
    }

    if (widget.isEditMode) {
      return l10n.editAidRequestWithType(
        type,
      );
    }

    return l10n.aidRequestWithType(
      type,
    );
  }

  // =================================================
  // HEADER
  // =================================================

  Widget _buildHeaderCard() {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer
            .withOpacity(0.45),
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary
              .withOpacity(0.18),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColors.primary
                  .withOpacity(0.12),
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),
            child: Icon(
              _getRequestIcon(),
              color: AppColors.primary,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  _getRequestTitle(
                    l10n,
                  ),
                  style:
                      const TextStyle(
                    color:
                        AppColors.primary,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                    fontFamily:
                        AppTextStyles
                            .fontFamily,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  widget.isEditMode
                      ? l10n
                          .applicantEditDescription
                      : l10n
                          .applicantCreateDescription,
                  style:
                      const TextStyle(
                    color: AppColors
                        .brandGray,
                    fontSize: 13,
                    height: 1.5,
                    fontFamily:
                        AppTextStyles
                            .fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =================================================
  // SECTION CARD
  // =================================================

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.brandGray
              .withOpacity(0.16),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.03),
            blurRadius: 14,
            offset:
                const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration:
                    BoxDecoration(
                  color: AppColors
                      .primaryContainer
                      .withOpacity(0.55),
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),
                child: Icon(
                  icon,
                  color:
                      AppColors.primary,
                  size: 21,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: Text(
                  title,
                  style:
                      const TextStyle(
                    color: AppColors
                        .onSurface,
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                    fontFamily:
                        AppTextStyles
                            .fontFamily,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 20,
          ),

          ...children,
        ],
      ),
    );
  }

  // =================================================
  // APPLICANT TYPE CARD
  // =================================================

  Widget _buildApplicantTypeCard() {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final List<_ChoiceOption>
        options =
        <_ChoiceOption>[
      _ChoiceOption(
        value: _selfApplicant,
        label: l10n.selfApplicant,
      ),
      _ChoiceOption(
        value: _otherApplicant,
        label: l10n.otherApplicant,
      ),
    ];

    return _buildSectionCard(
      title:
          l10n.whoIsRequestFor,
      icon:
          Icons.people_alt_outlined,
      children: [
        Text(
          l10n
              .chooseApplicantBeforeFilling,
          style: const TextStyle(
            color:
                AppColors.brandGray,
            fontSize: 13,
            height: 1.5,
            fontFamily:
                AppTextStyles.fontFamily,
          ),
        ),

        const SizedBox(
          height: 14,
        ),

        _buildChoiceChips(
          options: options,
          selectedValue:
              _selectedApplicantType,
          onSelected:
              _selectApplicantType,
        ),

        if (_isLoadingProfile) ...[
          const SizedBox(
            height: 16,
          ),

          Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                  color:
                      AppColors.primary,
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child: Text(
                  l10n.loadingProfileData,
                  style:
                      const TextStyle(
                    color: AppColors
                        .brandGray,
                    fontSize: 13,
                    fontFamily:
                        AppTextStyles
                            .fontFamily,
                  ),
                ),
              ),
            ],
          ),
        ],

        if (_selectedApplicantType ==
                _selfApplicant &&
            !_isLoadingProfile) ...[
          const SizedBox(
            height: 14,
          ),

          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(12),
            decoration:
                BoxDecoration(
              color: AppColors
                  .primaryContainer
                  .withOpacity(0.3),
              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline,
                  color:
                      AppColors.primary,
                  size: 19,
                ),

                const SizedBox(
                  width: 8,
                ),

                Expanded(
                  child: Text(
                    l10n.profileAutoFilled,
                    style:
                        const TextStyle(
                      color: AppColors
                          .brandGray,
                      fontSize: 12.5,
                      height: 1.5,
                      fontFamily:
                          AppTextStyles
                              .fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // =================================================
  // SECTION TITLE
  // =================================================

  Widget _buildSectionTitle(
    String title,
  ) {
    return Padding(
      padding:
          const EdgeInsetsDirectional
              .only(
        start: 4,
        bottom: 10,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color:
              AppColors.brandGray,
          fontSize: 14,
          fontWeight:
              FontWeight.w600,
          fontFamily:
              AppTextStyles.fontFamily,
        ),
      ),
    );
  }

  // =================================================
  // CHOICE CHIPS
  // =================================================

  Widget _buildChoiceChips({
    required List<_ChoiceOption> options,
    required String? selectedValue,
    required ValueChanged<String>
        onSelected,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map(
        (
          _ChoiceOption option,
        ) {
          final bool isSelected =
              selectedValue ==
                  option.value;

          return InkWell(
            onTap: () {
              onSelected(
                option.value,
              );
            },
            borderRadius:
                BorderRadius.circular(
              14,
            ),
            child:
                AnimatedContainer(
              duration:
                  const Duration(
                milliseconds: 180,
              ),
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 18,
                vertical: 11,
              ),
              decoration:
                  BoxDecoration(
                color: isSelected
                    ? AppColors
                        .primaryContainer
                        .withOpacity(
                          0.75,
                        )
                    : Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors
                          .brandGray
                          .withOpacity(
                            0.3,
                          ),
                  width:
                      isSelected
                          ? 1.5
                          : 1.15,
                ),
              ),
              child: Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds:
                          180,
                    ),
                    width: 18,
                    height: 18,
                    decoration:
                        BoxDecoration(
                      shape:
                          BoxShape.circle,
                      color: isSelected
                          ? AppColors
                              .primary
                          : Colors
                              .transparent,
                      border:
                          Border.all(
                        color: isSelected
                            ? AppColors
                                .primary
                            : AppColors
                                .brandGray
                                .withOpacity(
                                  0.55,
                                ),
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 13,
                            color:
                                Colors.white,
                          )
                        : null,
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  Text(
                    option.label,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors
                              .primary
                          : AppColors
                              .brandGray,
                      fontSize: 13,
                      fontWeight:
                          isSelected
                              ? FontWeight
                                  .bold
                              : FontWeight
                                  .w500,
                      fontFamily:
                          AppTextStyles
                              .fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  // =================================================
  // RESPONSIVE
  // =================================================

  Widget _buildResponsiveFields({
    required Widget first,
    required Widget second,
  }) {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        if (constraints.maxWidth >=
            600) {
          return Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Expanded(
                child: first,
              ),

              const SizedBox(
                width: 16,
              ),

              Expanded(
                child: second,
              ),
            ],
          );
        }

        return Column(
          children: [
            first,

            const SizedBox(
              height: 16,
            ),

            second,
          ],
        );
      },
    );
  }

  // =================================================
  // BUILD
  // =================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final List<_ChoiceOption>
        genderOptions =
        <_ChoiceOption>[
      _ChoiceOption(
        value: _male,
        label: l10n.male,
      ),
      _ChoiceOption(
        value: _female,
        label: l10n.female,
      ),
    ];

    final List<_ChoiceOption>
        socialStatusOptions =
        <_ChoiceOption>[
      _ChoiceOption(
        value: _single,
        label: l10n.single,
      ),
      _ChoiceOption(
        value: _married,
        label: l10n.married,
      ),
      _ChoiceOption(
        value: _widowed,
        label: l10n.widowed,
      ),
      _ChoiceOption(
        value: _divorced,
        label: l10n.divorced,
      ),
    ];

    final List<_ChoiceOption>
        jobStatusOptions =
        <_ChoiceOption>[
      _ChoiceOption(
        value: _employed,
        label: l10n.employed,
      ),
      _ChoiceOption(
        value: _unemployed,
        label: l10n.unemployed,
      ),
    ];

    return Scaffold(
      backgroundColor:
          AppColors.background,

      appBar: AppBar(
        backgroundColor:
            AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Container(
            width: 40,
            height: 40,
            decoration:
                BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(
                12,
              ),
              border: Border.all(
                color: AppColors
                    .brandGray
                    .withOpacity(0.2),
              ),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              color:
                  AppColors.primary,
              size: 20,
            ),
          ),
        ),

        title: Text(
          widget.isEditMode
              ? l10n.editApplicantInfo
              : l10n.applicantInfoTitle,
          style: const TextStyle(
            color:
                AppColors.primary,
            fontSize: 19,
            fontWeight:
                FontWeight.bold,
            fontFamily:
                AppTextStyles.fontFamily,
          ),
        ),

        centerTitle: true,
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child:
              SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior
                    .onDrag,
            padding:
                const EdgeInsets
                    .fromLTRB(
              18,
              12,
              18,
              120,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _buildHeaderCard(),

                const SizedBox(
                  height: 18,
                ),

                const CustomStepIndicator(
                  currentStep: 1,
                  totalSteps: 2,
                ),

                const SizedBox(
                  height: 20,
                ),

                if (!widget
                    .isEditMode) ...[
                  _buildApplicantTypeCard(),

                  const SizedBox(
                    height: 18,
                  ),
                ],

                // ===================================
                // PERSONAL INFORMATION
                // ===================================

                _buildSectionCard(
                  title:
                      l10n.personalInformation,
                  icon:
                      Icons.person_outline,
                  children: [
                    _buildResponsiveFields(
                      first:
                          CustomTextField(
                        label:
                            l10n.firstName,
                        hint:
                            l10n.firstNameHint,
                        controller:
                            _firstNameController,
                        suffixIcon:
                            Icons
                                .person_outline,
                        validator: (
                          String? value,
                        ) {
                          return _requiredTextValidator(
                            value,
                            l10n.firstName,
                          );
                        },
                      ),

                      second:
                          CustomTextField(
                        label:
                            l10n.fatherName,
                        hint:
                            l10n.fatherNameHint,
                        controller:
                            _fatherNameController,
                        suffixIcon:
                            Icons
                                .badge_outlined,
                        validator: (
                          String? value,
                        ) {
                          return _requiredTextValidator(
                            value,
                            l10n.fatherName,
                          );
                        },
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    _buildResponsiveFields(
                      first:
                          CustomTextField(
                        label:
                            l10n.familyName,
                        hint:
                            l10n.familyNameHint,
                        controller:
                            _lastNameController,
                        suffixIcon:
                            Icons
                                .people_outline,
                        validator: (
                          String? value,
                        ) {
                          return _requiredTextValidator(
                            value,
                            l10n.familyName,
                          );
                        },
                      ),

                      second:
                          CustomTextField(
                        label:
                            l10n.age,
                        hint:
                            l10n.ageHint,
                        controller:
                            _ageController,
                        keyboardType:
                            TextInputType
                                .number,
                        suffixIcon:
                            Icons
                                .calendar_today_outlined,
                        isLtr: true,
                        validator:
                            _validateAge,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 18,
                ),

                // ===================================
                // PERSONAL STATUS
                // ===================================

                _buildSectionCard(
                  title:
                      l10n.personalStatus,
                  icon: Icons
                      .assignment_ind_outlined,
                  children: [
                    _buildSectionTitle(
                      l10n.gender,
                    ),

                    _buildChoiceChips(
                      options:
                          genderOptions,
                      selectedValue:
                          _selectedGender,
                      onSelected: (
                        String value,
                      ) {
                        setState(() {
                          _selectedGender =
                              value;
                        });
                      },
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    _buildSectionTitle(
                      l10n.socialStatus,
                    ),

                    _buildChoiceChips(
                      options:
                          socialStatusOptions,
                      selectedValue:
                          _selectedSocialStatus,
                      onSelected: (
                        String value,
                      ) {
                        setState(() {
                          _selectedSocialStatus =
                              value;
                        });
                      },
                    ),

                    const SizedBox(
                      height: 22,
                    ),

                    _buildSectionTitle(
                      l10n.employmentStatus,
                    ),

                    _buildChoiceChips(
                      options:
                          jobStatusOptions,
                      selectedValue:
                          _selectedJobStatus,
                      onSelected: (
                        String value,
                      ) {
                        setState(() {
                          _selectedJobStatus =
                              value;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(
                  height: 18,
                ),

                // ===================================
                // CONTACT
                // ===================================

                _buildSectionCard(
                  title:
                      l10n.contactInformation,
                  icon: Icons
                      .contact_phone_outlined,
                  children: [
                    CustomTextField(
                      label:
                          l10n.phoneNumber,
                      hint:
                          '+963 9xxxxxxxx',
                      controller:
                          _phoneController,
                      keyboardType:
                          TextInputType.phone,
                      suffixIcon:
                          Icons.phone_outlined,
                      isLtr: true,
                      validator:
                          _validatePhone,
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    CustomTextField(
                      label: l10n
                          .arabicAddressLabel,
                      hint: l10n
                          .arabicAddressExample,
                      controller:
                          _addressArController,
                      suffixIcon:
                          Icons
                              .location_on_outlined,
                      maxLines: 2,
                      validator:
                          _validateArabicText,
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    CustomTextField(
                      label: l10n
                          .englishAddressLabel,
                      hint: l10n
                          .englishAddressExample,
                      controller:
                          _addressEnController,
                      suffixIcon:
                          Icons
                              .location_on_outlined,
                      maxLines: 2,
                      isLtr: true,
                      validator:
                          _validateEnglishText,
                    ),
                  ],
                ),

                const SizedBox(
                  height: 18,
                ),

                const EducationalDecorativeCard(),
              ],
            ),
          ),
        ),
      ),

      // ==========================================
      // BOTTOM BUTTON
      // ==========================================

      bottomNavigationBar:
          SafeArea(
        child: Container(
          padding:
              const EdgeInsets.fromLTRB(
            18,
            12,
            18,
            16,
          ),
          decoration:
              BoxDecoration(
            color:
                Colors.white.withOpacity(
              0.97,
            ),
            border: Border(
              top: BorderSide(
                color: AppColors
                    .brandGray
                    .withOpacity(
                  0.12,
                ),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(
                  0.04,
                ),
                blurRadius: 14,
                offset:
                    const Offset(
                  0,
                  -4,
                ),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed:
                _isLoadingProfile
                    ? null
                    : _continueToRequestDetails,
            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  AppColors.primary,
              foregroundColor:
                  Colors.white,
              disabledBackgroundColor:
                  AppColors.primary
                      .withOpacity(
                0.55,
              ),
              disabledForegroundColor:
                  Colors.white,
              minimumSize:
                  const Size(
                double.infinity,
                58,
              ),
              elevation: 0,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
            ),
            child:
                _isLoadingProfile
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child:
                            CircularProgressIndicator(
                          strokeWidth:
                              2.3,
                          color:
                              Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          Text(
                            widget.isEditMode
                                ? l10n
                                    .continueToEditRequestDetails
                                : l10n
                                    .continueToRequestDetails,
                            style:
                                const TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight
                                      .bold,
                              fontFamily:
                                  AppTextStyles
                                      .fontFamily,
                            ),
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          const Icon(
                            Icons
                                .arrow_forward_rounded,
                            size: 20,
                          ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }
}

// =====================================================
// CHOICE OPTION
//
// القيمة ثابتة للمنطق.
// label فقط يتغير حسب اللغة.
// =====================================================

class _ChoiceOption {
  const _ChoiceOption({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;
}