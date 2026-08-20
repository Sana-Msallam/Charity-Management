import 'package:charity_management/features/Beneficiary/Help_request/applicantInfo/model/applicant_info_model.dart';

import 'package:charity_management/features/Beneficiary/Help_request/housing_request/cubit/housing_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/housing_request/cubit/housing_state.dart';
import 'package:charity_management/features/Beneficiary/Help_request/housing_request/model/housing_request_model.dart';
import 'package:charity_management/features/Beneficiary/Help_request/housing_request/model/housing_sub_category.dart';
import 'package:charity_management/features/Beneficiary/request_tracking/model/request_details_model.dart';
import 'package:charity_management/features/components/custom_attachment_uploader.dart';
import 'package:charity_management/features/components/custom_step_Indicator.dart';
import 'package:charity_management/features/components/request_result_dialog.dart';
import 'package:charity_management/features/components/selection_chip.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';

import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/widgets/custom_text_field.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HousingRequestPage extends StatefulWidget {
  const HousingRequestPage({
    super.key,
    required this.applicantInfo,
    this.requestDetails,
  });

  final ApplicantInfoModel applicantInfo;
  final RequestDetailsModel? requestDetails;

  bool get isEditMode => requestDetails != null;

  @override
  State<HousingRequestPage> createState() {
    return _HousingRequestPageState();
  }
}

class _HousingRequestPageState extends State<HousingRequestPage> {
  /*
   * الحقول المشتركة:
   * details
   * cost
   * media
   */
  final TextEditingController _detailsArController = TextEditingController();

  final TextEditingController _detailsEnController = TextEditingController();

  final TextEditingController _costController = TextEditingController();

  final List<PlatformFile> _attachments = [];
  final List<String> _existingMediaUrls = [];

  /*
   * subCategoryId = 1
   * تأمين منزل
   */
  final TextEditingController _currentPlaceOfResidenceArController =
      TextEditingController();

  final TextEditingController _currentPlaceOfResidenceEnController =
      TextEditingController();

  final TextEditingController _reasonForLockArController =
      TextEditingController();

  final TextEditingController _reasonForLockEnController =
      TextEditingController();

  final TextEditingController _housingSpecificationsArController =
      TextEditingController();

  final TextEditingController _housingSpecificationsEnController =
      TextEditingController();

  /*
   * subCategoryId = 2
   * مساعدة في إيجار البيت
   */
  final TextEditingController _currentRentController = TextEditingController();

  /*
   * subCategoryId = 3
   * إصلاحات منزلية
   */
  final TextEditingController _currentHousingSituationArController =
      TextEditingController();

  final TextEditingController _currentHousingSituationEnController =
      TextEditingController();

  /*
   * لا يوجد اختيار افتراضي.
   * لذلك لن تظهر الحقول قبل اختيار المستخدم.
   */
  HousingSubCategory? _selectedSubCategory;

  @override
  void initState() {
    super.initState();

    debugPrint('======================================');
    debugPrint('HousingRequestPage opened');
    debugPrint('Applicant data received:');

    debugPrint('First name: ${widget.applicantInfo.firstName}');

    debugPrint('Father name: ${widget.applicantInfo.fatherName}');

    debugPrint('Last name: ${widget.applicantInfo.lastName}');

    debugPrint('Age: ${widget.applicantInfo.age}');

    debugPrint('Gender: ${widget.applicantInfo.gender}');

    debugPrint(
      'Social status: '
      '${widget.applicantInfo.socialStatus}',
    );

    debugPrint(
      'Phone number: '
      '${widget.applicantInfo.phoneNumber}',
    );

    debugPrint('Address AR: ${widget.applicantInfo.addressAr}');

    debugPrint('Address EN: ${widget.applicantInfo.addressEn}');

    debugPrint(
      'Is unemployed: '
      '${widget.applicantInfo.isUnemployed}',
    );

    if (widget.isEditMode) {
      _fillExistingHousingData();
    }

    debugPrint('======================================');
  }

  void _fillExistingHousingData() {
    final RequestDetailsModel? request = widget.requestDetails;

    if (request == null) {
      return;
    }

    debugPrint('======================================');
    debugPrint('FILL EXISTING HOUSING DATA');
    debugPrint('Request id: ${request.id}');
    debugPrint('Category id: ${request.categoryId}');
    debugPrint('Subcategory id: ${request.subCategoryId}');

    if (request.categoryId != 3) {
      debugPrint(
        'Unexpected category id for housing edit: ${request.categoryId}',
      );
    }

    final int? subCategoryId = request.subCategoryId;

    for (final HousingSubCategory subCategory in HousingSubCategory.values) {
      if (subCategory.apiId == subCategoryId) {
        _selectedSubCategory = subCategory;
        break;
      }
    }

    _detailsArController.text = request.detailsAr ?? '';
    _detailsEnController.text = request.detailsEn ?? '';
    _costController.text = _formatNumber(request.cost);

    _existingMediaUrls
      ..clear()
      ..addAll(request.getAidDetailStringList('mediaUrls'));

    switch (_selectedSubCategory) {
      case HousingSubCategory.homeProvision:
        _currentPlaceOfResidenceArController.text =
            request.getAidDetailStringAr('currentPlaceOfResidence') ?? '';
        _currentPlaceOfResidenceEnController.text =
            request.getAidDetailStringEn('currentPlaceOfResidence') ?? '';
        _reasonForLockArController.text =
            request.getAidDetailStringAr('reasonForLock') ?? '';
        _reasonForLockEnController.text =
            request.getAidDetailStringEn('reasonForLock') ?? '';
        _housingSpecificationsArController.text =
            request.getAidDetailStringAr('housingSpecifications') ?? '';
        _housingSpecificationsEnController.text =
            request.getAidDetailStringEn('housingSpecifications') ?? '';
        break;

      case HousingSubCategory.rentAssistance:
        _currentRentController.text =
            request.getAidDetailStringAr('currentRent') ?? '';
        break;

      case HousingSubCategory.homeRepairs:
        _currentHousingSituationArController.text =
            request.getAidDetailStringAr('currentHousingSituation') ?? '';
        _currentHousingSituationEnController.text =
            request.getAidDetailStringEn('currentHousingSituation') ?? '';
        break;

      case null:
        debugPrint(
          'Unable to restore HousingSubCategory from id: $subCategoryId',
        );
        break;
    }

    debugPrint('Restored subcategory: ${_selectedSubCategory?.name}');
    debugPrint('Existing media: $_existingMediaUrls');
    debugPrint('======================================');
  }

  String _formatNumber(double value) {
    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  @override
  void dispose() {
    _detailsArController.dispose();
    _detailsEnController.dispose();
    _costController.dispose();

    _currentPlaceOfResidenceArController.dispose();
    _currentPlaceOfResidenceEnController.dispose();
    _reasonForLockArController.dispose();
    _reasonForLockEnController.dispose();
    _housingSpecificationsArController.dispose();
    _housingSpecificationsEnController.dispose();

    _currentRentController.dispose();

    _currentHousingSituationArController.dispose();
    _currentHousingSituationEnController.dispose();

    debugPrint('HousingRequestPage disposed');

    super.dispose();
  }

  void _selectSubCategory(HousingSubCategory subCategory) {
    debugPrint('======================================');
    debugPrint('Housing subcategory selected');
    debugPrint('Subcategory name: ${subCategory.name}');
    debugPrint('API id: ${subCategory.apiId}');
    debugPrint('======================================');

    setState(() {
      _selectedSubCategory = subCategory;

      /*
       * ننظف حقول الأنواع الأخرى حتى لا تبقى
       * بيانات قديمة عند تغيير الاختيار.
       */
      switch (subCategory) {
        case HousingSubCategory.homeProvision:
          _currentRentController.clear();
          _currentHousingSituationArController.clear();
          _currentHousingSituationEnController.clear();
          break;

        case HousingSubCategory.rentAssistance:
          _currentPlaceOfResidenceArController.clear();
          _currentPlaceOfResidenceEnController.clear();
          _reasonForLockArController.clear();
          _reasonForLockEnController.clear();
          _housingSpecificationsArController.clear();
          _housingSpecificationsEnController.clear();
          _currentHousingSituationArController.clear();
          _currentHousingSituationEnController.clear();
          break;

        case HousingSubCategory.homeRepairs:
          _currentPlaceOfResidenceArController.clear();
          _currentPlaceOfResidenceEnController.clear();
          _reasonForLockArController.clear();
          _reasonForLockEnController.clear();
          _housingSpecificationsArController.clear();
          _housingSpecificationsEnController.clear();
          _currentRentController.clear();
          break;
      }
    });
  }

  String _housingSubCategoryLabel(
    HousingSubCategory subCategory,
    AppLocalizations l10n,
  ) {
    switch (subCategory) {
      case HousingSubCategory.homeProvision:
        return l10n.homeProvision;
      case HousingSubCategory.rentAssistance:
        return l10n.rentAssistance;
      case HousingSubCategory.homeRepairs:
        return l10n.homeRepairs;
    }
  }

  Future<void> _pickAttachments() async {
    final AppLocalizations l10n = AppLocalizations.of(context);

    debugPrint('======================================');
    debugPrint('Housing attachment picker opened');

    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],

        /*
         * على Web نحتاج bytes.
         * على Android نستخدم path.
         */
        withData: kIsWeb,
      );

      if (result == null) {
        debugPrint('Attachment selection cancelled');

        debugPrint('======================================');
        return;
      }

      if (!mounted) {
        debugPrint('Widget is not mounted after file selection');

        return;
      }

      debugPrint(
        'Selected platform files count: '
        '${result.files.length}',
      );

      for (final PlatformFile file in result.files) {
        debugPrint('Selected file information:');
        debugPrint('Name: ${file.name}');
        debugPrint('Path: ${file.path}');
        debugPrint('Size: ${file.size} bytes');
        debugPrint('Extension: ${file.extension}');
        debugPrint('Bytes available: ${file.bytes != null}');
      }

      final List<PlatformFile> selectedFiles = result.files.where((
        PlatformFile newFile,
      ) {
        final bool alreadyExists = _attachments.any((
          PlatformFile existingFile,
        ) {
          return existingFile.name == newFile.name &&
              existingFile.size == newFile.size;
        });

        return !alreadyExists;
      }).toList();

      if (selectedFiles.isEmpty) {
        debugPrint('All selected files already exist');

        _showValidationMessage(l10n.duplicateFiles);

        return;
      }

      final List<PlatformFile> validFiles = [];

      for (final PlatformFile file in selectedFiles) {
        if (kIsWeb) {
          if (file.bytes == null || file.bytes!.isEmpty) {
            debugPrint(
              'Web file bytes are missing: '
              '${file.name}',
            );

            continue;
          }
        } else {
          if (file.path == null || file.path!.trim().isEmpty) {
            debugPrint(
              'Mobile file path is missing: '
              '${file.name}',
            );

            continue;
          }
        }

        validFiles.add(file);
      }

      if (validFiles.isEmpty) {
        debugPrint('No valid accessible files found');

        _showValidationMessage(l10n.filesAccessFailed);

        return;
      }

      setState(() {
        _attachments.addAll(validFiles);
      });

      debugPrint(
        'Housing files added: '
        '${validFiles.length}',
      );

      debugPrint(
        'Total housing attachments: '
        '${_attachments.length}',
      );

      debugPrint('======================================');
    } catch (error, stackTrace) {
      debugPrint('Housing attachment picker error');

      debugPrint('Error: $error');

      debugPrint('Stack trace: $stackTrace');

      debugPrint('======================================');

      if (mounted) {
        _showValidationMessage(l10n.fileSelectionFailed);
      }
    }
  }

  void _removeAttachment(int index) {
    if (index < 0 || index >= _attachments.length) {
      debugPrint('Invalid attachment index: $index');

      return;
    }

    final PlatformFile removedFile = _attachments[index];

    setState(() {
      _attachments.removeAt(index);
    });

    debugPrint(
      'Housing attachment removed: '
      '${removedFile.name}',
    );

    debugPrint(
      'Remaining attachments: '
      '${_attachments.length}',
    );
  }

  void _submit() {
    final AppLocalizations l10n = AppLocalizations.of(context);

    debugPrint('======================================');
    debugPrint('HousingRequestPage: Submit clicked');

    FocusScope.of(context).unfocus();

    if (_selectedSubCategory == null) {
      debugPrint(
        'Validation failed: '
        'Subcategory is missing',
      );

      _showValidationMessage(l10n.selectHousingAidType);

      return;
    }

    final String detailsAr = _detailsArController.text.trim();

    final String detailsEn = _detailsEnController.text.trim();

    final String costText = _costController.text.trim();

    final String normalizedCostText = costText.replaceAll(',', '.');

    final double? cost = double.tryParse(normalizedCostText);

    debugPrint(
      'Selected subcategory: '
      '${_selectedSubCategory!.name}',
    );

    debugPrint(
      'Selected subcategory API id: '
      '${_selectedSubCategory!.apiId}',
    );

    debugPrint('Details AR: $detailsAr');

    debugPrint('Details EN: $detailsEn');

    debugPrint('Raw cost: $costText');

    debugPrint('Parsed cost: $cost');

    debugPrint(
      'Existing attachments count: '
      '${_existingMediaUrls.length}',
    );

    debugPrint(
      'New attachments count: '
      '${_attachments.length}',
    );

    /*
     * نتحقق أولًا من حقول الـ subCategory.
     */
    switch (_selectedSubCategory!) {
      case HousingSubCategory.homeProvision:
        final String currentPlaceAr = _currentPlaceOfResidenceArController.text
            .trim();
        final String currentPlaceEn = _currentPlaceOfResidenceEnController.text
            .trim();

        final String reasonAr = _reasonForLockArController.text.trim();
        final String reasonEn = _reasonForLockEnController.text.trim();

        final String specificationsAr = _housingSpecificationsArController.text
            .trim();
        final String specificationsEn = _housingSpecificationsEnController.text
            .trim();

        final String? currentPlaceArError = _validateArabicLocalizedField(
          currentPlaceAr,
          l10n.currentResidenceDetails,
        );
        if (currentPlaceArError != null) {
          _showValidationMessage(currentPlaceArError);
          return;
        }

        final String? currentPlaceEnError = _validateEnglishLocalizedField(
          currentPlaceEn,
          l10n.currentResidenceDetails,
        );
        if (currentPlaceEnError != null) {
          _showValidationMessage(currentPlaceEnError);
          return;
        }

        final String? reasonArError = _validateArabicLocalizedField(
          reasonAr,
          l10n.housingSupportReason,
        );
        if (reasonArError != null) {
          _showValidationMessage(reasonArError);
          return;
        }

        final String? reasonEnError = _validateEnglishLocalizedField(
          reasonEn,
          l10n.housingSupportReason,
        );
        if (reasonEnError != null) {
          _showValidationMessage(reasonEnError);
          return;
        }

        final String? specificationsArError = _validateArabicLocalizedField(
          specificationsAr,
          l10n.requestedHousingSpecs,
        );
        if (specificationsArError != null) {
          _showValidationMessage(specificationsArError);
          return;
        }

        final String? specificationsEnError = _validateEnglishLocalizedField(
          specificationsEn,
          l10n.requestedHousingSpecs,
        );
        if (specificationsEnError != null) {
          _showValidationMessage(specificationsEnError);
          return;
        }

        break;

      case HousingSubCategory.rentAssistance:
        final String currentRentText = _currentRentController.text.trim();

        final double? currentRent = double.tryParse(
          currentRentText.replaceAll(',', '.'),
        );

        if (currentRent == null || currentRent <= 0) {
          _showValidationMessage(l10n.validCurrentRent);

          return;
        }

        break;

      case HousingSubCategory.homeRepairs:
        final String housingSituationAr = _currentHousingSituationArController
            .text
            .trim();
        final String housingSituationEn = _currentHousingSituationEnController
            .text
            .trim();

        final String? housingSituationArError = _validateArabicLocalizedField(
          housingSituationAr,
          l10n.currentHousingSituation,
        );
        if (housingSituationArError != null) {
          _showValidationMessage(housingSituationArError);
          return;
        }

        final String? housingSituationEnError = _validateEnglishLocalizedField(
          housingSituationEn,
          l10n.currentHousingSituation,
        );
        if (housingSituationEnError != null) {
          _showValidationMessage(housingSituationEnError);
          return;
        }

        break;
    }

    /*
     * التحقق من الحقول المشتركة.
     */
    final String? arabicDetailsError = _validateArabicDetails(detailsAr);

    if (arabicDetailsError != null) {
      debugPrint('Validation failed: $arabicDetailsError');

      _showValidationMessage(arabicDetailsError);

      return;
    }

    final String? englishDetailsError = _validateEnglishDetails(detailsEn);

    if (englishDetailsError != null) {
      debugPrint('Validation failed: $englishDetailsError');

      _showValidationMessage(englishDetailsError);

      return;
    }

    if (cost == null || cost <= 0) {
      debugPrint('Validation failed: Invalid cost');

      _showValidationMessage(l10n.validCostRequired);

      return;
    }

    final bool hasExistingMedia = _existingMediaUrls.isNotEmpty;
    final bool hasNewMedia = _attachments.isNotEmpty;

    if (!hasExistingMedia && !hasNewMedia) {
      debugPrint('Validation failed: No attachments');

      _showValidationMessage(l10n.housingDocumentRequired);

      return;
    }

    double? currentRent;

    if (_selectedSubCategory == HousingSubCategory.rentAssistance) {
      currentRent = double.tryParse(
        _currentRentController.text.trim().replaceAll(',', '.'),
      );
    }

    final HousingRequestModel request = HousingRequestModel(
      applicantInfo: widget.applicantInfo,

      subCategory: _selectedSubCategory!,

      detailsAr: detailsAr,

      detailsEn: detailsEn,

      cost: cost,

      media: List<PlatformFile>.unmodifiable(_attachments),

      /*
       * حقول subCategoryId = 1
       */
      currentPlaceOfResidenceAr:
          _selectedSubCategory == HousingSubCategory.homeProvision
          ? _currentPlaceOfResidenceArController.text.trim()
          : null,

      currentPlaceOfResidenceEn:
          _selectedSubCategory == HousingSubCategory.homeProvision
          ? _currentPlaceOfResidenceEnController.text.trim()
          : null,

      reasonForLockAr: _selectedSubCategory == HousingSubCategory.homeProvision
          ? _reasonForLockArController.text.trim()
          : null,

      reasonForLockEn: _selectedSubCategory == HousingSubCategory.homeProvision
          ? _reasonForLockEnController.text.trim()
          : null,

      housingSpecificationsAr:
          _selectedSubCategory == HousingSubCategory.homeProvision
          ? _housingSpecificationsArController.text.trim()
          : null,

      housingSpecificationsEn:
          _selectedSubCategory == HousingSubCategory.homeProvision
          ? _housingSpecificationsEnController.text.trim()
          : null,

      /*
       * حقل subCategoryId = 2
       */
      currentRent: _selectedSubCategory == HousingSubCategory.rentAssistance
          ? currentRent
          : null,

      /*
       * حقل subCategoryId = 3
       */
      currentHousingSituationAr:
          _selectedSubCategory == HousingSubCategory.homeRepairs
          ? _currentHousingSituationArController.text.trim()
          : null,

      currentHousingSituationEn:
          _selectedSubCategory == HousingSubCategory.homeRepairs
          ? _currentHousingSituationEnController.text.trim()
          : null,
    );

    debugPrint('HousingRequestModel created successfully');

    debugPrint(
      'Request subCategoryId: '
      '${request.subCategory.apiId}',
    );

    debugPrint('Request details AR: ${request.detailsAr}');

    debugPrint('Request details EN: ${request.detailsEn}');

    debugPrint('Request cost: ${request.cost}');

    debugPrint(
      'Request currentPlaceOfResidence: '
      '${request.currentPlaceOfResidenceAr}',
    );

    debugPrint(
      'Request reasonForLock: '
      '${request.reasonForLockAr}',
    );

    debugPrint(
      'Request housingSpecifications: '
      '${request.housingSpecificationsAr}',
    );

    debugPrint(
      'Request currentRent: '
      '${request.currentRent}',
    );

    debugPrint(
      'Request currentHousingSituation: '
      '${request.currentHousingSituationAr}',
    );

    debugPrint(
      'Request media count: '
      '${request.media.length}',
    );

    for (final PlatformFile file in request.media) {
      debugPrint('Request attachment: ${file.name}');
    }

    if (widget.isEditMode) {
      final int? requestId = widget.requestDetails?.id;

      if (requestId == null) {
        _showValidationMessage(l10n.requestIdUnavailable);
        return;
      }

      debugPrint('Calling HousingCubit.updateHousingRequest');
      debugPrint('======================================');

      context.read<HousingCubit>().updateHousingRequest(
        requestId: requestId,
        request: request,
      );
      return;
    }

    debugPrint('Calling HousingCubit.submitHousingRequest');

    debugPrint('======================================');

    context.read<HousingCubit>().submitHousingRequest(request);
  }

  String? _validateArabicDetails(String value) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return _validateArabicLocalizedField(
      value,
      l10n.housingRequestDetails,
      minimumLength: 5,
    );
  }

  String? _validateEnglishDetails(String value) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    return _validateEnglishLocalizedField(
      value,
      l10n.housingRequestDetails,
      minimumLength: 5,
    );
  }

  String? _validateArabicLocalizedField(
    String value,
    String fieldName, {
    int minimumLength = 2,
  }) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String text = value.trim();

    if (text.isEmpty) {
      return l10n.enterFieldInArabic(fieldName);
    }

    if (text.length < minimumLength) {
      return l10n.fieldTooShort(fieldName);
    }

    if (!RegExp(r'[\u0600-\u06FF]').hasMatch(text) ||
        RegExp(r'[A-Za-z]').hasMatch(text)) {
      return l10n.fieldArabicOnly(fieldName);
    }

    return null;
  }

  String? _validateEnglishLocalizedField(
    String value,
    String fieldName, {
    int minimumLength = 2,
  }) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String text = value.trim();

    if (text.isEmpty) {
      return l10n.enterFieldInEnglish(fieldName);
    }

    if (text.length < minimumLength) {
      return l10n.fieldTooShort(fieldName);
    }

    if (!RegExp(r'[A-Za-z]').hasMatch(text) ||
        RegExp(r'[\u0600-\u06FF]').hasMatch(text)) {
      return l10n.fieldEnglishOnly(fieldName);
    }

    return null;
  }

  void _showValidationMessage(String message) {
    if (!mounted) {
      debugPrint(
        'Cannot show SnackBar: '
        'widget is not mounted',
      );

      return;
    }

    debugPrint('Showing SnackBar: $message');

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
            style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
          ),
        ),
      );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 4, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.brandGray,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: AppTextStyles.fontFamily,
        ),
      ),
    );
  }

  Widget _buildSubCategoryFields(bool isLoading) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final HousingSubCategory? selected = _selectedSubCategory;

    if (selected == null) {
      return const SizedBox.shrink();
    }

    switch (selected) {
      case HousingSubCategory.homeProvision:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*_buildSectionLabel(
              'بيانات تأمين المنزل',
            ),*/
            CustomTextField(
              label: l10n.currentResidenceArabic,
              hint: l10n.currentResidenceArabicHint,
              controller: _currentPlaceOfResidenceArController,
              maxLines: 2,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              label: l10n.currentResidenceEnglish,
              hint: l10n.currentResidenceEnglishHint,
              controller: _currentPlaceOfResidenceEnController,
              maxLines: 2,
              isLtr: true,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              label: l10n.housingSupportReasonArabic,
              hint: l10n.housingSupportReasonArabicHint,
              controller: _reasonForLockArController,
              maxLines: 4,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              label: l10n.housingSupportReasonEnglish,
              hint: l10n.housingSupportReasonEnglishHint,
              controller: _reasonForLockEnController,
              maxLines: 4,
              isLtr: true,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              label: l10n.requestedHousingSpecsArabic,
              hint: l10n.requestedHousingSpecsArabicHint,
              controller: _housingSpecificationsArController,
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              label: l10n.requestedHousingSpecsEnglish,
              hint: l10n.requestedHousingSpecsEnglishHint,
              controller: _housingSpecificationsEnController,
              maxLines: 3,
              isLtr: true,
            ),
          ],
        );

      case HousingSubCategory.rentAssistance:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*   _buildSectionLabel(
              'بيانات مساعدة الإيجار',
            ),*/
            CustomTextField(
              label: l10n.currentRentValue,
              hint: '250',
              controller: _currentRentController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              isCurrency: true,
            ),
          ],
        );

      case HousingSubCategory.homeRepairs:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*_buildSectionLabel(
              'بيانات الإصلاحات المنزلية',
            ),*/
            CustomTextField(
              label: l10n.currentHousingSituationArabic,
              hint: l10n.currentHousingSituationArabicHint,
              controller: _currentHousingSituationArController,
              maxLines: 5,
            ),

            const SizedBox(height: 16),

            CustomTextField(
              label: l10n.currentHousingSituationEnglish,
              hint: l10n.currentHousingSituationEnglishHint,
              controller: _currentHousingSituationEnController,
              maxLines: 5,
              isLtr: true,
            ),
          ],
        );
    }
  }

  Widget _buildCommonFields(bool isLoading) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    if (_selectedSubCategory == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        /* _buildSectionLabel(
          'البيانات المشتركة للطلب',
        ),*/
        CustomTextField(
          label: l10n.housingDetailsArabic,
          hint: l10n.housingDetailsArabicHint,
          controller: _detailsArController,
          maxLines: 5,
        ),

        const SizedBox(height: 16),

        CustomTextField(
          label: l10n.housingDetailsEnglish,
          hint: l10n.housingDetailsEnglishHint,
          controller: _detailsEnController,
          maxLines: 5,
          isLtr: true,
        ),

        const SizedBox(height: 24),

        CustomTextField(
          label: l10n.expectedHousingCost,
          hint: '0.00',
          controller: _costController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          isCurrency: true,
        ),

        const SizedBox(height: 24),

        _buildSectionLabel(l10n.attachProofDocuments),

        if (_existingMediaUrls.isNotEmpty) ...[
          _buildExistingAttachmentsSection(),
          const SizedBox(height: 16),
        ],

        CustomAttachmentUploader(
          title: widget.isEditMode
              ? l10n.addNewDocuments
              : l10n.uploadFilesOrCapture,
          description: widget.isEditMode
              ? l10n.addNewFilesDescription
              : l10n.housingDocumentsDescription,
          icon: Icons.upload_file_rounded,
          onTap: isLoading
              ? () {
                  debugPrint('Housing attachment picker ignored while loading');
                }
              : _pickAttachments,
        ),

        if (_attachments.isNotEmpty) ...[
          const SizedBox(height: 12),

          if (widget.isEditMode) _buildSectionLabel(l10n.newFiles),

          ..._attachments.asMap().entries.map((
            MapEntry<int, PlatformFile> entry,
          ) {
            final PlatformFile file = entry.value;

            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: AppColors.brandGray.withOpacity(0.16)),
              ),
              child: ListTile(
                dense: true,
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getFileIcon(file.extension),
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  file.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: AppTextStyles.fontFamily,
                  ),
                ),
                subtitle: Text(
                  _getFileDescription(file),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: AppTextStyles.fontFamily,
                  ),
                ),
                trailing: IconButton(
                  tooltip: l10n.deleteAttachment,
                  icon: const Icon(Icons.close, color: AppColors.error),
                  onPressed: isLoading
                      ? null
                      : () {
                          _removeAttachment(entry.key);
                        },
                ),
              ),
            );
          }),
        ],

        const SizedBox(height: 28),

        _buildDecorativeCard(),
      ],
    );
  }

  Widget _buildDecorativeCard() {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(Icons.home_work_outlined, size: 52, color: AppColors.primary),

          SizedBox(height: 12),

          Text(
            l10n.housingQuote,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: AppTextStyles.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return BlocConsumer<HousingCubit, HousingState>(
      listener: (context, state) async {
        debugPrint(
          'HousingRequestPage listener state: '
          '${state.runtimeType}',
        );

        if (state is HousingSuccess) {
          debugPrint('Housing request succeeded');

          debugPrint('Success message: ${state.message}');

          await showRequestResultDialog(
            context: context,
            isSuccess: true,
            message: state.message,
            onSuccessConfirmed: () {
              if (!mounted) {
                return;
              }

              Navigator.of(context).popUntil((Route<dynamic> route) {
                return route.isFirst;
              });
            },
          );
        } else if (state is HousingFailure) {
          debugPrint('Housing request failed');

          debugPrint('Failure message: ${state.message}');

          await showRequestResultDialog(
            context: context,
            isSuccess: false,
            message: state.message,
            onRetry: () {
              if (mounted) {
                _submit();
              }
            },
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is HousingLoading;

        return Directionality(
          textDirection: Directionality.of(context),
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background.withValues(alpha: 0.8),
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_forward, color: AppColors.primary),
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.pop(context);
                      },
              ),
              title: Text(
                widget.isEditMode
                    ? l10n.editHousingRequestDetails
                    : l10n.housingRequestDetails,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppTextStyles.fontFamily,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomStepIndicator(currentStep: 2, totalSteps: 2),

                    const SizedBox(height: 24),

                    if (widget.isEditMode) ...[
                      _buildEditInfoCard(),
                      const SizedBox(height: 20),
                    ],

                    _buildSectionLabel(l10n.housingAidType),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: HousingSubCategory.values.map((
                        HousingSubCategory subCategory,
                      ) {
                        return SelectionChip(
                          label: _housingSubCategoryLabel(subCategory, l10n),
                          isSelected: _selectedSubCategory == subCategory,
                          onTap: isLoading || widget.isEditMode
                              ? () {
                                  debugPrint(
                                    'Subcategory selection ignored while loading or editing',
                                  );
                                }
                              : () {
                                  _selectSubCategory(subCategory);
                                },
                        );
                      }).toList(),
                    ),

                    /*
                     * قبل اختيار النوع نظهر تنبيهًا فقط،
                     * ولا نظهر أي حقل.
                     */
                    if (_selectedSubCategory == null) ...[
                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.brandGray.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: AppColors.primary),

                            SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                l10n.chooseHousingAidTypeHint,
                                style: const TextStyle(
                                  color: AppColors.brandGray,
                                  fontSize: 14,
                                  fontFamily: AppTextStyles.fontFamily,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (_selectedSubCategory != null) ...[
                      const SizedBox(height: 24),

                      _buildSubCategoryFields(isLoading),

                      _buildCommonFields(isLoading),
                    ],
                  ],
                ),
              ),
            ),
            bottomNavigationBar: _buildBottomSubmitButton(isLoading),
          ),
        );
      },
    );
  }

  Widget _buildEditInfoCard() {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(Icons.edit_outlined, color: AppColors.primary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.housingEditInfo,
              style: const TextStyle(
                color: AppColors.brandGray,
                fontSize: 13,
                height: 1.5,
                fontFamily: AppTextStyles.fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExistingAttachmentsSection() {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(l10n.existingAttachedFiles),
        ..._existingMediaUrls.map((String path) {
          final String fileName = _getFileNameFromPath(path);

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.14),
              ),
            ),
            child: ListTile(
              dense: true,
              leading: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getFileIcon(_getExtension(fileName)),
                  color: AppColors.primary,
                ),
              ),
              title: Text(
                fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: AppTextStyles.fontFamily,
                ),
              ),
              subtitle: Text(
                l10n.existingAttachment,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.brandGray,
                  fontFamily: AppTextStyles.fontFamily,
                ),
              ),
              trailing: const Icon(
                Icons.check_circle_outline,
                color: AppColors.primary,
                size: 21,
              ),
            ),
          );
        }),
      ],
    );
  }

  String _getFileNameFromPath(String path) {
    final String normalized = path.replaceAll('\\', '/');
    final List<String> parts = normalized.split('/');

    if (parts.isEmpty || parts.last.trim().isEmpty) {
      return path;
    }

    return parts.last;
  }

  String? _getExtension(String fileName) {
    final int index = fileName.lastIndexOf('.');

    if (index == -1 || index == fileName.length - 1) {
      return null;
    }

    return fileName.substring(index + 1).toLowerCase();
  }

  String _getFileDescription(PlatformFile file) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String formattedSize = _formatFileSize(file.size);

    if (kIsWeb) {
      return '$formattedSize - ${l10n.fileReadyForUpload}';
    }

    return '$formattedSize - ${file.path ?? ''}';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      final double kilobytes = bytes / 1024;

      return '${kilobytes.toStringAsFixed(1)} KB';
    }

    final double megabytes = bytes / (1024 * 1024);

    return '${megabytes.toStringAsFixed(1)} MB';
  }

  IconData _getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_outlined;

      case 'pdf':
        return Icons.picture_as_pdf_outlined;

      default:
        return Icons.attach_file;
    }
  }

  Widget _buildBottomSubmitButton(bool isLoading) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return SafeArea(
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
          onPressed: isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.primary.withOpacity(0.55),
            disabledForegroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 58),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.isEditMode
                          ? l10n.saveChanges
                          : l10n.submitRequestForReview,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppTextStyles.fontFamily,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Icon(
                      widget.isEditMode
                          ? Icons.save_outlined
                          : Icons.send_rounded,
                      size: 19,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
