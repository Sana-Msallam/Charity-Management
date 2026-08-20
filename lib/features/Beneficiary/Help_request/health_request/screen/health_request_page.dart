import 'package:charity_management/features/Beneficiary/Help_request/applicantInfo/model/applicant_info_model.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/cubit/health_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/cubit/health_state.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/model/health_aid_type.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/model/health_request_model.dart';
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

class HealthRequestPage extends StatefulWidget {
  const HealthRequestPage({
    super.key,
    required this.applicantInfo,
    this.requestDetails,
  });

  final ApplicantInfoModel applicantInfo;
  final RequestDetailsModel? requestDetails;

  bool get isEditMode => requestDetails != null;

  @override
  State<HealthRequestPage> createState() {
    return _HealthRequestPageState();
  }
}

class _HealthRequestPageState extends State<HealthRequestPage> {
  final TextEditingController _detailsArController =
      TextEditingController();

  final TextEditingController _detailsEnController =
      TextEditingController();

  final TextEditingController _costController =
      TextEditingController();

  final List<PlatformFile> _attachments =
      <PlatformFile>[];

  final List<String> _existingMediaUrls =
      <String>[];

  HealthAidType? _selectedMedicalType;

  @override
  void initState() {
    super.initState();

    debugPrint('======================================');
    debugPrint('HealthRequestPage opened');
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
      _fillExistingHealthData();
    }

    debugPrint('======================================');
  }

  void _fillExistingHealthData() {
    final RequestDetailsModel? request =
        widget.requestDetails;

    if (request == null) {
      return;
    }

    debugPrint('======================================');
    debugPrint('FILL EXISTING HEALTH DATA');
    debugPrint('Request id: ${request.id}');
    debugPrint('Category id: ${request.categoryId}');

    if (request.categoryId != 1) {
      debugPrint(
        'Unexpected category id for health edit: '
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

      for (final HealthAidType type
          in HealthAidType.values) {
        if (type.apiValue ==
            normalizedValue) {
          _selectedMedicalType = type;
          break;
        }
      }
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
      'Health aid type: '
      '${_selectedMedicalType?.apiValue}',
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

  @override
  void dispose() {
    _detailsArController.dispose();
    _detailsEnController.dispose();
    _costController.dispose();

    debugPrint(
      'HealthRequestPage disposed',
    );

    super.dispose();
  }

  String _healthAidTypeLabel(
    HealthAidType type,
    AppLocalizations l10n,
  ) {
    switch (type) {
      case HealthAidType.medicineInsurance:
        return l10n.medicineInsurance;

      case HealthAidType.surgery:
        return l10n.surgery;

      case HealthAidType.medicalDevices:
        return l10n.medicalDevices;
    }
  }

  Future<void> _pickAttachments() async {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    debugPrint('======================================');
    debugPrint('Attachment picker opened');

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
          'Attachment selection cancelled',
        );
        return;
      }

      if (!mounted) {
        return;
      }

      final List<PlatformFile>
          selectedFiles =
          result.files.where(
        (
          PlatformFile newFile,
        ) {
          return !_attachments.any(
            (
              PlatformFile oldFile,
            ) {
              return oldFile.name ==
                      newFile.name &&
                  oldFile.size ==
                      newFile.size;
            },
          );
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
        if (kIsWeb) {
          if (file.bytes == null ||
              file.bytes!.isEmpty) {
            continue;
          }
        } else {
          if (file.path == null ||
              file.path!
                  .trim()
                  .isEmpty) {
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
    } catch (error, stackTrace) {
      debugPrint(
        'Attachment picker error: $error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

      if (mounted) {
        _showValidationMessage(
          l10n.fileSelectionFailed,
        );
      }
    }
  }

  void _removeAttachment(
    int index,
  ) {
    if (index < 0 ||
        index >= _attachments.length) {
      return;
    }

    _attachments.removeAt(
      index,
    );

    setState(() {});
  }

  void _submit() {
    final AppLocalizations localizations =
        AppLocalizations.of(context);

    FocusScope.of(context).unfocus();

    final String detailsAr =
        _detailsArController.text.trim();

    final String detailsEn =
        _detailsEnController.text.trim();

    final String costText =
        _costController.text.trim();

    final double? cost =
        double.tryParse(
      costText.replaceAll(
        ',',
        '.',
      ),
    );

    if (_selectedMedicalType == null) {
      _showValidationMessage(
        localizations.medicalAidTypeRequired,
      );
      return;
    }

    final String? arabicDetailsError =
        _validateArabicDetails(
      detailsAr,
    );

    if (arabicDetailsError != null) {
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
      _showValidationMessage(
        englishDetailsError,
      );
      return;
    }

    if (cost == null ||
        cost <= 0) {
      _showValidationMessage(
        localizations.validCostRequired,
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
        localizations.medicalAttachmentRequired,
      );
      return;
    }

    final HealthRequestModel request =
        HealthRequestModel(
      applicantInfo:
          widget.applicantInfo,
      typeAid:
          _selectedMedicalType!,
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
      'Request typeAid: '
      '${request.typeAid.apiValue}',
    );

    if (widget.isEditMode) {
      final int? requestId =
          widget.requestDetails?.id;

      if (requestId == null) {
        _showValidationMessage(
          localizations.requestIdUnavailable,
        );
        return;
      }

      context
          .read<HealthCubit>()
          .updateHealthRequest(
            requestId:
                requestId,
            request:
                request,
            localizations:
                localizations,
          );

      return;
    }

    context
        .read<HealthCubit>()
        .submitHealthRequest(
          request,
          localizations,
        );
  }

  String? _validateArabicDetails(
    String value,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String text =
        value.trim();

    if (text.isEmpty) {
      return l10n
          .healthArabicDetailsRequired;
    }

    if (text.length < 5) {
      return l10n
          .healthArabicDetailsShort;
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
          .healthArabicDetailsMustContainArabic;
    }

    if (hasEnglish) {
      return l10n
          .healthArabicDetailsNoEnglish;
    }

    return null;
  }

  String? _validateEnglishDetails(
    String value,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String text =
        value.trim();

    if (text.isEmpty) {
      return l10n
          .healthEnglishDetailsRequired;
    }

    if (text.length < 5) {
      return l10n
          .healthEnglishDetailsShort;
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
          .healthEnglishDetailsMustContainEnglish;
    }

    if (hasArabic) {
      return l10n
          .healthEnglishDetailsNoArabic;
    }

    return null;
  }

  void _showValidationMessage(
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
              FontWeight.w500,
          fontFamily:
              AppTextStyles.fontFamily,
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return BlocConsumer<
        HealthCubit,
        HealthState>(
      listener: (
        context,
        state,
      ) async {
        if (state
            is HealthSuccess) {
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
            is HealthFailure) {
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
            state is HealthLoading;

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
              onPressed:
                  isLoading
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
                      .editHealthRequestDetails
                  : l10n
                      .healthRequestDetails,
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
                12,
                20,
                100,
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

                  _buildSectionLabel(
                    l10n.medicalAidType,
                  ),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        HealthAidType.values.map(
                      (
                        HealthAidType type,
                      ) {
                        return SelectionChip(
                          label:
                              _healthAidTypeLabel(
                            type,
                            l10n,
                          ),
                          isSelected:
                              _selectedMedicalType ==
                                  type,
                          onTap:
                              isLoading
                                  ? () {}
                                  : () {
                                      setState(
                                        () {
                                          _selectedMedicalType =
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

                  CustomTextField(
                    label:
                        l10n.healthDetailsArabic,
                    hint:
                        l10n.healthDetailsArabicHint,
                    controller:
                        _detailsArController,
                    maxLines: 5,
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  CustomTextField(
                    label:
                        l10n.healthDetailsEnglish,
                    hint:
                        l10n.healthDetailsEnglishHint,
                    controller:
                        _detailsEnController,
                    maxLines: 5,
                    isLtr: true,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  CustomTextField(
                    label:
                        l10n.treatmentExpectedCost,
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

                  _buildSectionLabel(
                    l10n.medicalReportsUpload,
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
                                .addNewMedicalDocuments
                            : l10n
                                .uploadFilesOrCapture,
                    description:
                        widget.isEditMode
                            ? l10n
                                .medicalNewDocumentsDescription
                           : l10n.medicalReportsUploadDescription,
                    icon:
                        Icons.camera_alt_rounded,
                    onTap:
                        isLoading
                            ? () {}
                            : _pickAttachments,
                  ),

                  if (_attachments
                      .isNotEmpty) ...[
                    const SizedBox(
                      height: 12,
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
                              color:
                                  AppColors.brandGray
                                      .withOpacity(
                                0.16,
                              ),
                            ),
                          ),
                          child:
                              ListTile(
                            dense: true,
                            leading:
                                Container(
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
                                    BorderRadius
                                        .circular(
                                  12,
                                ),
                              ),
                              child:
                                  Icon(
                                _getFileIcon(
                                  file.extension,
                                ),
                                color:
                                    AppColors.primary,
                              ),
                            ),
                            title:
                                Text(
                              file.name,
                              maxLines: 1,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,
                                fontFamily:
                                    AppTextStyles
                                        .fontFamily,
                              ),
                            ),
                            subtitle:
                                Text(
                              _getFileDescription(
                                file,
                              ),
                              maxLines: 1,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
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
      return '$size - '
          '${l10n.fileReadyForUpload}';
    }

    return '$size - '
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
        return Icons.image_outlined;

      case 'pdf':
        return Icons
            .picture_as_pdf_outlined;

      default:
        return Icons.attach_file;
    }
  }

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