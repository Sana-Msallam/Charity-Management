import 'package:charity_management/features/Beneficiary/Help_request/applicantInfo/model/applicant_info_model.dart';
import 'package:charity_management/features/Beneficiary/Help_request/education_request/cubit/education_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/education_request/cubit/education_state.dart';
import 'package:charity_management/features/Beneficiary/Help_request/education_request/model/academic_achievement.dart';
import 'package:charity_management/features/Beneficiary/Help_request/education_request/model/education_request_model.dart';
import 'package:charity_management/features/Beneficiary/request_tracking/model/request_details_model.dart';
import 'package:charity_management/features/components/custom_attachment_uploader.dart';
import 'package:charity_management/features/components/education_components.dart';
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

class EducationRequestPage extends StatefulWidget {
  const EducationRequestPage({
    super.key,
    required this.applicantInfo,
    this.requestDetails,
  });

  final ApplicantInfoModel applicantInfo;
  final RequestDetailsModel? requestDetails;

  bool get isEditMode => requestDetails != null;

  @override
  State<EducationRequestPage> createState() {
    return _EducationRequestPageState();
  }
}

class _EducationRequestPageState extends State<EducationRequestPage> {
  final TextEditingController _institutionNameArController =
      TextEditingController();

  final TextEditingController _institutionNameEnController =
      TextEditingController();

  final TextEditingController _detailsArController =
      TextEditingController();

  final TextEditingController _detailsEnController =
      TextEditingController();

  final TextEditingController _costController =
      TextEditingController();

  AcademicAchievement? _selectedAcademicAchievement;

  String? _selectedYear;

  // =================================================
  // IMPORTANT:
  // هدول قيم ثابتة نحتفظ فيها للإرسال للباك.
  // النص الذي يراه المستخدم يأتي من l10n.
  // =================================================

  static const String _primaryStageValue =
      'المرحلة الابتدائية';

  static const String _middleStageValue =
      'المرحلة المتوسطة';

  static const String _secondaryStageValue =
      'المرحلة الثانوية';

  static const String _firstUniversityYearValue =
      'سنة أولى جامعي';

  static const String _secondUniversityYearValue =
      'سنة ثانية جامعي';

  static const String _thirdUniversityYearValue =
      'سنة ثالثة جامعي';

  static const String _fourthUniversityYearValue =
      'سنة رابعة جامعي';

  static const String _fifthUniversityYearValue =
      'سنة خامسة جامعي';

  static const String _sixthUniversityYearValue =
      'سنة سادسة جامعي';

  final List<String> _yearValues = <String>[
    _primaryStageValue,
    _middleStageValue,
    _secondaryStageValue,
    _firstUniversityYearValue,
    _secondUniversityYearValue,
    _thirdUniversityYearValue,
    _fourthUniversityYearValue,
    _fifthUniversityYearValue,
    _sixthUniversityYearValue,
  ];

  /// الملفات الجديدة فقط.
  final List<PlatformFile> _attachments =
      <PlatformFile>[];

  /// الملفات الموجودة مسبقاً عند التعديل.
  final List<String> _existingMediaUrls =
      <String>[];

  // =================================================
  // INIT
  // =================================================

  @override
  void initState() {
    super.initState();

    debugPrint(
      '======================================',
    );

    debugPrint(
      'EducationRequestPage opened',
    );

    debugPrint(
      'Edit mode: ${widget.isEditMode}',
    );

    debugPrint(
      'Request id: ${widget.requestDetails?.id}',
    );

    debugPrint(
      'Applicant data received:',
    );

    debugPrint(
      'First name: ${widget.applicantInfo.firstName}',
    );

    debugPrint(
      'Father name: ${widget.applicantInfo.fatherName}',
    );

    debugPrint(
      'Last name: ${widget.applicantInfo.lastName}',
    );

    debugPrint(
      'Age: ${widget.applicantInfo.age}',
    );

    debugPrint(
      'Gender: ${widget.applicantInfo.gender}',
    );

    debugPrint(
      'Social status: ${widget.applicantInfo.socialStatus}',
    );

    debugPrint(
      'Phone number: ${widget.applicantInfo.phoneNumber}',
    );

    debugPrint(
      'Address AR: ${widget.applicantInfo.addressAr}',
    );

    debugPrint(
      'Address EN: ${widget.applicantInfo.addressEn}',
    );

    debugPrint(
      'Is unemployed: ${widget.applicantInfo.isUnemployed}',
    );

    if (widget.isEditMode) {
      _fillExistingEducationData();
    }

    debugPrint(
      '======================================',
    );
  }

  // =================================================
  // FILL EXISTING DATA
  // =================================================

  void _fillExistingEducationData() {
    final RequestDetailsModel? request =
        widget.requestDetails;

    if (request == null) {
      return;
    }

    debugPrint(
      '======================================',
    );

    debugPrint(
      'FILL EXISTING EDUCATION DATA',
    );

    debugPrint(
      'Request id: ${request.id}',
    );

    // -----------------------------------------------
    // Academic achievement
    // -----------------------------------------------

    final String? academicAchievementApiValue =
        request.getAidDetailStringAr(
      'academicAchievement',
    );

    if (academicAchievementApiValue != null) {
      for (final AcademicAchievement achievement
          in AcademicAchievement.values) {
        if (achievement.apiValue ==
            academicAchievementApiValue) {
          _selectedAcademicAchievement =
              achievement;

          break;
        }
      }
    }

    // -----------------------------------------------
    // Institution
    // -----------------------------------------------

    _institutionNameArController.text =
        request.getAidDetailStringAr(
              'institutionName',
            ) ??
            '';

    _institutionNameEnController.text =
        request.getAidDetailStringEn(
              'institutionName',
            ) ??
            '';

    // -----------------------------------------------
    // Details
    // -----------------------------------------------

    _detailsArController.text =
        request.detailsAr ?? '';

    _detailsEnController.text =
        request.detailsEn ?? '';

    // -----------------------------------------------
    // Cost
    // -----------------------------------------------

    _costController.text = _formatCost(
      request.cost,
    );

    // -----------------------------------------------
    // Year
    // -----------------------------------------------

    final String? existingYear =
        request.getAidDetailStringAr(
      'year',
    );

    if (existingYear != null &&
        existingYear.trim().isNotEmpty) {
      if (!_yearValues.contains(
        existingYear,
      )) {
        _yearValues.insert(
          0,
          existingYear,
        );
      }

      _selectedYear =
          existingYear;
    }

    // -----------------------------------------------
    // Existing media
    // -----------------------------------------------

    _existingMediaUrls
      ..clear()
      ..addAll(
        request.getAidDetailStringList(
          'mediaUrls',
        ),
      );

    debugPrint(
      'Academic achievement: '
      '${_selectedAcademicAchievement?.apiValue}',
    );

    debugPrint(
      'Institution AR: '
      '${_institutionNameArController.text}',
    );

    debugPrint(
      'Institution EN: '
      '${_institutionNameEnController.text}',
    );

    debugPrint(
      'Year: $_selectedYear',
    );

    debugPrint(
      'Details AR: '
      '${_detailsArController.text}',
    );

    debugPrint(
      'Details EN: '
      '${_detailsEnController.text}',
    );

    debugPrint(
      'Cost: ${_costController.text}',
    );

    debugPrint(
      'Existing media count: '
      '${_existingMediaUrls.length}',
    );

    debugPrint(
      'Existing media: $_existingMediaUrls',
    );

    debugPrint(
      '======================================',
    );
  }

  String _formatCost(
    double value,
  ) {
    if (value ==
        value.truncateToDouble()) {
      return value
          .toInt()
          .toString();
    }

    return value.toString();
  }

  // =================================================
  // DISPOSE
  // =================================================

  @override
  void dispose() {
    _institutionNameArController.dispose();
    _institutionNameEnController.dispose();
    _detailsArController.dispose();
    _detailsEnController.dispose();
    _costController.dispose();

    debugPrint(
      'EducationRequestPage disposed',
    );

    super.dispose();
  }

  // =================================================
  // ACADEMIC ACHIEVEMENT LABEL
  // =================================================

  String _academicAchievementLabel(
    AcademicAchievement achievement,
    AppLocalizations l10n,
  ) {
    switch (achievement) {
      case AcademicAchievement.highSchool:
        return l10n.highSchool;

      case AcademicAchievement.diploma:
        return l10n.diploma;

      case AcademicAchievement.bachelor:
        return l10n.bachelor;

      case AcademicAchievement.master:
        return l10n.master;
    }
  }

  // =================================================
  // YEAR LABEL
  // =================================================

  String _yearLabel(
    String value,
    AppLocalizations l10n,
  ) {
    switch (value) {
      case _primaryStageValue:
        return l10n.primaryStage;

      case _middleStageValue:
        return l10n.middleStage;

      case _secondaryStageValue:
        return l10n.secondaryStage;

      case _firstUniversityYearValue:
        return l10n.firstUniversityYear;

      case _secondUniversityYearValue:
        return l10n.secondUniversityYear;

      case _thirdUniversityYearValue:
        return l10n.thirdUniversityYear;

      case _fourthUniversityYearValue:
        return l10n.fourthUniversityYear;

      case _fifthUniversityYearValue:
        return l10n.fifthUniversityYear;

      case _sixthUniversityYearValue:
        return l10n.sixthUniversityYear;

      default:
        // مثل 2026 إذا رجعت من الباك.
        return value;
    }
  }

  // =================================================
  // PICK FILES
  // =================================================

  Future<void> _pickAttachments() async {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    debugPrint(
      '======================================',
    );

    debugPrint(
      'Education attachment picker opened',
    );

    try {
      final FilePickerResult? result =
          await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: const <String>[
          'jpg',
          'jpeg',
          'png',
          'pdf',
        ],
        withData: kIsWeb,
      );

      if (result == null) {
        debugPrint(
          'Attachment selection cancelled',
        );

        debugPrint(
          '======================================',
        );

        return;
      }

      if (!mounted) {
        debugPrint(
          'Widget is not mounted after file selection',
        );

        return;
      }

      final List<PlatformFile> selectedFiles =
          result.files.where(
        (
          PlatformFile newFile,
        ) {
          final bool alreadyExists =
              _attachments.any(
            (
              PlatformFile oldFile,
            ) {
              return oldFile.name ==
                      newFile.name &&
                  oldFile.size ==
                      newFile.size;
            },
          );

          return !alreadyExists;
        },
      ).toList();

      if (selectedFiles.isEmpty) {
        _showValidationMessage(
          l10n.duplicateFiles,
        );

        return;
      }

      final List<PlatformFile> validFiles =
          <PlatformFile>[];

      for (final PlatformFile file
          in selectedFiles) {
        debugPrint(
          'Selected file: ${file.name}',
        );

        debugPrint(
          'Path: ${file.path}',
        );

        debugPrint(
          'Size: ${file.size}',
        );

        debugPrint(
          'Extension: ${file.extension}',
        );

        debugPrint(
          'Bytes available: ${file.bytes != null}',
        );

        if (kIsWeb) {
          if (file.bytes == null ||
              file.bytes!.isEmpty) {
            debugPrint(
              'Web file bytes missing: '
              '${file.name}',
            );

            continue;
          }
        } else {
          if (file.path == null ||
              file.path!
                  .trim()
                  .isEmpty) {
            debugPrint(
              'Mobile file path missing: '
              '${file.name}',
            );

            continue;
          }
        }

        validFiles.add(
          file,
        );
      }

      if (validFiles.isEmpty) {
        _showValidationMessage(
          l10n.filesAccessFailed,
        );

        return;
      }

      setState(() {
        _attachments.addAll(
          validFiles,
        );
      });

      debugPrint(
        'Files added: ${validFiles.length}',
      );

      debugPrint(
        'Total new attachments: '
        '${_attachments.length}',
      );

      debugPrint(
        '======================================',
      );
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'Education attachment picker error',
      );

      debugPrint(
        'Error: $error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      debugPrint(
        '======================================',
      );

      if (mounted) {
        _showValidationMessage(
          l10n.fileSelectionFailed,
        );
      }
    }
  }

  // =================================================
  // REMOVE NEW ATTACHMENT
  // =================================================

  void _removeAttachment(
    int index,
  ) {
    if (index < 0 ||
        index >= _attachments.length) {
      debugPrint(
        'Invalid attachment index: $index',
      );

      return;
    }

    final PlatformFile removedFile =
        _attachments[index];

    setState(() {
      _attachments.removeAt(
        index,
      );
    });

    debugPrint(
      'New attachment removed: '
      '${removedFile.name}',
    );

    debugPrint(
      'Remaining new attachments: '
      '${_attachments.length}',
    );
  }

  // =================================================
  // SUBMIT / UPDATE
  // =================================================

  void _submit() {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    debugPrint(
      '======================================',
    );

    debugPrint(
      'EducationRequestPage: '
      '${widget.isEditMode ? 'Update' : 'Submit'} '
      'clicked',
    );

    FocusScope.of(context).unfocus();

    final String institutionNameAr =
        _institutionNameArController.text
            .trim();

    final String institutionNameEn =
        _institutionNameEnController.text
            .trim();

    final String detailsAr =
        _detailsArController.text
            .trim();

    final String detailsEn =
        _detailsEnController.text
            .trim();

    final String costText =
        _costController.text.trim();

    final double? cost =
        double.tryParse(
      costText.replaceAll(
        ',',
        '.',
      ),
    );

    debugPrint(
      'Edit mode: ${widget.isEditMode}',
    );

    debugPrint(
      'Request id: '
      '${widget.requestDetails?.id}',
    );

    debugPrint(
      'Academic achievement: '
      '${_selectedAcademicAchievement?.apiValue}',
    );

    debugPrint(
      'Institution name AR: $institutionNameAr',
    );

    debugPrint(
      'Institution name EN: $institutionNameEn',
    );

    debugPrint(
      'Selected year: $_selectedYear',
    );

    debugPrint(
      'Details AR: $detailsAr',
    );

    debugPrint(
      'Details EN: $detailsEn',
    );

    debugPrint(
      'Cost: $cost',
    );

    debugPrint(
      'Existing attachments count: '
      '${_existingMediaUrls.length}',
    );

    debugPrint(
      'New attachments count: '
      '${_attachments.length}',
    );

    // =================================================
    // VALIDATION
    // =================================================

    if (_selectedAcademicAchievement ==
        null) {
      _showValidationMessage(
        l10n.selectAcademicAchievement,
      );

      return;
    }

    final String? institutionArError =
        _validateArabicField(
      institutionNameAr,
      l10n.schoolOrUniversityName,
    );

    if (institutionArError != null) {
      _showValidationMessage(
        institutionArError,
      );

      return;
    }

    final String? institutionEnError =
        _validateEnglishField(
      institutionNameEn,
      l10n.schoolOrUniversityName,
    );

    if (institutionEnError != null) {
      _showValidationMessage(
        institutionEnError,
      );

      return;
    }

    if (_selectedYear == null ||
        _selectedYear!
            .trim()
            .isEmpty) {
      _showValidationMessage(
        l10n.selectGradeOrYear,
      );

      return;
    }

    final String? detailsArError =
        _validateArabicField(
      detailsAr,
      l10n.educationCaseDetails,
      minimumLength: 5,
    );

    if (detailsArError != null) {
      _showValidationMessage(
        detailsArError,
      );

      return;
    }

    final String? detailsEnError =
        _validateEnglishField(
      detailsEn,
      l10n.educationCaseDetails,
      minimumLength: 5,
    );

    if (detailsEnError != null) {
      _showValidationMessage(
        detailsEnError,
      );

      return;
    }

    if (cost == null ||
        cost <= 0) {
      _showValidationMessage(
        l10n.validCostRequired,
      );

      return;
    }

    final bool hasExistingMedia =
        _existingMediaUrls.isNotEmpty;

    final bool hasNewMedia =
        _attachments.isNotEmpty;

    if (!hasExistingMedia &&
        !hasNewMedia) {
      _showValidationMessage(
        l10n.educationDocumentRequired,
      );

      return;
    }

    // =================================================
    // MODEL
    // =================================================

    final EducationRequestModel request =
        EducationRequestModel(
      applicantInfo:
          widget.applicantInfo,

      academicAchievement:
          _selectedAcademicAchievement!,

      institutionNameAr:
          institutionNameAr,

      institutionNameEn:
          institutionNameEn,

      // نحافظ على القيمة القديمة التي يتوقعها الباك.
      year:
          _selectedYear!,

      detailsAr:
          detailsAr,

      detailsEn:
          detailsEn,

      cost:
          cost,

      media:
          List<PlatformFile>.unmodifiable(
        _attachments,
      ),
    );

    debugPrint(
      'EducationRequestModel created',
    );

    debugPrint(
      'Request firstName: '
      '${request.applicantInfo.firstName}',
    );

    debugPrint(
      'Request academicAchievement: '
      '${request.academicAchievement.apiValue}',
    );

    debugPrint(
      'Request institutionNameAr: '
      '${request.institutionNameAr}',
    );

    debugPrint(
      'Request institutionNameEn: '
      '${request.institutionNameEn}',
    );

    debugPrint(
      'Request year: ${request.year}',
    );

    debugPrint(
      'Request detailsAr: ${request.detailsAr}',
    );

    debugPrint(
      'Request detailsEn: ${request.detailsEn}',
    );

    debugPrint(
      'Request cost: ${request.cost}',
    );

    debugPrint(
      'New attachments: '
      '${request.media.length}',
    );

    // =================================================
    // CREATE OR UPDATE
    // =================================================

    if (widget.isEditMode) {
      final int? requestId =
          widget.requestDetails?.id;

      if (requestId == null) {
        _showValidationMessage(
          l10n.requestIdUnavailable,
        );

        return;
      }

      debugPrint(
        'Calling '
        'EducationCubit.updateEducationRequest',
      );

      debugPrint(
        'Request id: $requestId',
      );

      debugPrint(
        '======================================',
      );

      context
          .read<EducationCubit>()
          .updateEducationRequest(
            requestId:
                requestId,
            request:
                request,
          );

      return;
    }

    debugPrint(
      'Calling '
      'EducationCubit.submitEducationRequest',
    );

    debugPrint(
      '======================================',
    );

    context
        .read<EducationCubit>()
        .submitEducationRequest(
          request,
        );
  }

  // =================================================
  // ARABIC VALIDATION
  // =================================================

  String? _validateArabicField(
    String value,
    String fieldName, {
    int minimumLength = 2,
  }) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String text =
        value.trim();

    if (text.isEmpty) {
      return l10n.enterFieldInArabic(
        fieldName,
      );
    }

    if (text.length <
        minimumLength) {
      return l10n.fieldTooShort(
        fieldName,
      );
    }

    final bool hasArabic =
        RegExp(
      r'[\u0600-\u06FF]',
    ).hasMatch(
      text,
    );

    final bool hasEnglish =
        RegExp(
      r'[A-Za-z]',
    ).hasMatch(
      text,
    );

    if (!hasArabic ||
        hasEnglish) {
      return l10n.fieldArabicOnly(
        fieldName,
      );
    }

    return null;
  }

  // =================================================
  // ENGLISH VALIDATION
  // =================================================

  String? _validateEnglishField(
    String value,
    String fieldName, {
    int minimumLength = 2,
  }) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String text =
        value.trim();

    if (text.isEmpty) {
      return l10n.enterFieldInEnglish(
        fieldName,
      );
    }

    if (text.length <
        minimumLength) {
      return l10n.fieldTooShort(
        fieldName,
      );
    }

    final bool hasEnglish =
        RegExp(
      r'[A-Za-z]',
    ).hasMatch(
      text,
    );

    final bool hasArabic =
        RegExp(
      r'[\u0600-\u06FF]',
    ).hasMatch(
      text,
    );

    if (!hasEnglish ||
        hasArabic) {
      return l10n.fieldEnglishOnly(
        fieldName,
      );
    }

    return null;
  }

  // =================================================
  // MESSAGE
  // =================================================

  void _showValidationMessage(
    String message,
  ) {
    if (!mounted) {
      debugPrint(
        'Cannot show message: '
        'widget is not mounted',
      );

      return;
    }

    debugPrint(
      'Showing validation SnackBar: $message',
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior:
              SnackBarBehavior.floating,
          margin:
              const EdgeInsets.all(
            16,
          ),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
          content: Text(
            message,
            style:
                const TextStyle(
              fontFamily:
                  AppTextStyles.fontFamily,
            ),
          ),
        ),
      );
  }

  // =================================================
  // SECTION LABEL
  // =================================================

  Widget _buildSectionLabel(
    String text,
  ) {
    return Padding(
      padding:
          const EdgeInsetsDirectional.only(
        start: 4,
        bottom: 8,
      ),
      child: Text(
        text,
        style:
            const TextStyle(
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
  // BUILD
  // =================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return BlocConsumer<
        EducationCubit,
        EducationState>(
      listener: (
        context,
        state,
      ) async {
        debugPrint(
          'EducationRequestPage state: '
          '${state.runtimeType}',
        );

        if (state
            is EducationSuccess) {
          debugPrint(
            'Education request success: '
            '${state.message}',
          );

          await showRequestResultDialog(
            context: context,
            isSuccess: true,
            message: state.message,
            onSuccessConfirmed: () {
              if (!mounted) {
                return;
              }

              Navigator.of(
                context,
              ).popUntil(
                (
                  Route<dynamic> route,
                ) {
                  return route.isFirst;
                },
              );
            },
          );
        } else if (state
            is EducationFailure) {
          debugPrint(
            'Education request failure: '
            '${state.message}',
          );

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
      builder: (
        context,
        state,
      ) {
        final bool isLoading =
            state is EducationLoading;

        return Scaffold(
          backgroundColor:
              AppColors.background,

          appBar: AppBar(
            backgroundColor:
                AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,

            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_rounded,
                color:
                    AppColors.primary,
              ),
              onPressed: isLoading
                  ? null
                  : () {
                      Navigator.pop(
                        context,
                      );
                    },
            ),

            title: Text(
              widget.isEditMode
                  ? l10n
                      .editEducationRequestDetails
                  : l10n
                      .educationRequestDetails,
              style:
                  const TextStyle(
                color:
                    AppColors.primary,
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
                fontFamily:
                    AppTextStyles.fontFamily,
              ),
            ),

            centerTitle: true,
          ),

          body: SafeArea(
            child:
                SingleChildScrollView(
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior
                      .onDrag,

              padding:
                  const EdgeInsets
                      .fromLTRB(
                20,
                24,
                20,
                110,
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  if (widget
                      .isEditMode) ...[
                    _buildEditInfoCard(),

                    const SizedBox(
                      height: 20,
                    ),
                  ],

                  // ===============================
                  // ACADEMIC ACHIEVEMENT
                  // ===============================

                  _buildSectionLabel(
                    l10n.academicAchievement,
                  ),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        AcademicAchievement
                            .values
                            .map(
                      (
                        AcademicAchievement
                            achievement,
                      ) {
                        return SelectionChip(
                          label:
                              _academicAchievementLabel(
                            achievement,
                            l10n,
                          ),

                          isSelected:
                              _selectedAcademicAchievement ==
                                  achievement,

                          onTap: isLoading
                              ? () {}
                              : () {
                                  setState(
                                    () {
                                      _selectedAcademicAchievement =
                                          achievement;
                                    },
                                  );

                                  debugPrint(
                                    'Academic achievement selected: '
                                    '${achievement.apiValue}',
                                  );
                                },
                        );
                      },
                    ).toList(),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ===============================
                  // INSTITUTION AR
                  // ===============================

                  CustomTextField(
                    label:
                        l10n.institutionNameArabic,

                    hint:
                        l10n.institutionNameArabicHint,

                    controller:
                        _institutionNameArController,

                    suffixIcon:
                        Icons.school_outlined,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ===============================
                  // INSTITUTION EN
                  // ===============================

                  CustomTextField(
                    label:
                        l10n.institutionNameEnglish,

                    hint:
                        l10n.institutionNameEnglishHint,

                    controller:
                        _institutionNameEnController,

                    suffixIcon:
                        Icons.school_outlined,

                    isLtr: true,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ===============================
                  // YEAR
                  // ===============================

                  _buildSectionLabel(
                    l10n.gradeOrYear,
                  ),

                  _buildDropdownField(
                    isLoading,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ===============================
                  // DETAILS AR
                  // ===============================

                  CustomTextField(
                    label:
                        l10n.educationDetailsArabic,

                    hint:
                        l10n.educationDetailsArabicHint,

                    controller:
                        _detailsArController,

                    maxLines: 4,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ===============================
                  // DETAILS EN
                  // ===============================

                  CustomTextField(
                    label:
                        l10n.educationDetailsEnglish,

                    hint:
                        l10n.educationDetailsEnglishHint,

                    controller:
                        _detailsEnController,

                    maxLines: 4,

                    isLtr: true,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ===============================
                  // COST
                  // ===============================

                  CustomTextField(
                    label:
                        l10n.expectedTotalCost,

                    hint:
                        '0.00',

                    controller:
                        _costController,

                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),

                    isCurrency: true,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ===============================
                  // DOCUMENTS
                  // ===============================

                  _buildSectionLabel(
                    l10n.educationDocuments,
                  ),

                  if (_existingMediaUrls
                      .isNotEmpty) ...[
                    _buildExistingAttachmentsSection(),

                    const SizedBox(
                      height: 16,
                    ),
                  ],

                  CustomAttachmentUploader(
                    title: widget.isEditMode
                        ? l10n.addNewFiles
                        : l10n.uploadFilesOrCapture,

                    description:
                        widget.isEditMode
                            ? l10n
                                .addNewFilesDescription
                            : l10n
                                .educationDocumentsDescription,

                    icon:
                        Icons.upload_file_rounded,

                    onTap: isLoading
                        ? () {}
                        : _pickAttachments,
                  ),

                  if (_attachments
                      .isNotEmpty) ...[
                    const SizedBox(
                      height: 12,
                    ),

                    _buildSectionLabel(
                      widget.isEditMode
                          ? l10n.newFiles
                          : l10n.attachedFiles,
                    ),

                    ..._attachments
                        .asMap()
                        .entries
                        .map(
                      (
                        MapEntry<
                                int,
                                PlatformFile>
                            entry,
                      ) {
                        final PlatformFile file =
                            entry.value;

                        return Card(
                          margin:
                              const EdgeInsets
                                  .only(
                            bottom: 10,
                          ),
                          elevation: 0,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              14,
                            ),
                            side:
                                BorderSide(
                              color: AppColors
                                  .brandGray
                                  .withOpacity(
                                0.16,
                              ),
                            ),
                          ),
                          child: ListTile(
                            dense: true,

                            leading:
                                Container(
                              width: 42,
                              height: 42,
                              decoration:
                                  BoxDecoration(
                                color: AppColors
                                    .primaryContainer
                                    .withOpacity(
                                  0.4,
                                ),
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  12,
                                ),
                              ),
                              child: Icon(
                                _getFileIcon(
                                  file.extension,
                                ),
                                color:
                                    AppColors.primary,
                              ),
                            ),

                            title: Text(
                              file.name,
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                                fontFamily:
                                    AppTextStyles
                                        .fontFamily,
                              ),
                            ),

                            subtitle: Text(
                              _getFileDescription(
                                file,
                              ),
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                              style:
                                  const TextStyle(
                                fontSize: 12,
                                fontFamily:
                                    AppTextStyles
                                        .fontFamily,
                              ),
                            ),

                            trailing:
                                IconButton(
                              tooltip:
                                  l10n.deleteAttachment,
                              icon:
                                  const Icon(
                                Icons.close,
                                color:
                                    AppColors.error,
                              ),
                              onPressed:
                                  isLoading
                                      ? null
                                      : () {
                                          _removeAttachment(
                                            entry.key,
                                          );
                                        },
                            ),
                          ),
                        );
                      },
                    ),
                  ],

                  const SizedBox(
                    height: 32,
                  ),

                  const EducationalDecorativeCard(),
                ],
              ),
            ),
          ),

          bottomNavigationBar:
              _buildBottomSubmitButton(
            isLoading,
          ),
        );
      },
    );
  }

  // =================================================
  // EDIT INFO
  // =================================================

  Widget _buildEditInfoCard() {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(
        14,
      ),
      decoration:
          BoxDecoration(
        color: AppColors
            .primaryContainer
            .withOpacity(
          0.45,
        ),
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color: AppColors.primary
              .withOpacity(
            0.15,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.edit_outlined,
            color:
                AppColors.primary,
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Text(
              l10n.educationEditInfo,
              style:
                  const TextStyle(
                color:
                    AppColors.brandGray,
                fontSize: 13,
                height: 1.5,
                fontFamily:
                    AppTextStyles
                        .fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =================================================
  // EXISTING MEDIA
  // =================================================

  Widget _buildExistingAttachmentsSection() {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(
          l10n.existingAttachedFiles,
        ),

        ..._existingMediaUrls
            .asMap()
            .entries
            .map(
          (
            MapEntry<int, String> entry,
          ) {
            final String path =
                entry.value;

            final String fileName =
                _getFileNameFromPath(
              path,
            );

            return Card(
              margin:
                  const EdgeInsets.only(
                bottom: 10,
              ),
              elevation: 0,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
                side: BorderSide(
                  color:
                      AppColors.primary
                          .withOpacity(
                    0.14,
                  ),
                ),
              ),
              child: ListTile(
                dense: true,

                leading: Container(
                  width: 42,
                  height: 42,
                  decoration:
                      BoxDecoration(
                    color: AppColors
                        .primaryContainer
                        .withOpacity(
                      0.4,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                  child: Icon(
                    _getFileIcon(
                      _getExtension(
                        fileName,
                      ),
                    ),
                    color:
                        AppColors.primary,
                  ),
                ),

                title: Text(
                  fileName,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.w600,
                    fontFamily:
                        AppTextStyles
                            .fontFamily,
                  ),
                ),

                subtitle: Text(
                  l10n.existingAttachment,
                  style:
                      const TextStyle(
                    fontSize: 12,
                    color:
                        AppColors.brandGray,
                    fontFamily:
                        AppTextStyles
                            .fontFamily,
                  ),
                ),

                trailing:
                    const Icon(
                  Icons
                      .check_circle_outline,
                  color:
                      AppColors.primary,
                  size: 21,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  String _getFileNameFromPath(
    String path,
  ) {
    final String normalized =
        path.replaceAll(
      '\\',
      '/',
    );

    final List<String> parts =
        normalized.split(
      '/',
    );

    if (parts.isEmpty) {
      return path;
    }

    return parts.last;
  }

  String? _getExtension(
    String fileName,
  ) {
    final int index =
        fileName.lastIndexOf(
      '.',
    );

    if (index == -1 ||
        index ==
            fileName.length - 1) {
      return null;
    }

    return fileName
        .substring(
          index + 1,
        )
        .toLowerCase();
  }

  // =================================================
  // DROPDOWN
  // =================================================

  Widget _buildDropdownField(
    bool isLoading,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          14,
        ),
        border: Border.all(
          color:
              AppColors.brandGray
                  .withOpacity(
            0.3,
          ),
          width: 1.2,
        ),
      ),
      child:
          DropdownButtonHideUnderline(
        child:
            DropdownButton<String>(
          value:
              _selectedYear,

          hint: Text(
            l10n.selectGradeHint,
            style: TextStyle(
              color:
                  AppColors.brandGray
                      .withOpacity(
                0.55,
              ),
              fontSize: 14,
              fontFamily:
                  AppTextStyles
                      .fontFamily,
            ),
          ),

          isExpanded: true,

          icon:
              const Icon(
            Icons
                .keyboard_arrow_down,
            color:
                AppColors.brandGray,
          ),

          items:
              _yearValues.map(
            (
              String value,
            ) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  _yearLabel(
                    value,
                    l10n,
                  ),
                  style:
                      const TextStyle(
                    color:
                        AppColors.onSurface,
                    fontSize: 14,
                    fontFamily:
                        AppTextStyles
                            .fontFamily,
                  ),
                ),
              );
            },
          ).toList(),

          onChanged: isLoading
              ? null
              : (
                  String? newValue,
                ) {
                  setState(
                    () {
                      _selectedYear =
                          newValue;
                    },
                  );
                },
        ),
      ),
    );
  }

  // =================================================
  // FILE DESCRIPTION
  // =================================================

  String _getFileDescription(
    PlatformFile file,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String size =
        _formatFileSize(
      file.size,
    );

    if (kIsWeb) {
      return '$size - ${l10n.fileReadyForUpload}';
    }

    return '$size - ${file.path ?? ''}';
  }

  String _formatFileSize(
    int bytes,
  ) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes <
        1024 * 1024) {
      final double kiloBytes =
          bytes / 1024;

      return '${kiloBytes.toStringAsFixed(1)} KB';
    }

    final double megaBytes =
        bytes /
            (1024 * 1024);

    return '${megaBytes.toStringAsFixed(1)} MB';
  }

  IconData _getFileIcon(
    String? extension,
  ) {
    switch (
        extension?.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons
            .image_outlined;

      case 'pdf':
        return Icons
            .picture_as_pdf_outlined;

      default:
        return Icons.attach_file;
    }
  }

  // =================================================
  // BOTTOM BUTTON
  // =================================================

  Widget _buildBottomSubmitButton(
    bool isLoading,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return SafeArea(
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
              color:
                  AppColors.brandGray
                      .withOpacity(
                0.12,
              ),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black
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
        child:
            ElevatedButton(
          onPressed:
              isLoading
                  ? null
                  : _submit,

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

          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                    color:
                        Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.isEditMode
                          ? l10n.saveChanges
                          : l10n
                              .submitRequestForReview,
                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                        fontFamily:
                            AppTextStyles
                                .fontFamily,
                      ),
                    ),

                    const SizedBox(
                      width: 10,
                    ),

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