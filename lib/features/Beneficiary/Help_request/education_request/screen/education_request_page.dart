import 'package:charity_management/features/Beneficiary/Help_request/applicantInfo/model/applicant_info_model.dart';
import 'package:charity_management/features/Beneficiary/Help_request/education_request/cubit/education_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/education_request/cubit/education_state.dart';
import 'package:charity_management/features/Beneficiary/Help_request/education_request/model/academic_achievement.dart';
import 'package:charity_management/features/Beneficiary/Help_request/education_request/model/education_request_model.dart';
import 'package:charity_management/features/components/custom_attachment_uploader.dart';
import 'package:charity_management/features/components/education_components.dart';
import 'package:charity_management/features/components/request_result_dialog.dart';
import 'package:charity_management/features/components/selection_chip.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';

// استيراد المكونات الموحدة والمخصصة
import 'package:charity_management/widgets/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EducationRequestPage extends StatefulWidget {
  const EducationRequestPage({
    super.key,
    required this.applicantInfo,
  });

  final ApplicantInfoModel applicantInfo;

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
  final List<String> _yearOptions = [
    'المرحلة الابتدائية',
    'المرحلة المتوسطة',
    'المرحلة الثانوية',
    'سنة أولى جامعي',
    'سنة ثانية جامعي',
    'سنة ثالثة جامعي',
    'سنة رابعة جامعي',
    'سنة خامسة جامعي',
    'سنة سادسة جامعي',
  ];

  final List<PlatformFile> _attachments = [];

  @override
  void initState() {
    super.initState();

    debugPrint('======================================');
    debugPrint('EducationRequestPage opened');
    debugPrint('Applicant data received:');
    debugPrint('First name: ${widget.applicantInfo.firstName}');
    debugPrint('Father name: ${widget.applicantInfo.fatherName}');
    debugPrint('Last name: ${widget.applicantInfo.lastName}');
    debugPrint('Age: ${widget.applicantInfo.age}');
    debugPrint('Gender: ${widget.applicantInfo.gender}');
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
    debugPrint('======================================');
  }

  @override
  void dispose() {
    _institutionNameArController.dispose();
    _institutionNameEnController.dispose();
    _detailsArController.dispose();
    _detailsEnController.dispose();
    _costController.dispose();

    debugPrint('EducationRequestPage disposed');

    super.dispose();
  }

  Future<void> _pickAttachments() async {
    debugPrint('======================================');
    debugPrint('Education attachment picker opened');

    try {
      final FilePickerResult? result =
          await FilePicker.platform.pickFiles(
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
        debugPrint(
          'Widget is not mounted after file selection',
        );
        return;
      }

      final List<PlatformFile> selectedFiles =
          result.files.where(
        (PlatformFile newFile) {
          final bool alreadyExists =
              _attachments.any(
            (PlatformFile oldFile) {
              return oldFile.name == newFile.name &&
                  oldFile.size == newFile.size;
            },
          );

          return !alreadyExists;
        },
      ).toList();

      if (selectedFiles.isEmpty) {
        _showValidationMessage(
          'الملفات المحددة مضافة مسبقاً',
        );
        return;
      }

      final List<PlatformFile> validFiles = [];

      for (final PlatformFile file in selectedFiles) {
        debugPrint('Selected file: ${file.name}');
        debugPrint('Path: ${file.path}');
        debugPrint('Size: ${file.size}');
        debugPrint('Extension: ${file.extension}');
        debugPrint(
          'Bytes available: ${file.bytes != null}',
        );

        if (kIsWeb) {
          if (file.bytes == null ||
              file.bytes!.isEmpty) {
            debugPrint(
              'Web file bytes missing: ${file.name}',
            );
            continue;
          }
        } else {
          if (file.path == null ||
              file.path!.trim().isEmpty) {
            debugPrint(
              'Mobile file path missing: ${file.name}',
            );
            continue;
          }
        }

        validFiles.add(file);
      }

      if (validFiles.isEmpty) {
        _showValidationMessage(
          'تعذر الوصول إلى الملفات المحددة',
        );
        return;
      }

      setState(() {
        _attachments.addAll(validFiles);
      });

      debugPrint('Files added: ${validFiles.length}');
      debugPrint(
        'Total attachments: ${_attachments.length}',
      );
      debugPrint('======================================');
    } catch (error, stackTrace) {
      debugPrint(
        'Education attachment picker error',
      );
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
      _attachments.removeAt(index);
    });

    debugPrint(
      'Attachment removed: ${removedFile.name}',
    );
    debugPrint(
      'Remaining attachments: ${_attachments.length}',
    );
  }

  void _submit() {
    debugPrint('======================================');
    debugPrint(
      'EducationRequestPage: Submit clicked',
    );

    FocusScope.of(context).unfocus();

    final String institutionNameAr =
        _institutionNameArController.text.trim();

    final String institutionNameEn =
        _institutionNameEnController.text.trim();

    final String detailsAr =
        _detailsArController.text.trim();

    final String detailsEn =
        _detailsEnController.text.trim();

    final String costText =
        _costController.text.trim();

    final double? cost = double.tryParse(
      costText.replaceAll(',', '.'),
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
    debugPrint('Selected year: $_selectedYear');
    debugPrint('Details AR: $detailsAr');
    debugPrint('Details EN: $detailsEn');
    debugPrint('Cost: $cost');
    debugPrint(
      'Attachments count: ${_attachments.length}',
    );

    if (_selectedAcademicAchievement == null) {
      _showValidationMessage(
        'يرجى اختيار التحصيل الدراسي',
      );
      return;
    }

    final String? institutionArError =
        _validateArabicField(
      institutionNameAr,
      'اسم المدرسة أو الجامعة',
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
      'School or university name',
    );

    if (institutionEnError != null) {
      _showValidationMessage(
        institutionEnError,
      );
      return;
    }

    if (_selectedYear == null ||
        _selectedYear!.trim().isEmpty) {
      _showValidationMessage(
        'يرجى اختيار الصف أو السنة الدراسية',
      );
      return;
    }

    final String? detailsArError =
        _validateArabicField(
      detailsAr,
      'تفاصيل الحالة التعليمية',
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
      'Education request details',
      minimumLength: 5,
    );

    if (detailsEnError != null) {
      _showValidationMessage(
        detailsEnError,
      );
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
        'يرجى إرفاق وثيقة واحدة على الأقل',
      );
      return;
    }

    final EducationRequestModel request =
        EducationRequestModel(
      applicantInfo: widget.applicantInfo,
      academicAchievement:
          _selectedAcademicAchievement!,
      institutionNameAr: institutionNameAr,
      institutionNameEn: institutionNameEn,
      year: _selectedYear!,
      detailsAr: detailsAr,
      detailsEn: detailsEn,
      cost: cost,
      media:
          List<PlatformFile>.unmodifiable(
        _attachments,
      ),
    );

    debugPrint(
      'EducationRequestModel created successfully',
    );
    debugPrint(
      'Request firstName: ${request.applicantInfo.firstName}',
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
      'Request detailsAr: ${request.detailsAr}',
    );
    debugPrint(
      'Request detailsEn: ${request.detailsEn}',
    );
    debugPrint('Request year: ${request.year}');
    debugPrint('Request cost: ${request.cost}');
    debugPrint(
      'Request attachments: ${request.media.length}',
    );
    debugPrint(
      'Calling EducationCubit.submitEducationRequest',
    );
    debugPrint('======================================');

    context
        .read<EducationCubit>()
        .submitEducationRequest(request);
  }

  String? _validateArabicField(
    String value,
    String fieldName, {
    int minimumLength = 2,
  }) {
    final String text = value.trim();

    if (text.isEmpty) {
      return 'يرجى إدخال $fieldName باللغة العربية';
    }

    if (text.length < minimumLength) {
      return '$fieldName قصير جداً';
    }

    final bool hasArabic =
        RegExp(r'[\u0600-\u06FF]').hasMatch(text);

    final bool hasEnglish =
        RegExp(r'[A-Za-z]').hasMatch(text);

    if (!hasArabic || hasEnglish) {
      return 'يرجى كتابة $fieldName باللغة العربية فقط';
    }

    return null;
  }

  String? _validateEnglishField(
    String value,
    String fieldName, {
    int minimumLength = 2,
  }) {
    final String text = value.trim();

    if (text.isEmpty) {
      return 'Please enter $fieldName in English';
    }

    if (text.length < minimumLength) {
      return '$fieldName is too short';
    }

    final bool hasEnglish =
        RegExp(r'[A-Za-z]').hasMatch(text);

    final bool hasArabic =
        RegExp(r'[\u0600-\u06FF]').hasMatch(text);

    if (!hasEnglish || hasArabic) {
      return 'Please write $fieldName in English only';
    }

    return null;
  }

  void _showValidationMessage(
    String message,
  ) {
    if (!mounted) {
      debugPrint(
        'Cannot show message: widget is not mounted',
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
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
          content: Text(
            message,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily:
                  AppTextStyles.fontFamily,
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
          fontWeight: FontWeight.w600,
          fontFamily: AppTextStyles.fontFamily,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
        EducationCubit,
        EducationState>(
      listener: (context, state) async {
        debugPrint(
          'EducationRequestPage state: '
          '${state.runtimeType}',
        );

        if (state is EducationSuccess) {
          debugPrint(
            'Education request success: '
            '${state.message}',
          );

          await showRequestResultDialog(
            context: context,
            isSuccess: true,
            message: state.message,
            onSuccessConfirmed: () {
              if (!mounted) return;

              Navigator.of(context).popUntil(
                (Route<dynamic> route) {
                  return route.isFirst;
                },
              );
            },
          );
        } else if (state is EducationFailure) {
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
      builder: (context, state) {
        final bool isLoading =
            state is EducationLoading;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor:
                AppColors.background,
            appBar: AppBar(
              backgroundColor:
                  AppColors.background,
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
                'تفاصيل الطلب التعليمي',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily:
                      AppTextStyles.fontFamily,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior
                        .onDrag,
                padding:
                    const EdgeInsets.fromLTRB(
                  20,
                  24,
                  20,
                  110,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel(
                      'التحصيل الدراسي',
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
                                achievement
                                    .arabicLabel,
                            isSelected:
                                _selectedAcademicAchievement ==
                                    achievement,
                            onTap: isLoading
                                ? () {}
                                : () {
                                    setState(() {
                                      _selectedAcademicAchievement =
                                          achievement;
                                    });

                                    debugPrint(
                                      'Academic achievement selected: '
                                      '${achievement.apiValue}',
                                    );
                                  },
                          );
                        },
                      ).toList(),
                    ),

                    const SizedBox(height: 24),

                    CustomTextField(
                      label:
                          'اسم المدرسة / الجامعة (عربي)',
                      hint:
                          'مثال: جامعة دمشق',
                      controller:
                          _institutionNameArController,
                      suffixIcon:
                          Icons.school_outlined,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      label:
                          'School / University Name (English)',
                      hint:
                          'Example: Damascus University',
                      controller:
                          _institutionNameEnController,
                      suffixIcon:
                          Icons.school_outlined,
                      isLtr: true,
                    ),

                    const SizedBox(height: 24),

                    _buildSectionLabel(
                      'الصف / السنة الدراسية',
                    ),

                    _buildDropdownField(
                      isLoading,
                    ),

                    const SizedBox(height: 24),

                    CustomTextField(
                      label:
                          'تفاصيل الحالة التعليمية (عربي)',
                      hint:
                          'اشرح حاجتك التعليمية باللغة العربية...',
                      controller:
                          _detailsArController,
                      maxLines: 4,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      label:
                          'Education Request Details (English)',
                      hint:
                          'Explain the educational need in English...',
                      controller:
                          _detailsEnController,
                      maxLines: 4,
                      isLtr: true,
                    ),

                    const SizedBox(height: 24),

                    CustomTextField(
                      label:
                          'التكلفة الإجمالية المتوقعة',
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

                    const SizedBox(height: 24),

                    _buildSectionLabel(
                      'إرفاق الوثائق التعليمية',
                    ),

                    CustomAttachmentUploader(
                      title:
                          'رفع الملفات أو التقاط صور',
                      description:
                          'يرجى إرفاق صور واضحة للوثائق أو إثبات التسجيل',
                      icon:
                          Icons.upload_file_rounded,
                      onTap: isLoading
                          ? () {}
                          : _pickAttachments,
                    ),

                    if (_attachments.isNotEmpty) ...[
                      const SizedBox(height: 12),

                      ..._attachments
                          .asMap()
                          .entries
                          .map(
                        (
                          MapEntry<int,
                                  PlatformFile>
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
                                color: AppColors
                                    .brandGray
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
                                    TextOverflow
                                        .ellipsis,
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
                              trailing: IconButton(
                                tooltip:
                                    'حذف المرفق',
                                icon: const Icon(
                                  Icons.close,
                                  color:
                                      AppColors.error,
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

                    const EducationalDecorativeCard(),
                  ],
                ),
              ),
            ),
            bottomNavigationBar:
                _buildBottomSubmitButton(
              isLoading,
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdownField(
    bool isLoading,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
        border: Border.all(
          color:
              AppColors.brandGray.withOpacity(
            0.3,
          ),
          width: 1.2,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedYear,
          hint: Text(
            'اختر المرحلة...',
            style: TextStyle(
              color:
                  AppColors.brandGray.withOpacity(
                0.55,
              ),
              fontSize: 14,
              fontFamily:
                  AppTextStyles.fontFamily,
            ),
          ),
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.brandGray,
          ),
          items: _yearOptions.map(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontSize: 14,
                    fontFamily:
                        AppTextStyles.fontFamily,
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: isLoading
              ? null
              : (String? newValue) {
                  setState(() {
                    _selectedYear = newValue;
                  });
                },
        ),
      ),
    );
  }

  String _getFileDescription(
    PlatformFile file,
  ) {
    final String size =
        _formatFileSize(file.size);

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
      final double kiloBytes =
          bytes / 1024;

      return '${kiloBytes.toStringAsFixed(1)} KB';
    }

    final double megaBytes =
        bytes / (1024 * 1024);

    return '${megaBytes.toStringAsFixed(1)} MB';
  }

  IconData _getFileIcon(
    String? extension,
  ) {
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

  Widget _buildBottomSubmitButton(
    bool isLoading,
  ) {
    return SafeArea(
      child: Container(
        padding:
            const EdgeInsets.fromLTRB(
          18,
          12,
          18,
          16,
        ),
        decoration: BoxDecoration(
          color:
              Colors.white.withOpacity(
            0.97,
          ),
          border: Border(
            top: BorderSide(
              color: AppColors.brandGray
                  .withOpacity(
                0.12,
              ),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(
                0.04,
              ),
              blurRadius: 14,
              offset: const Offset(
                0,
                -4,
              ),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed:
              isLoading ? null : _submit,
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                AppColors.primary,
            foregroundColor:
                Colors.white,
            disabledBackgroundColor:
                AppColors.primary.withOpacity(
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
                        fontWeight:
                            FontWeight.bold,
                        fontFamily:
                            AppTextStyles
                                .fontFamily,
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
