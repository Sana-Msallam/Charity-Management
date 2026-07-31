import 'package:charity_management/features/components/custom_attachment_uploader.dart';
import 'package:charity_management/features/components/custom_step_Indicator.dart';
import 'package:charity_management/features/components/selection_chip.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/cubit/health_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/cubit/health_state.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/model/applicant_info_model.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/model/health_aid_type.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/model/health_request_model.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/widgets/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';

class HealthRequestPage extends StatefulWidget {
  const HealthRequestPage({super.key, required this.applicantInfo});

  final ApplicantInfoModel applicantInfo;

  @override
  State<HealthRequestPage> createState() {
    return _HealthRequestPageState();
  }
}

class _HealthRequestPageState extends State<HealthRequestPage> {
  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _costController = TextEditingController();

  // يعمل على Web وAndroid معًا.
  final List<PlatformFile> _attachments = [];

  HealthAidType? _selectedMedicalType;

  @override
  void initState() {
    super.initState();

    debugPrint('======================================');
    debugPrint('HealthRequestPage opened');
    debugPrint('Applicant data received:');

    debugPrint('First name: ${widget.applicantInfo.firstName}');

    debugPrint('Father name: ${widget.applicantInfo.fatherName}');

    debugPrint('Last name: ${widget.applicantInfo.lastName}');

    debugPrint('Age: ${widget.applicantInfo.age}');

    debugPrint('Gender: ${widget.applicantInfo.gender}');

    debugPrint('Social status: ${widget.applicantInfo.socialStatus}');

    debugPrint('Phone number: ${widget.applicantInfo.phoneNumber}');

    debugPrint('Address: ${widget.applicantInfo.address}');

    debugPrint('Is unemployed: ${widget.applicantInfo.isUnemployed}');

    debugPrint('======================================');
  }

  @override
  void dispose() {
    debugPrint('HealthRequestPage disposed');

    _descriptionController.dispose();
    _costController.dispose();

    super.dispose();
  }

  Future<void> _pickAttachments() async {
    debugPrint('======================================');
    debugPrint('Attachment picker opened');

    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],

        /*
         * على Web يجب جلب bytes.
         * على Android نعتمد على path لتقليل استخدام الذاكرة.
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

      for (final PlatformFile platformFile in result.files) {
        debugPrint('Selected file information:');

        debugPrint('Name: ${platformFile.name}');

        debugPrint('Path: ${platformFile.path}');

        debugPrint(
          'Bytes available: '
          '${platformFile.bytes != null}',
        );

        debugPrint('Size: ${platformFile.size} bytes');

        debugPrint('Extension: ${platformFile.extension}');
      }

      /*
       * لا نستخدم result.paths لأن paths غير مدعوم
       * على Flutter Web.
       *
       * نستخدم result.files لأنه يعمل على Web
       * وAndroid.
       */
      final List<PlatformFile> selectedFiles = result.files.where((
        PlatformFile newFile,
      ) {
        final bool alreadyExists = _attachments.any((PlatformFile oldFile) {
          return oldFile.name == newFile.name && oldFile.size == newFile.size;
        });

        return !alreadyExists;
      }).toList();

      if (selectedFiles.isEmpty) {
        debugPrint('No new files were selected');

        _showMessage(AppLocalizations.of(context).duplicateFiles);

        debugPrint('======================================');
        return;
      }

      /*
       * نتأكد أن ملفات Web تحتوي bytes،
       * وملفات Android تحتوي path.
       */
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
        debugPrint('No valid accessible files were found');

        _showMessage(AppLocalizations.of(context).filesAccessFailed);

        debugPrint('======================================');
        return;
      }

      setState(() {
        _attachments.addAll(validFiles);
      });

      debugPrint(
        'Files added successfully: '
        '${validFiles.length}',
      );

      debugPrint(
        'Total attachments: '
        '${_attachments.length}',
      );

      debugPrint('======================================');
    } catch (error, stackTrace) {
      debugPrint('Attachment picker error');

      debugPrint('Error: $error');

      debugPrint('Stack trace: $stackTrace');

      debugPrint('======================================');

      if (mounted) {
        _showMessage(AppLocalizations.of(context).fileSelectionFailed);
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

    debugPrint('Attachment removed: ${removedFile.name}');

    debugPrint(
      'Remaining attachments: '
      '${_attachments.length}',
    );
  }

  void _submit() {
    debugPrint('======================================');
    debugPrint('HealthRequestPage: Submit clicked');

    final String description = _descriptionController.text.trim();

    final String costText = _costController.text.trim();

    final String normalizedCostText = costText.replaceAll(',', '.');

    final double? cost = double.tryParse(normalizedCostText);

    debugPrint(
      'Selected medical type label: '
      '${_selectedMedicalType?.arabicLabel}',
    );

    debugPrint(
      'Selected medical type API value: '
      '${_selectedMedicalType?.apiValue}',
    );

    debugPrint(
      'Description length: '
      '${description.length}',
    );

    debugPrint('Raw cost: $costText');

    debugPrint('Normalized cost: $normalizedCostText');

    debugPrint('Parsed cost: $cost');

    debugPrint(
      'Attachments count: '
      '${_attachments.length}',
    );

    if (_selectedMedicalType == null) {
      debugPrint('Validation failed: Medical type is missing');

      _showMessage(AppLocalizations.of(context).medicalAidTypeRequired);

      debugPrint('======================================');
      return;
    }

    if (description.isEmpty) {
      debugPrint('Validation failed: Description is empty');

      _showMessage(AppLocalizations.of(context).healthDescriptionRequired);

      debugPrint('======================================');
      return;
    }

    if (cost == null || cost <= 0) {
      debugPrint('Validation failed: Invalid cost');

      _showMessage(AppLocalizations.of(context).validCostRequired);

      debugPrint('======================================');
      return;
    }

    if (_attachments.isEmpty) {
      debugPrint('Validation failed: No attachments');

      _showMessage(AppLocalizations.of(context).medicalAttachmentRequired);

      debugPrint('======================================');
      return;
    }

    final HealthRequestModel request = HealthRequestModel(
      applicantInfo: widget.applicantInfo,
      typeAid: _selectedMedicalType!,
      description: description,
      cost: cost,

      // أصبح النوع PlatformFile بدل File.
      media: List<PlatformFile>.unmodifiable(_attachments),
    );

    debugPrint('HealthRequestModel created successfully');

    debugPrint(
      'Request applicant firstName: '
      '${request.applicantInfo.firstName}',
    );

    debugPrint(
      'Request applicant fatherName: '
      '${request.applicantInfo.fatherName}',
    );

    debugPrint(
      'Request applicant lastName: '
      '${request.applicantInfo.lastName}',
    );

    debugPrint(
      'Request applicant gender: '
      '${request.applicantInfo.gender}',
    );

    debugPrint(
      'Request applicant socialStatus: '
      '${request.applicantInfo.socialStatus}',
    );

    debugPrint(
      'Request typeAid: '
      '${request.typeAid.apiValue}',
    );

    debugPrint('Request cost: ${request.cost}');

    debugPrint(
      'Request media count: '
      '${request.media.length}',
    );

    for (final PlatformFile file in request.media) {
      debugPrint(
        'Request attachment name: '
        '${file.name}',
      );

      debugPrint(
        'Request attachment path: '
        '${file.path}',
      );

      debugPrint(
        'Request attachment bytes available: '
        '${file.bytes != null}',
      );
    }

    debugPrint('Calling HealthCubit.submitHealthRequest');

    debugPrint('======================================');
    final localizations = AppLocalizations.of(context);

    context.read<HealthCubit>().submitHealthRequest(request, localizations);
  }

  void _showMessage(String message) {
    if (!mounted) {
      debugPrint('Cannot show SnackBar because widget is not mounted');

      return;
    }

    debugPrint('Showing SnackBar: $message');

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0, bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.brandGray,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _medicalAidTypeLabel(BuildContext context, HealthAidType type) {
    final l10n = AppLocalizations.of(context);

    return switch (type) {
      HealthAidType.medicineInsurance => l10n.medicineInsurance,
      HealthAidType.surgery => l10n.surgery,
      HealthAidType.medicalDevices => l10n.medicalDevices,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HealthCubit, HealthState>(
      listener: (context, state) {
        debugPrint(
          'HealthRequestPage listener state: '
          '${state.runtimeType}',
        );

        if (state case HealthSuccess(:final message)) {
          debugPrint('Health request succeeded');

          debugPrint('Server success message: $message');

          _showMessage(message);
        } else if (state case HealthFailure(:final message)) {
          debugPrint('Health request failed');

          debugPrint('Failure message: $message');

          _showMessage(message);
        }
      },
      builder: (context, state) {
        final l10n = AppLocalizations.of(context);
        final bool isLoading = state is HealthLoading;

        debugPrint(
          'HealthRequestPage builder state: '
          '${state.runtimeType}',
        );

        debugPrint(
          'HealthRequestPage isLoading: '
          '$isLoading',
        );

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background.withValues(alpha: 0.9),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_forward, color: AppColors.primary),
              onPressed: isLoading
                  ? null
                  : () {
                      debugPrint('Back button pressed');

                      Navigator.pop(context);
                    },
            ),
            title: Text(
              l10n.healthRequestDetails,
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
              padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomStepIndicator(currentStep: 2, totalSteps: 2),

                  const SizedBox(height: 24),

                  _buildSectionLabel(l10n.medicalAidType),

                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: HealthAidType.values.map((HealthAidType type) {
                      return SelectionChip(
                        label: _medicalAidTypeLabel(context, type),
                        isSelected: _selectedMedicalType == type,
                        onTap: isLoading
                            ? () {
                                debugPrint(
                                  'Medical type selection ignored while loading',
                                );
                              }
                            : () {
                                debugPrint('Medical type selected:');

                                debugPrint(
                                  'Arabic label: '
                                  '${type.arabicLabel}',
                                );

                                debugPrint(
                                  'API value: '
                                  '${type.apiValue}',
                                );

                                setState(() {
                                  _selectedMedicalType = type;
                                });
                              },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  CustomTextField(
                    label: l10n.healthDescription,
                    hint: l10n.healthDescriptionHint,
                    controller: _descriptionController,
                    maxLines: 5,
                  ),

                  const SizedBox(height: 24),

                  CustomTextField(
                    label: l10n.treatmentExpectedCost,
                    hint: '0.00',
                    controller: _costController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    isCurrency: true,
                  ),

                  const SizedBox(height: 24),

                  _buildSectionLabel(l10n.medicalReportsUpload),

                  CustomAttachmentUploader(
                    title: l10n.uploadFilesOrCapture,
                    description: l10n.medicalReportsUploadDescription,
                    icon: Icons.camera_alt_rounded,
                    onTap: isLoading
                        ? () {
                            debugPrint(
                              'Attachment picker ignored while loading',
                            );
                          }
                        : _pickAttachments,
                  ),

                  if (_attachments.isNotEmpty) ...[
                    const SizedBox(height: 12),

                    ..._attachments.asMap().entries.map((
                      MapEntry<int, PlatformFile> entry,
                    ) {
                      final PlatformFile file = entry.value;

                      return Card(
                        child: ListTile(
                          dense: true,
                          leading: Icon(_getFileIcon(file.extension)),
                          title: Text(
                            file.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            _getFileDescription(context, file),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            tooltip: l10n.deleteAttachment,
                            icon: const Icon(Icons.close),
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
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomSubmitButton(context, isLoading),
        );
      },
    );
  }

  String _getFileDescription(BuildContext context, PlatformFile file) {
    final String formattedSize = _formatFileSize(file.size);

    if (kIsWeb) {
      return '$formattedSize - ${AppLocalizations.of(context).fileReadyForUpload}';
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

  Widget _buildBottomSubmitButton(BuildContext context, bool isLoading) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        border: Border(
          top: BorderSide(color: AppColors.brandGray.withValues(alpha: 0.1)),
        ),
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.submitRequestForReview,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppTextStyles.fontFamily,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.send, size: 18),
                ],
              ),
      ),
    );
  }
}
