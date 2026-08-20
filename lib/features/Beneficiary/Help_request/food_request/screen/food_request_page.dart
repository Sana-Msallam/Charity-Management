import 'package:charity_management/features/Beneficiary/Help_request/applicantInfo/model/applicant_info_model.dart';
import 'package:charity_management/features/Beneficiary/Help_request/food_request/cubit/food_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/food_request/cubit/food_state.dart';
import 'package:charity_management/features/Beneficiary/Help_request/food_request/model/food_aid_type.dart';
import 'package:charity_management/features/Beneficiary/Help_request/food_request/model/food_request_model.dart';
import 'package:charity_management/features/Beneficiary/request_tracking/model/request_details_model.dart';
import 'package:charity_management/features/components/custom_attachment_uploader.dart';
import 'package:charity_management/features/components/custom_step_Indicator.dart';
import 'package:charity_management/features/components/request_result_dialog.dart';
import 'package:charity_management/features/components/selection_chip.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/widgets/beneficiaries_counter.dart';
import 'package:charity_management/widgets/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodRequestPage extends StatefulWidget {
  const FoodRequestPage({
    super.key,
    required this.applicantInfo,
    this.requestDetails,
  });

  final ApplicantInfoModel applicantInfo;
  final RequestDetailsModel? requestDetails;

  bool get isEditMode => requestDetails != null;

  @override
  State<FoodRequestPage> createState() {
    return _FoodRequestPageState();
  }
}

class _FoodRequestPageState extends State<FoodRequestPage> {
  final TextEditingController _detailsArController =
      TextEditingController();

  final TextEditingController _detailsEnController =
      TextEditingController();

  final TextEditingController _costController =
      TextEditingController();

  FoodAidType? _selectedFoodAidType;

  int _numberIndividuals = 1;

  final List<PlatformFile> _attachments =
      <PlatformFile>[];

  final List<String> _existingMediaUrls =
      <String>[];

  // =================================================
  // INIT
  // =================================================

  @override
  void initState() {
    super.initState();

    debugPrint('======================================');
    debugPrint('FoodRequestPage opened');
    debugPrint('Applicant data received:');
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
      _fillExistingFoodData();
    }

    debugPrint('======================================');
  }

  // =================================================
  // FILL EXISTING DATA
  // =================================================

  void _fillExistingFoodData() {
    final RequestDetailsModel? request =
        widget.requestDetails;

    if (request == null) {
      return;
    }

    debugPrint('======================================');
    debugPrint('FILL EXISTING FOOD DATA');
    debugPrint('Request id: ${request.id}');
    debugPrint('Category id: ${request.categoryId}');

    if (request.categoryId != 2) {
      debugPrint(
        'Unexpected category id for food edit: '
        '${request.categoryId}',
      );
    }

    final String? typeAidApiValue =
        request.getAidDetailStringAr(
      'typeAid',
    );

    if (typeAidApiValue != null) {
      final String normalizedValue =
          typeAidApiValue
              .trim()
              .toUpperCase();

      for (final FoodAidType type
          in FoodAidType.values) {
        if (type.apiValue ==
            normalizedValue) {
          _selectedFoodAidType =
              type;
          break;
        }
      }
    }

    final int? existingNumberIndividuals =
        request.getAidDetailInt(
      'numberIndividuals',
    );

    if (existingNumberIndividuals != null) {
      _numberIndividuals =
          existingNumberIndividuals;
    }

    _detailsArController.text =
        request.detailsAr ?? '';

    _detailsEnController.text =
        request.detailsEn ?? '';

    _costController.text =
        _formatCost(
      request.cost,
    );

    _existingMediaUrls
      ..clear()
      ..addAll(
        request.getAidDetailStringList(
          'mediaUrls',
        ),
      );

    debugPrint(
      'Food aid type: '
      '${_selectedFoodAidType?.apiValue}',
    );

    debugPrint(
      'Number individuals: '
      '$_numberIndividuals',
    );

    debugPrint(
      'Existing media: '
      '$_existingMediaUrls',
    );

    debugPrint('======================================');
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
    _detailsArController.dispose();
    _detailsEnController.dispose();
    _costController.dispose();

    debugPrint(
      'FoodRequestPage disposed',
    );

    super.dispose();
  }

  // =================================================
  // FOOD AID TYPE LABEL
  // =================================================

  String _foodAidTypeLabel(
    FoodAidType type,
    AppLocalizations l10n,
  ) {
    switch (type) {
      case FoodAidType.foodBasket:
        return l10n.foodBasket;

      case FoodAidType.babyMilk:
        return l10n.babyMilk;
    }
  }

  // =================================================
  // PICK FILES
  // =================================================

  Future<void> _pickAttachments() async {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    debugPrint('======================================');
    debugPrint(
      'Food attachment picker opened',
    );

    try {
      final FilePickerResult? result =
          await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions:
            const <String>[
          'jpg',
          'jpeg',
          'png',
          'pdf',
        ],
        withData: kIsWeb,
      );

      if (result == null) {
        debugPrint(
          'Food attachment selection cancelled',
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

      debugPrint(
        'Selected files count: '
        '${result.files.length}',
      );

      for (final PlatformFile file
          in result.files) {
        debugPrint(
          'Selected food attachment:',
        );
        debugPrint(
          'Name: ${file.name}',
        );
        debugPrint(
          'Path: ${file.path}',
        );
        debugPrint(
          'Size: ${file.size} bytes',
        );
        debugPrint(
          'Extension: ${file.extension}',
        );
        debugPrint(
          'Bytes available: '
          '${file.bytes != null}',
        );
      }

      final List<PlatformFile> selectedFiles =
          result.files.where(
        (
          PlatformFile newFile,
        ) {
          final bool alreadyExists =
              _attachments.any(
            (
              PlatformFile existingFile,
            ) {
              return existingFile.name ==
                      newFile.name &&
                  existingFile.size ==
                      newFile.size;
            },
          );

          return !alreadyExists;
        },
      ).toList();

      if (selectedFiles.isEmpty) {
        debugPrint(
          'All selected food files already exist',
        );

        _showValidationMessage(
          l10n.duplicateFiles,
        );

        return;
      }

      final List<PlatformFile> validFiles =
          <PlatformFile>[];

      for (final PlatformFile file
          in selectedFiles) {
        if (kIsWeb) {
          if (file.bytes == null ||
              file.bytes!.isEmpty) {
            debugPrint(
              'Web food file bytes are missing: '
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
              'Mobile food file path is missing: '
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
        debugPrint(
          'No valid food files were found',
        );

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
        'Food files added successfully: '
        '${validFiles.length}',
      );

      debugPrint(
        'Total food attachments: '
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
        'Food attachment picker error',
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
  // REMOVE ATTACHMENT
  // =================================================

  void _removeAttachment(
    int index,
  ) {
    if (index < 0 ||
        index >= _attachments.length) {
      debugPrint(
        'Invalid food attachment index: '
        '$index',
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
      'Food attachment removed: '
      '${removedFile.name}',
    );

    debugPrint(
      'Remaining food attachments: '
      '${_attachments.length}',
    );
  }

  // =================================================
  // INDIVIDUALS
  // =================================================

  void _incrementIndividuals() {
    setState(() {
      _numberIndividuals++;
    });

    debugPrint(
      'Number individuals increased: '
      '$_numberIndividuals',
    );
  }

  void _decrementIndividuals() {
    if (_numberIndividuals <= 1) {
      debugPrint(
        'Number individuals cannot be less than 1',
      );
      return;
    }

    setState(() {
      _numberIndividuals--;
    });

    debugPrint(
      'Number individuals decreased: '
      '$_numberIndividuals',
    );
  }

  // =================================================
  // SUBMIT
  // =================================================

  void _submit() {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    debugPrint('======================================');
    debugPrint(
      'FoodRequestPage: Submit clicked',
    );

    FocusScope.of(context).unfocus();

    final String detailsAr =
        _detailsArController.text.trim();

    final String detailsEn =
        _detailsEnController.text.trim();

    final String costText =
        _costController.text.trim();

    final String normalizedCostText =
        costText.replaceAll(
      ',',
      '.',
    );

    final double? cost =
        double.tryParse(
      normalizedCostText,
    );

    debugPrint(
      'Selected food aid API value: '
      '${_selectedFoodAidType?.apiValue}',
    );

    debugPrint(
      'Number individuals: '
      '$_numberIndividuals',
    );

    debugPrint(
      'Arabic details length: '
      '${detailsAr.length}',
    );

    debugPrint(
      'English details length: '
      '${detailsEn.length}',
    );

    debugPrint(
      'Raw cost: $costText',
    );

    debugPrint(
      'Normalized cost: '
      '$normalizedCostText',
    );

    debugPrint(
      'Parsed cost: $cost',
    );

    debugPrint(
      'Existing attachments count: '
      '${_existingMediaUrls.length}',
    );

    debugPrint(
      'New attachments count: '
      '${_attachments.length}',
    );

    if (_selectedFoodAidType == null) {
      debugPrint(
        'Validation failed: '
        'Food aid type is missing',
      );

      _showValidationMessage(
        l10n.selectFoodAidType,
      );

      return;
    }

    if (_numberIndividuals <= 0) {
      debugPrint(
        'Validation failed: '
        'Invalid number individuals',
      );

      _showValidationMessage(
        l10n.invalidIndividualsCount,
      );

      return;
    }

    final String? arabicDetailsError =
        _validateArabicDetails(
      detailsAr,
    );

    if (arabicDetailsError != null) {
      debugPrint(
        'Validation failed: '
        '$arabicDetailsError',
      );

      _showValidationMessage(
        arabicDetailsError,
      );

      return;
    }

    final String? englishDetailsError =
        _validateEnglishDetails(
      detailsEn,
    );

    if (englishDetailsError != null) {
      debugPrint(
        'Validation failed: '
        '$englishDetailsError',
      );

      _showValidationMessage(
        englishDetailsError,
      );

      return;
    }

    if (cost == null ||
        cost <= 0) {
      debugPrint(
        'Validation failed: '
        'Invalid cost',
      );

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
      debugPrint(
        'Validation failed: '
        'No attachments',
      );

      _showValidationMessage(
        l10n.foodDocumentRequired,
      );

      return;
    }

    final FoodRequestModel request =
        FoodRequestModel(
      applicantInfo:
          widget.applicantInfo,
      typeAid:
          _selectedFoodAidType!,
      numberIndividuals:
          _numberIndividuals,
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
      'FoodRequestModel created successfully',
    );

    debugPrint(
      'Request first name: '
      '${request.applicantInfo.firstName}',
    );

    debugPrint(
      'Request father name: '
      '${request.applicantInfo.fatherName}',
    );

    debugPrint(
      'Request last name: '
      '${request.applicantInfo.lastName}',
    );

    debugPrint(
      'Request typeAid: '
      '${request.typeAid.apiValue}',
    );

    debugPrint(
      'Request numberIndividuals: '
      '${request.numberIndividuals}',
    );

    debugPrint(
      'Request detailsAr: '
      '${request.detailsAr}',
    );

    debugPrint(
      'Request detailsEn: '
      '${request.detailsEn}',
    );

    debugPrint(
      'Request cost: '
      '${request.cost}',
    );

    debugPrint(
      'Request media count: '
      '${request.media.length}',
    );

    for (final PlatformFile file
        in request.media) {
      debugPrint(
        'Request food attachment name: '
        '${file.name}',
      );

      debugPrint(
        'Request food attachment path: '
        '${file.path}',
      );

      debugPrint(
        'Request food attachment bytes available: '
        '${file.bytes != null}',
      );
    }

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
        'Calling FoodCubit.updateFoodRequest',
      );

      debugPrint(
        '======================================',
      );

      context
          .read<FoodCubit>()
          .updateFoodRequest(
            requestId:
                requestId,
            request:
                request,
          );

      return;
    }

    debugPrint(
      'Calling FoodCubit.submitFoodRequest',
    );

    debugPrint(
      '======================================',
    );

    context
        .read<FoodCubit>()
        .submitFoodRequest(
          request,
        );
  }

  // =================================================
  // ARABIC VALIDATION
  // =================================================

  String? _validateArabicDetails(
    String value,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String text =
        value.trim();

    if (text.isEmpty) {
      return l10n
          .foodArabicDetailsRequired;
    }

    if (text.length < 5) {
      return l10n
          .foodArabicDetailsShort;
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

    if (!hasArabic) {
      return l10n
          .foodArabicDetailsMustContainArabic;
    }

    if (hasEnglish) {
      return l10n
          .foodArabicDetailsNoEnglish;
    }

    return null;
  }

  // =================================================
  // ENGLISH VALIDATION
  // =================================================

  String? _validateEnglishDetails(
    String value,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String text =
        value.trim();

    if (text.isEmpty) {
      return l10n
          .foodEnglishDetailsRequired;
    }

    if (text.length < 5) {
      return l10n
          .foodEnglishDetailsShort;
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

    if (!hasEnglish) {
      return l10n
          .foodEnglishDetailsMustContainEnglish;
    }

    if (hasArabic) {
      return l10n
          .foodEnglishDetailsNoArabic;
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
        'Cannot show SnackBar: '
        'widget is not mounted',
      );

      return;
    }

    debugPrint(
      'Showing food validation SnackBar: '
      '$message',
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
  // ATTACHMENTS LIST
  // =================================================

  Widget _buildAttachmentsList(
    bool isLoading,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    if (_attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),

        ..._attachments
            .asMap()
            .entries
            .map(
          (
            MapEntry<int, PlatformFile>
                entry,
          ) {
            final PlatformFile file =
                entry.value;

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
                      AppColors.brandGray
                          .withOpacity(
                    0.16,
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

                trailing: IconButton(
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
    );
  }

  // =================================================
  // DECORATIVE CARD
  // =================================================

  Widget _buildDecorativeCard() {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(
        22,
      ),
      decoration:
          BoxDecoration(
        color:
            AppColors.primaryContainer
                .withOpacity(
          0.35,
        ),
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        border: Border.all(
          color:
              AppColors.primary
                  .withOpacity(
            0.12,
          ),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons
                .volunteer_activism_outlined,
            size: 52,
            color:
                AppColors.primary,
          ),

          const SizedBox(
            height: 12,
          ),

          Text(
            l10n.foodDecorativeMessage,
            textAlign:
                TextAlign.center,
            style:
                const TextStyle(
              color:
                  AppColors.primary,
              fontSize: 15,
              fontWeight:
                  FontWeight.w600,
              fontFamily:
                  AppTextStyles.fontFamily,
            ),
          ),
        ],
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
        FoodCubit,
        FoodState>(
      listener: (
        context,
        state,
      ) async {
        debugPrint(
          'FoodRequestPage listener state: '
          '${state.runtimeType}',
        );

        if (state
            is FoodSuccess) {
          debugPrint(
            'Food request succeeded',
          );

          debugPrint(
            'Success message: '
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

              Navigator.of(context)
                  .popUntil(
                (
                  Route<dynamic> route,
                ) {
                  return route.isFirst;
                },
              );
            },
          );
        } else if (state
            is FoodFailure) {
          debugPrint(
            'Food request failed',
          );

          debugPrint(
            'Failure message: '
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
            state is FoodLoading;

        debugPrint(
          'FoodRequestPage builder state: '
          '${state.runtimeType}',
        );

        debugPrint(
          'FoodRequestPage isLoading: '
          '$isLoading',
        );

        return Scaffold(
          backgroundColor:
              AppColors.background,

          // ==========================================
          // APP BAR
          // ==========================================

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
                      debugPrint(
                        'Food page back button pressed',
                      );

                      Navigator.pop(
                        context,
                      );
                    },
            ),

            title: Text(
              widget.isEditMode
                  ? l10n
                      .editFoodRequestDetails
                  : l10n
                      .foodRequestDetails,
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

          // ==========================================
          // BODY
          // ==========================================

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
                12,
                20,
                120,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const CustomStepIndicator(
                    currentStep: 2,
                    totalSteps: 2,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  if (widget
                      .isEditMode) ...[
                    _buildEditInfoCard(),

                    const SizedBox(
                      height: 20,
                    ),
                  ],

                  // ===================================
                  // FOOD AID TYPE
                  // ===================================

                  _buildSectionLabel(
                    l10n.foodAidType,
                  ),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        FoodAidType.values.map(
                      (
                        FoodAidType type,
                      ) {
                        return SelectionChip(
                          label:
                              _foodAidTypeLabel(
                            type,
                            l10n,
                          ),

                          isSelected:
                              _selectedFoodAidType ==
                                  type,

                          onTap: isLoading
                              ? () {}
                              : () {
                                  debugPrint(
                                    'Food aid type selected',
                                  );

                                  debugPrint(
                                    'API value: '
                                    '${type.apiValue}',
                                  );

                                  setState(
                                    () {
                                      _selectedFoodAidType =
                                          type;
                                    },
                                  );
                                },
                        );
                      },
                    ).toList(),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ===================================
                  // NUMBER OF INDIVIDUALS
                  // ===================================

                  BeneficiariesCounter(
                    count:
                        _numberIndividuals,
                    onIncrement:
                        isLoading
                            ? () {}
                            : _incrementIndividuals,
                    onDecrement:
                        isLoading
                            ? () {}
                            : _decrementIndividuals,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ===================================
                  // DETAILS AR
                  // ===================================

                  CustomTextField(
                    label:
                        l10n.foodDetailsArabic,
                    hint:
                        l10n.foodDetailsArabicHint,
                    controller:
                        _detailsArController,
                    maxLines: 5,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  // ===================================
                  // DETAILS EN
                  // ===================================

                  CustomTextField(
                    label:
                        l10n.foodDetailsEnglish,
                    hint:
                        l10n.foodDetailsEnglishHint,
                    controller:
                        _detailsEnController,
                    maxLines: 5,
                    isLtr: true,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  // ===================================
                  // COST
                  // ===================================

                  CustomTextField(
                    label:
                        l10n.expectedFoodCost,
                    hint: '0.00',
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

                  // ===================================
                  // DOCUMENTS
                  // ===================================

                  _buildSectionLabel(
                    l10n.supportingDocuments,
                  ),

                  if (_existingMediaUrls
                      .isNotEmpty) ...[
                    _buildExistingAttachmentsSection(),

                    const SizedBox(
                      height: 16,
                    ),
                  ],

                  CustomAttachmentUploader(
                    title:
                        widget.isEditMode
                            ? l10n
                                .addNewDocuments
                            : l10n
                                .uploadFilesOrCapture,

                    description:
                        widget.isEditMode
                            ? l10n
                                .foodNewDocumentsDescription
                            : l10n
                                .foodDocumentsDescription,

                    icon:
                        Icons.upload_file_rounded,

                    onTap:
                        isLoading
                            ? () {}
                            : _pickAttachments,
                  ),

                  _buildAttachmentsList(
                    isLoading,
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  _buildDecorativeCard(),
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
  // EDIT INFO CARD
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
        color:
            AppColors.primaryContainer
                .withOpacity(
          0.45,
        ),
        borderRadius:
            BorderRadius.circular(
          16,
        ),
        border: Border.all(
          color:
              AppColors.primary
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
                    AppTextStyles.fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =================================================
  // EXISTING ATTACHMENTS
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

        ..._existingMediaUrls.map(
          (
            String path,
          ) {
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
                    color:
                        AppColors.primaryContainer
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

    if (parts.isEmpty ||
        parts.last.trim().isEmpty) {
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
  // FILE DESCRIPTION
  // =================================================

  String _getFileDescription(
    PlatformFile file,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String formattedSize =
        _formatFileSize(
      file.size,
    );

    if (kIsWeb) {
      return '$formattedSize - '
          '${l10n.fileReadyForUpload}';
    }

    return '$formattedSize - '
        '${file.path ?? ''}';
  }

  String _formatFileSize(
    int bytes,
  ) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes <
        1024 * 1024) {
      final double kilobytes =
          bytes / 1024;

      return '${kilobytes.toStringAsFixed(1)} KB';
    }

    final double megabytes =
        bytes /
            (1024 * 1024);

    return '${megabytes.toStringAsFixed(1)} MB';
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