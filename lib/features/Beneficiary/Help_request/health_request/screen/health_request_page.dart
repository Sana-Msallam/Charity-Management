import 'package:charity_management/features/Beneficiary/Help_request/applicantInfo/model/applicant_info_model.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/cubit/health_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/cubit/health_state.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/model/health_aid_type.dart';
import 'package:charity_management/features/Beneficiary/Help_request/health_request/model/health_request_model.dart';
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
  });

  final ApplicantInfoModel applicantInfo;

  @override
  State<HealthRequestPage> createState() => _HealthRequestPageState();
}

class _HealthRequestPageState extends State<HealthRequestPage> {
  final TextEditingController _detailsArController = TextEditingController();
  final TextEditingController _detailsEnController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

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
    debugPrint('Address AR: ${widget.applicantInfo.addressAr}');
    debugPrint('Address EN: ${widget.applicantInfo.addressEn}');
    debugPrint('Is unemployed: ${widget.applicantInfo.isUnemployed}');
    debugPrint('======================================');
  }

  @override
  void dispose() {
    _detailsArController.dispose();
    _detailsEnController.dispose();
    _costController.dispose();

    debugPrint('HealthRequestPage disposed');

    super.dispose();
  }

  Future<void> _pickAttachments() async {
    debugPrint('======================================');
    debugPrint('Attachment picker opened');

    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: const [
          'jpg',
          'jpeg',
          'png',
          'pdf',
        ],
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

      final List<PlatformFile> selectedFiles = result.files.where(
        (PlatformFile newFile) {
          final bool alreadyExists = _attachments.any(
            (PlatformFile oldFile) {
              return oldFile.name == newFile.name &&
                  oldFile.size == newFile.size;
            },
          );

          return !alreadyExists;
        },
      ).toList();

      if (selectedFiles.isEmpty) {
        _showValidationMessage('الملفات المحددة مضافة مسبقاً');
        return;
      }

      final List<PlatformFile> validFiles = [];

      for (final PlatformFile file in selectedFiles) {
        debugPrint('Selected file: ${file.name}');
        debugPrint('Path: ${file.path}');
        debugPrint('Size: ${file.size}');
        debugPrint('Extension: ${file.extension}');
        debugPrint('Bytes available: ${file.bytes != null}');

        if (kIsWeb) {
          if (file.bytes == null || file.bytes!.isEmpty) {
            debugPrint('Web file bytes missing: ${file.name}');
            continue;
          }
        } else {
          if (file.path == null || file.path!.trim().isEmpty) {
            debugPrint('Mobile file path missing: ${file.name}');
            continue;
          }
        }

        validFiles.add(file);
      }

      if (validFiles.isEmpty) {
        _showValidationMessage('تعذر الوصول إلى الملفات المحددة');
        return;
      }

      setState(() {
        _attachments.addAll(validFiles);
      });

      debugPrint('Files added: ${validFiles.length}');
      debugPrint('Total attachments: ${_attachments.length}');
      debugPrint('======================================');
    } catch (error, stackTrace) {
      debugPrint('Attachment picker error');
      debugPrint('Error: $error');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('======================================');

      if (mounted) {
        _showValidationMessage(
          'تعذر اختيار الملفات، يرجى المحاولة مجدداً',
        );
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
    debugPrint('Remaining attachments: ${_attachments.length}');
  }

  void _submit() {
    debugPrint('======================================');
    debugPrint('HealthRequestPage: Submit clicked');

    FocusScope.of(context).unfocus();

    final String detailsAr = _detailsArController.text.trim();
    final String detailsEn = _detailsEnController.text.trim();
    final String costText = _costController.text.trim();

    final double? cost = double.tryParse(
      costText.replaceAll(',', '.'),
    );

    debugPrint(
      'Selected medical type API value: '
      '${_selectedMedicalType?.apiValue}',
    );
    debugPrint('Arabic details length: ${detailsAr.length}');
    debugPrint('English details length: ${detailsEn.length}');
    debugPrint('Cost: $cost');
    debugPrint('Attachments count: ${_attachments.length}');

    if (_selectedMedicalType == null) {
      _showValidationMessage(
        'يرجى اختيار نوع المساعدة الطبية',
      );
      return;
    }

    final String? arabicDetailsError = _validateArabicDetails(
      detailsAr,
    );

    if (arabicDetailsError != null) {
      _showValidationMessage(arabicDetailsError);
      return;
    }

    final String? englishDetailsError = _validateEnglishDetails(
      detailsEn,
    );

    if (englishDetailsError != null) {
      _showValidationMessage(englishDetailsError);
      return;
    }

    if (cost == null || cost <= 0) {
      _showValidationMessage(
        'يرجى إدخال تكلفة صحيحة',
      );
      return;
    }

    if (_attachments.isEmpty) {
      _showValidationMessage(
        'يرجى إرفاق تقرير أو وصفة طبية واحدة على الأقل',
      );
      return;
    }

    final HealthRequestModel request = HealthRequestModel(
      applicantInfo: widget.applicantInfo,
      typeAid: _selectedMedicalType!,
      detailsAr: detailsAr,
      detailsEn: detailsEn,
      cost: cost,
      media: List<PlatformFile>.unmodifiable(
        _attachments,
      ),
    );

    debugPrint('HealthRequestModel created successfully');
    debugPrint('Request typeAid: ${request.typeAid.apiValue}');
    debugPrint('Request detailsAr: ${request.detailsAr}');
    debugPrint('Request detailsEn: ${request.detailsEn}');
    debugPrint('Request cost: ${request.cost}');
    debugPrint('Request media count: ${request.media.length}');
    debugPrint('Calling HealthCubit.submitHealthRequest');

    final AppLocalizations localizations =
        AppLocalizations.of(context)!;

    context.read<HealthCubit>().submitHealthRequest(
          request,
          localizations,
        );

    debugPrint('======================================');
  }

  String? _validateArabicDetails(String value) {
    final String text = value.trim();

    if (text.isEmpty) {
      return 'يرجى إدخال تفاصيل الحالة الصحية باللغة العربية';
    }

    if (text.length < 5) {
      return 'يرجى كتابة تفاصيل أوضح باللغة العربية';
    }

    final bool hasArabic =
        RegExp(r'[\u0600-\u06FF]').hasMatch(text);

    final bool hasEnglish =
        RegExp(r'[A-Za-z]').hasMatch(text);

    if (!hasArabic) {
      return 'يجب أن تحتوي التفاصيل العربية على أحرف عربية';
    }

    if (hasEnglish) {
      return 'يرجى كتابة التفاصيل العربية دون أحرف إنكليزية';
    }

    return null;
  }

  String? _validateEnglishDetails(String value) {
    final String text = value.trim();

    if (text.isEmpty) {
      return 'Please enter the health details in English';
    }

    if (text.length < 5) {
      return 'Please provide clearer health details in English';
    }

    final bool hasEnglish =
        RegExp(r'[A-Za-z]').hasMatch(text);

    final bool hasArabic =
        RegExp(r'[\u0600-\u06FF]').hasMatch(text);

    if (!hasEnglish) {
      return 'The English details must contain English letters';
    }

    if (hasArabic) {
      return 'Please write the English details without Arabic letters';
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
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
            ),
          ),
        ),
      );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 4,
        bottom: 8,
      ),
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HealthCubit, HealthState>(
      listener: (context, state) async {
        debugPrint(
          'HealthRequestPage state: ${state.runtimeType}',
        );

        if (state is HealthSuccess) {
          await showRequestResultDialog(
            context: context,
            isSuccess: true,
            message: state.message,
            onSuccessConfirmed: () {
              if (!mounted) return;

              Navigator.of(context).popUntil(
                (Route<dynamic> route) => route.isFirst,
              );
            },
          );
        } else if (state is HealthFailure) {
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
        final bool isLoading = state is HealthLoading;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_forward,
                  color: AppColors.primary,
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.pop(context);
                      },
              ),
              title: const Text(
                'تفاصيل الطلب الصحي',
                style: TextStyle(
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
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomStepIndicator(
                      currentStep: 2,
                      totalSteps: 2,
                    ),
                    const SizedBox(height: 24),

                    _buildSectionLabel(
                      'نوع المساعدة الطبية المطلوبة',
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: HealthAidType.values.map(
                        (HealthAidType type) {
                          return SelectionChip(
                            label: type.arabicLabel,
                            isSelected:
                                _selectedMedicalType == type,
                            onTap: isLoading
                                ? () {}
                                : () {
                                    setState(() {
                                      _selectedMedicalType = type;
                                    });

                                    debugPrint(
                                      'Medical type selected: '
                                      '${type.apiValue}',
                                    );
                                  },
                          );
                        },
                      ).toList(),
                    ),

                    const SizedBox(height: 24),

                    CustomTextField(
                      label: 'تفاصيل الحالة الصحية (عربي)',
                      hint:
                          'يرجى ذكر التشخيص والأعراض باللغة العربية...',
                      controller: _detailsArController,
                      maxLines: 5,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      label: 'Health details (English)',
                      hint:
                          'Describe the diagnosis and symptoms in English...',
                      controller: _detailsEnController,
                      maxLines: 5,
                      isLtr: true,
                    ),

                    const SizedBox(height: 24),

                    CustomTextField(
                      label: 'التكلفة المالية المتوقعة للعلاج',
                      hint: '0.00',
                      controller: _costController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      isCurrency: true,
                    ),

                    const SizedBox(height: 24),

                    _buildSectionLabel(
                      'إرفاق التقارير الطبية والوصفات الرسمية',
                    ),

                    CustomAttachmentUploader(
                      title: 'رفع الملفات أو التقاط صور',
                      description:
                          'يرجى إرفاق صور واضحة للتقارير والوصفات الطبية',
                      icon: Icons.camera_alt_rounded,
                      onTap:
                          isLoading ? () {} : _pickAttachments,
                    ),

                    if (_attachments.isNotEmpty) ...[
                      const SizedBox(height: 12),

                      ..._attachments.asMap().entries.map(
                        (MapEntry<int, PlatformFile> entry) {
                          final PlatformFile file = entry.value;

                          return Card(
                            margin: const EdgeInsets.only(
                              bottom: 10,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(14),
                              side: BorderSide(
                                color: AppColors.brandGray
                                    .withOpacity(0.16),
                              ),
                            ),
                            child: ListTile(
                              dense: true,
                              leading: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryContainer
                                      .withOpacity(0.4),
                                  borderRadius:
                                      BorderRadius.circular(12),
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
                                  fontFamily:
                                      AppTextStyles.fontFamily,
                                ),
                              ),
                              subtitle: Text(
                                _getFileDescription(
                                  context,
                                  file,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily:
                                      AppTextStyles.fontFamily,
                                ),
                              ),
                              trailing: IconButton(
                                tooltip: 'حذف المرفق',
                                icon: const Icon(
                                  Icons.close,
                                  color: AppColors.error,
                                ),
                                onPressed: isLoading
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

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            bottomNavigationBar:
                _buildBottomSubmitButton(isLoading),
          ),
        );
      },
    );
  }

  String _getFileDescription(
    BuildContext context,
    PlatformFile file,
  ) {
    final String size = _formatFileSize(file.size);

    if (kIsWeb) {
      return '$size - ملف جاهز للرفع';
    }

    return '$size - ${file.path ?? ''}';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      final double kiloBytes = bytes / 1024;
      return '${kiloBytes.toStringAsFixed(1)} KB';
    }

    final double megaBytes = bytes / (1024 * 1024);
    return '${megaBytes.toStringAsFixed(1)} MB';
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
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          18,
          12,
          18,
          16,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.97),
          border: Border(
            top: BorderSide(
              color: AppColors.brandGray.withOpacity(0.12),
            ),
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
            disabledBackgroundColor:
                AppColors.primary.withOpacity(0.55),
            disabledForegroundColor: Colors.white,
            minimumSize: const Size(
              double.infinity,
              58,
            ),
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
              : const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      'إرسال الطلب للمراجعة',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily:
                            AppTextStyles.fontFamily,
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.send_rounded,
                      size: 19,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
