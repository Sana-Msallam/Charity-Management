import 'package:charity_management/features/Beneficiary/Help_request/applicantInfo/model/applicant_info_model.dart';
import 'package:charity_management/features/Beneficiary/Help_request/smaal_project_request/cubit/small_project_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/smaal_project_request/cubit/small_project_state.dart';
import 'package:charity_management/features/Beneficiary/Help_request/smaal_project_request/model/small_project_request_model.dart';
import 'package:charity_management/features/Beneficiary/request_tracking/model/request_details_model.dart';
import 'package:charity_management/features/components/custom_attachment_uploader.dart';
import 'package:charity_management/features/components/custom_step_Indicator.dart';
import 'package:charity_management/features/components/request_result_dialog.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/widgets/custom_text_field.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SmallProjectRequestPage extends StatefulWidget {
  const SmallProjectRequestPage({
    super.key,
    required this.applicantInfo,
    this.requestDetails,
  });

  final ApplicantInfoModel applicantInfo;
  final RequestDetailsModel? requestDetails;

  bool get isEditMode => requestDetails != null;

  @override
  State<SmallProjectRequestPage> createState() {
    return _SmallProjectRequestPageState();
  }
}

class _SmallProjectRequestPageState extends State<SmallProjectRequestPage> {
  final TextEditingController _projectNameArController =
      TextEditingController();

  final TextEditingController _projectNameEnController =
      TextEditingController();

  final TextEditingController _projectCategoryArController =
      TextEditingController();

  final TextEditingController _projectCategoryEnController =
      TextEditingController();

  final TextEditingController _numberOfPeopleController =
      TextEditingController();

  final TextEditingController _detailsArController = TextEditingController();

  final TextEditingController _detailsEnController = TextEditingController();

  final TextEditingController _costController = TextEditingController();

  final List<PlatformFile> _attachments = [];
  final List<String> _existingMediaUrls = [];

  @override
  void initState() {
    super.initState();

    debugPrint('======================================');
    debugPrint('SmallProjectRequestPage opened');
    debugPrint('Applicant firstName: ${widget.applicantInfo.firstName}');
    debugPrint('Applicant lastName: ${widget.applicantInfo.lastName}');

    if (widget.isEditMode) {
      _fillExistingSmallProjectData();
    }

    debugPrint('======================================');
  }

  void _fillExistingSmallProjectData() {
    final RequestDetailsModel? request = widget.requestDetails;

    if (request == null) {
      return;
    }

    debugPrint('======================================');
    debugPrint('FILL EXISTING SMALL PROJECT DATA');
    debugPrint('Request id: ${request.id}');
    debugPrint('Category id: ${request.categoryId}');
    debugPrint('Subcategory id: ${request.subCategoryId}');

    if (request.categoryId != 5) {
      debugPrint(
        'Unexpected category id for Small Project edit: '
        '${request.categoryId}',
      );
    }

    _projectNameArController.text =
        request.getAidDetailStringAr('projectName') ?? '';
    _projectNameEnController.text =
        request.getAidDetailStringEn('projectName') ?? '';
    _projectCategoryArController.text =
        request.getAidDetailStringAr('projectCategory') ?? '';
    _projectCategoryEnController.text =
        request.getAidDetailStringEn('projectCategory') ?? '';

    final int? numberOfPeopleSupported = request.getAidDetailInt(
      'numberOfPeopleSupported',
    );

    _numberOfPeopleController.text = numberOfPeopleSupported?.toString() ?? '';
    _detailsArController.text = request.detailsAr ?? '';
    _detailsEnController.text = request.detailsEn ?? '';
    _costController.text = _formatCost(request.cost);

    _existingMediaUrls
      ..clear()
      ..addAll(request.getAidDetailStringList('mediaUrls'));

    debugPrint('Project name AR: ${_projectNameArController.text}');
    debugPrint('Project name EN: ${_projectNameEnController.text}');
    debugPrint('Number of people supported: ${_numberOfPeopleController.text}');
    debugPrint('Existing media: $_existingMediaUrls');
    debugPrint('======================================');
  }

  String _formatCost(double value) {
    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  @override
  void dispose() {
    _projectNameArController.dispose();
    _projectNameEnController.dispose();
    _projectCategoryArController.dispose();
    _projectCategoryEnController.dispose();
    _numberOfPeopleController.dispose();
    _detailsArController.dispose();
    _detailsEnController.dispose();
    _costController.dispose();

    debugPrint('SmallProjectRequestPage disposed');

    super.dispose();
  }

  Future<void> _pickAttachments() async {
    final AppLocalizations l10n = AppLocalizations.of(context);

    debugPrint('======================================');
    debugPrint('Small project attachment picker opened');

    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: const ['jpg', 'jpeg', 'png', 'pdf'],
        withData: kIsWeb,
      );

      if (result == null) {
        debugPrint('Small project attachment selection cancelled');
        return;
      }

      if (!mounted) {
        return;
      }

      final List<PlatformFile> validFiles = [];

      for (final PlatformFile file in result.files) {
        final bool alreadyExists = _attachments.any((PlatformFile oldFile) {
          return oldFile.name == file.name && oldFile.size == file.size;
        });

        if (alreadyExists) {
          continue;
        }

        if (kIsWeb) {
          if (file.bytes == null || file.bytes!.isEmpty) {
            continue;
          }
        } else {
          if (file.path == null || file.path!.trim().isEmpty) {
            continue;
          }
        }

        validFiles.add(file);
      }

      if (validFiles.isEmpty) {
        _showValidationMessage(
          l10n.smallProjectFilesUnavailable,
        );
        return;
      }

      setState(() {
        _attachments.addAll(validFiles);
      });

      debugPrint('Small project files added: ${validFiles.length}');
      debugPrint('Total attachments: ${_attachments.length}');
    } catch (error, stackTrace) {
      debugPrint('Small project attachment error: $error');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        _showValidationMessage(l10n.fileSelectionFailed);
      }
    }
  }

  void _removeAttachment(int index) {
    if (index < 0 || index >= _attachments.length) {
      return;
    }

    final PlatformFile removed = _attachments[index];

    setState(() {
      _attachments.removeAt(index);
    });

    debugPrint('Small project attachment removed: ${removed.name}');
  }

  void _submit() {
    final AppLocalizations l10n = AppLocalizations.of(context);

    debugPrint('======================================');
    debugPrint('Small project submit clicked');

    FocusScope.of(context).unfocus();

    final String projectNameAr = _projectNameArController.text.trim();

    final String projectNameEn = _projectNameEnController.text.trim();

    final String projectCategoryAr = _projectCategoryArController.text.trim();

    final String projectCategoryEn = _projectCategoryEnController.text.trim();

    final int? numberOfPeople = int.tryParse(
      _numberOfPeopleController.text.trim(),
    );

    final String detailsAr = _detailsArController.text.trim();

    final String detailsEn = _detailsEnController.text.trim();

    final double? cost = double.tryParse(
      _costController.text.trim().replaceAll(',', '.'),
    );

    debugPrint('projectNameAr: $projectNameAr');
    debugPrint('projectNameEn: $projectNameEn');
    debugPrint('projectCategoryAr: $projectCategoryAr');
    debugPrint('projectCategoryEn: $projectCategoryEn');
    debugPrint('numberOfPeopleSupported: $numberOfPeople');
    debugPrint('detailsAr length: ${detailsAr.length}');
    debugPrint('detailsEn length: ${detailsEn.length}');
    debugPrint('cost: $cost');
    debugPrint('Existing attachments count: ${_existingMediaUrls.length}');
    debugPrint('New attachments count: ${_attachments.length}');

    final String? projectNameArError = _validateArabicField(
      projectNameAr,
      emptyMessage: l10n.projectNameArabicRequired,
      shortMessage: l10n.projectNameArabicShort,
    );

    if (projectNameArError != null) {
      _showValidationMessage(projectNameArError);
      return;
    }

    final String? projectNameEnError = _validateEnglishField(
      projectNameEn,
      emptyMessage: l10n.projectNameEnglishRequired,
      shortMessage: l10n.projectNameEnglishShort,
    );

    if (projectNameEnError != null) {
      _showValidationMessage(projectNameEnError);
      return;
    }

    final String? projectCategoryArError = _validateArabicField(
      projectCategoryAr,
      emptyMessage: l10n.projectCategoryArabicRequired,
      shortMessage: l10n.projectCategoryArabicShort,
    );

    if (projectCategoryArError != null) {
      _showValidationMessage(projectCategoryArError);
      return;
    }

    final String? projectCategoryEnError = _validateEnglishField(
      projectCategoryEn,
      emptyMessage: l10n.projectCategoryEnglishRequired,
      shortMessage: l10n.projectCategoryEnglishShort,
    );

    if (projectCategoryEnError != null) {
      _showValidationMessage(projectCategoryEnError);
      return;
    }

    if (numberOfPeople == null || numberOfPeople <= 0) {
      _showValidationMessage(l10n.validSupportedPeopleCount);
      return;
    }

    final String? detailsArError = _validateArabicField(
      detailsAr,
      emptyMessage: l10n.projectDetailsArabicRequired,
      shortMessage: l10n.projectDetailsArabicShort,
      minimumLength: 5,
    );

    if (detailsArError != null) {
      _showValidationMessage(detailsArError);
      return;
    }

    final String? detailsEnError = _validateEnglishField(
      detailsEn,
      emptyMessage: l10n.projectDetailsEnglishRequired,
      shortMessage: l10n.projectDetailsEnglishShort,
      minimumLength: 5,
    );

    if (detailsEnError != null) {
      _showValidationMessage(detailsEnError);
      return;
    }

    if (cost == null || cost <= 0) {
      _showValidationMessage(l10n.validCostRequired);
      return;
    }

    final bool hasExistingMedia = _existingMediaUrls.isNotEmpty;
    final bool hasNewMedia = _attachments.isNotEmpty;

    if (!hasExistingMedia && !hasNewMedia) {
      _showValidationMessage(l10n.smallProjectDocumentRequired);
      return;
    }

    final SmallProjectRequestModel request = SmallProjectRequestModel(
      applicantInfo: widget.applicantInfo,
      projectNameAr: projectNameAr,
      projectNameEn: projectNameEn,
      projectCategoryAr: projectCategoryAr,
      projectCategoryEn: projectCategoryEn,
      numberOfPeopleSupported: numberOfPeople,
      detailsAr: detailsAr,
      detailsEn: detailsEn,
      cost: cost,
      media: List<PlatformFile>.unmodifiable(_attachments),
    );

    final AppLocalizations localizations = AppLocalizations.of(context);

    if (widget.isEditMode) {
      final int? requestId = widget.requestDetails?.id;

      if (requestId == null) {
        _showValidationMessage(l10n.requestIdUnavailable);
        return;
      }

      context.read<SmallProjectCubit>().updateSmallProjectRequest(
        requestId: requestId,
        request: request,
        localizations: localizations,
      );
      return;
    }

    context.read<SmallProjectCubit>().submitSmallProjectRequest(
      request,
      localizations,
    );
  }

  String? _validateArabicField(
    String value, {
    required String emptyMessage,
    required String shortMessage,
    int minimumLength = 2,
  }) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String text = value.trim();

    if (text.isEmpty) {
      return emptyMessage;
    }

    if (text.length < minimumLength) {
      return shortMessage;
    }

    final bool hasArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);

    final bool hasEnglish = RegExp(r'[A-Za-z]').hasMatch(text);

    if (!hasArabic) {
      return l10n.arabicFieldMustContainArabic;
    }

    if (hasEnglish) {
      return l10n.arabicFieldNoEnglish;
    }

    return null;
  }

  String? _validateEnglishField(
    String value, {
    required String emptyMessage,
    required String shortMessage,
    int minimumLength = 2,
  }) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final String text = value.trim();

    if (text.isEmpty) {
      return emptyMessage;
    }

    if (text.length < minimumLength) {
      return shortMessage;
    }

    final bool hasEnglish = RegExp(r'[A-Za-z]').hasMatch(text);

    final bool hasArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(text);

    if (!hasEnglish) {
      return l10n.englishFieldMustContainEnglish;
    }

    if (hasArabic) {
      return l10n.englishFieldNoArabic;
    }

    return null;
  }

  void _showValidationMessage(String message) {
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
            textDirection: Directionality.of(context),
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
          fontWeight: FontWeight.w600,
          fontFamily: AppTextStyles.fontFamily,
        ),
      ),
    );
  }

  Widget _buildAttachmentsList(bool isLoading) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    if (_attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
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
          const Icon(Icons.edit_outlined, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.smallProjectEditInfo,
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

  Widget _buildDecorativeCard() {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.35),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.12)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.rocket_launch_outlined,
            size: 52,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.smallProjectDecorativeMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
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

    return BlocConsumer<SmallProjectCubit, SmallProjectState>(
      listener: (context, state) async {
        debugPrint(
          'SmallProjectRequestPage listener state: '
          '${state.runtimeType}',
        );

        if (state is SmallProjectSuccess) {
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
        } else if (state is SmallProjectFailure) {
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
        final bool isLoading = state is SmallProjectLoading;

        return Directionality(
          textDirection: Directionality.of(context),
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.pop(context);
                      },
              ),
              title: Text(
                widget.isEditMode
                    ? l10n.editSmallProjectRequestDetails
                    : l10n.smallProjectRequestDetails,
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
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
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

                    _buildSectionLabel(l10n.projectInformation),

                    CustomTextField(
                      label: l10n.projectNameArabic,
                      hint: l10n.projectNameArabicHint,
                      controller: _projectNameArController,
                      suffixIcon: Icons.storefront_outlined,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      label: l10n.projectNameEnglish,
                      hint: l10n.projectNameEnglishHint,
                      controller: _projectNameEnController,
                      suffixIcon: Icons.storefront_outlined,
                      isLtr: true,
                    ),

                    const SizedBox(height: 20),

                    CustomTextField(
                      label: l10n.projectCategoryArabic,
                      hint: l10n.projectCategoryArabicHint,
                      controller: _projectCategoryArController,
                      suffixIcon: Icons.category_outlined,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      label: l10n.projectCategoryEnglish,
                      hint: l10n.projectCategoryEnglishHint,
                      controller: _projectCategoryEnController,
                      suffixIcon: Icons.category_outlined,
                      isLtr: true,
                    ),

                    const SizedBox(height: 20),

                    CustomTextField(
                      label: l10n.numberOfPeopleSupported,
                      hint: l10n.numberOfPeopleSupportedHint,
                      controller: _numberOfPeopleController,
                      keyboardType: TextInputType.number,
                      suffixIcon: Icons.groups_outlined,
                      isLtr: true,
                    ),

                    const SizedBox(height: 24),

                    CustomTextField(
                      label: l10n.projectDetailsArabic,
                      hint:
                          l10n.projectDetailsArabicHint,
                      controller: _detailsArController,
                      maxLines: 5,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      label: l10n.projectDetailsEnglish,
                      hint:
                          l10n.projectDetailsEnglishHint,
                      controller: _detailsEnController,
                      maxLines: 5,
                      isLtr: true,
                    ),

                    const SizedBox(height: 24),

                    CustomTextField(
                      label: l10n.expectedProjectCost,
                      hint: '0.00',
                      controller: _costController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      isCurrency: true,
                    ),

                    const SizedBox(height: 24),

                    _buildSectionLabel(l10n.supportingDocuments),

                    if (_existingMediaUrls.isNotEmpty) ...[
                      _buildExistingAttachmentsSection(),
                      const SizedBox(height: 16),
                    ],

                    CustomAttachmentUploader(
                      title: widget.isEditMode
                          ? l10n.addNewDocuments
                          : l10n.uploadFilesOrCapture,
                      description: widget.isEditMode
                          ? l10n.smallProjectNewDocumentsDescription
                          : l10n.smallProjectDocumentsDescription,
                      icon: Icons.upload_file_rounded,
                      onTap: isLoading ? () {} : _pickAttachments,
                    ),

                    _buildAttachmentsList(isLoading),

                    const SizedBox(height: 28),

                    _buildDecorativeCard(),
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

  String _getFileDescription(PlatformFile file) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    final String size = _formatFileSize(file.size);

    if (kIsWeb) {
      return '$size - ${l10n.fileReadyForUpload}';
    }

    return '$size - ${file.path ?? ''}';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }

    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
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
