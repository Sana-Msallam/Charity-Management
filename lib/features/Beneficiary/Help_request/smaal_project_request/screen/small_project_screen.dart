import 'package:charity_management/features/Beneficiary/Help_request/applicantInfo/model/applicant_info_model.dart';
import 'package:charity_management/features/Beneficiary/Help_request/smaal_project_request/cubit/small_project_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/smaal_project_request/cubit/small_project_state.dart';
import 'package:charity_management/features/Beneficiary/Help_request/smaal_project_request/model/small_project_request_model.dart';
import 'package:charity_management/features/components/custom_attachment_uploader.dart';
import 'package:charity_management/features/components/custom_step_Indicator.dart';
import 'package:charity_management/features/components/request_result_dialog.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/widgets/custom_text_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SmallProjectRequestPage
    extends StatefulWidget {
  const SmallProjectRequestPage({
    super.key,
    required this.applicantInfo,
  });

  final ApplicantInfoModel applicantInfo;

  @override
  State<SmallProjectRequestPage> createState() {
    return _SmallProjectRequestPageState();
  }
}

class _SmallProjectRequestPageState
    extends State<SmallProjectRequestPage> {
  final TextEditingController
      _projectNameArController =
      TextEditingController();

  final TextEditingController
      _projectNameEnController =
      TextEditingController();

  final TextEditingController
      _projectCategoryArController =
      TextEditingController();

  final TextEditingController
      _projectCategoryEnController =
      TextEditingController();

  final TextEditingController
      _numberOfPeopleController =
      TextEditingController();

  final TextEditingController
      _detailsArController =
      TextEditingController();

  final TextEditingController
      _detailsEnController =
      TextEditingController();

  final TextEditingController
      _costController =
      TextEditingController();

  final List<PlatformFile> _attachments = [];

  @override
  void initState() {
    super.initState();

    debugPrint('======================================');
    debugPrint('SmallProjectRequestPage opened');
    debugPrint(
      'Applicant firstName: ${widget.applicantInfo.firstName}',
    );
    debugPrint(
      'Applicant lastName: ${widget.applicantInfo.lastName}',
    );
    debugPrint('======================================');
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

    debugPrint(
      'SmallProjectRequestPage disposed',
    );

    super.dispose();
  }

  Future<void> _pickAttachments() async {
    debugPrint('======================================');
    debugPrint(
      'Small project attachment picker opened',
    );

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
        debugPrint(
          'Small project attachment selection cancelled',
        );
        return;
      }

      if (!mounted) {
        return;
      }

      final List<PlatformFile> validFiles = [];

      for (final PlatformFile file
          in result.files) {
        final bool alreadyExists =
            _attachments.any(
          (PlatformFile oldFile) {
            return oldFile.name == file.name &&
                oldFile.size == file.size;
          },
        );

        if (alreadyExists) {
          continue;
        }

        if (kIsWeb) {
          if (file.bytes == null ||
              file.bytes!.isEmpty) {
            continue;
          }
        } else {
          if (file.path == null ||
              file.path!.trim().isEmpty) {
            continue;
          }
        }

        validFiles.add(file);
      }

      if (validFiles.isEmpty) {
        _showValidationMessage(
          'الملفات المحددة مضافة مسبقاً أو تعذر الوصول إليها',
        );
        return;
      }

      setState(() {
        _attachments.addAll(validFiles);
      });

      debugPrint(
        'Small project files added: ${validFiles.length}',
      );
      debugPrint(
        'Total attachments: ${_attachments.length}',
      );
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'Small project attachment error: $error',
      );
      debugPrint(
        'Stack trace: $stackTrace',
      );

      if (mounted) {
        _showValidationMessage(
          'تعذر اختيار الملفات، يرجى المحاولة مجدداً',
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

    final PlatformFile removed =
        _attachments[index];

    setState(() {
      _attachments.removeAt(index);
    });

    debugPrint(
      'Small project attachment removed: ${removed.name}',
    );
  }

  void _submit() {
    debugPrint('======================================');
    debugPrint(
      'Small project submit clicked',
    );

    FocusScope.of(context).unfocus();

    final String projectNameAr =
        _projectNameArController.text.trim();

    final String projectNameEn =
        _projectNameEnController.text.trim();

    final String projectCategoryAr =
        _projectCategoryArController.text.trim();

    final String projectCategoryEn =
        _projectCategoryEnController.text.trim();

    final int? numberOfPeople =
        int.tryParse(
      _numberOfPeopleController.text.trim(),
    );

    final String detailsAr =
        _detailsArController.text.trim();

    final String detailsEn =
        _detailsEnController.text.trim();

    final double? cost =
        double.tryParse(
      _costController.text
          .trim()
          .replaceAll(',', '.'),
    );

    debugPrint(
      'projectNameAr: $projectNameAr',
    );
    debugPrint(
      'projectNameEn: $projectNameEn',
    );
    debugPrint(
      'projectCategoryAr: $projectCategoryAr',
    );
    debugPrint(
      'projectCategoryEn: $projectCategoryEn',
    );
    debugPrint(
      'numberOfPeopleSupported: $numberOfPeople',
    );
    debugPrint(
      'detailsAr length: ${detailsAr.length}',
    );
    debugPrint(
      'detailsEn length: ${detailsEn.length}',
    );
    debugPrint(
      'cost: $cost',
    );
    debugPrint(
      'attachments count: ${_attachments.length}',
    );

    final String? projectNameArError =
        _validateArabicField(
      projectNameAr,
      emptyMessage:
          'يرجى إدخال اسم المشروع باللغة العربية',
      shortMessage:
          'اسم المشروع باللغة العربية قصير جداً',
    );

    if (projectNameArError != null) {
      _showValidationMessage(
        projectNameArError,
      );
      return;
    }

    final String? projectNameEnError =
        _validateEnglishField(
      projectNameEn,
      emptyMessage:
          'Please enter the project name in English',
      shortMessage:
          'The English project name is too short',
    );

    if (projectNameEnError != null) {
      _showValidationMessage(
        projectNameEnError,
      );
      return;
    }

    final String? projectCategoryArError =
        _validateArabicField(
      projectCategoryAr,
      emptyMessage:
          'يرجى إدخال تصنيف المشروع باللغة العربية',
      shortMessage:
          'تصنيف المشروع باللغة العربية قصير جداً',
    );

    if (projectCategoryArError != null) {
      _showValidationMessage(
        projectCategoryArError,
      );
      return;
    }

    final String? projectCategoryEnError =
        _validateEnglishField(
      projectCategoryEn,
      emptyMessage:
          'Please enter the project category in English',
      shortMessage:
          'The English project category is too short',
    );

    if (projectCategoryEnError != null) {
      _showValidationMessage(
        projectCategoryEnError,
      );
      return;
    }

    if (numberOfPeople == null ||
        numberOfPeople <= 0) {
      _showValidationMessage(
        'يرجى إدخال عدد صحيح للأشخاص المستفيدين',
      );
      return;
    }

    final String? detailsArError =
        _validateArabicField(
      detailsAr,
      emptyMessage:
          'يرجى إدخال تفاصيل المشروع باللغة العربية',
      shortMessage:
          'يرجى كتابة تفاصيل أوضح باللغة العربية',
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
      emptyMessage:
          'Please enter the project details in English',
      shortMessage:
          'Please provide clearer project details in English',
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

    final SmallProjectRequestModel request =
        SmallProjectRequestModel(
      applicantInfo:
          widget.applicantInfo,
      projectNameAr:
          projectNameAr,
      projectNameEn:
          projectNameEn,
      projectCategoryAr:
          projectCategoryAr,
      projectCategoryEn:
          projectCategoryEn,
      numberOfPeopleSupported:
          numberOfPeople,
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

    context
        .read<SmallProjectCubit>()
        .submitSmallProjectRequest(
      request,
    );
  }

  String? _validateArabicField(
    String value, {
    required String emptyMessage,
    required String shortMessage,
    int minimumLength = 2,
  }) {
    final String text = value.trim();

    if (text.isEmpty) {
      return emptyMessage;
    }

    if (text.length < minimumLength) {
      return shortMessage;
    }

    final bool hasArabic =
        RegExp(r'[\u0600-\u06FF]').hasMatch(text);

    final bool hasEnglish =
        RegExp(r'[A-Za-z]').hasMatch(text);

    if (!hasArabic) {
      return 'يجب أن يحتوي الحقل العربي على أحرف عربية';
    }

    if (hasEnglish) {
      return 'يرجى كتابة الحقل العربي دون أحرف إنكليزية';
    }

    return null;
  }

  String? _validateEnglishField(
    String value, {
    required String emptyMessage,
    required String shortMessage,
    int minimumLength = 2,
  }) {
    final String text = value.trim();

    if (text.isEmpty) {
      return emptyMessage;
    }

    if (text.length < minimumLength) {
      return shortMessage;
    }

    final bool hasEnglish =
        RegExp(r'[A-Za-z]').hasMatch(text);

    final bool hasArabic =
        RegExp(r'[\u0600-\u06FF]').hasMatch(text);

    if (!hasEnglish) {
      return 'The English field must contain English letters';
    }

    if (hasArabic) {
      return 'Please write the English field without Arabic letters';
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
              const EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
          content: Text(
            message,
            textDirection:
                TextDirection.rtl,
            style: const TextStyle(
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
          fontFamily:
              AppTextStyles.fontFamily,
        ),
      ),
    );
  }

  Widget _buildAttachmentsList(
    bool isLoading,
  ) {
    if (_attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 12),

        ..._attachments
            .asMap()
            .entries
            .map(
          (
            MapEntry<int, PlatformFile> entry,
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
                  _getFileDescription(file),
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
    );
  }

  Widget _buildDecorativeCard() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer
            .withOpacity(
          0.35,
        ),
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary
              .withOpacity(
            0.12,
          ),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.rocket_launch_outlined,
            size: 52,
            color: AppColors.primary,
          ),
          SizedBox(height: 12),
          Text(
            'نسعى لدعم المشاريع الصغيرة لتوفير دخل مستدام للأسر',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primary,
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

  @override
  Widget build(
    BuildContext context,
  ) {
    return BlocConsumer<
        SmallProjectCubit,
        SmallProjectState>(
      listener: (
        context,
        state,
      ) async {
        debugPrint(
          'SmallProjectRequestPage listener state: '
          '${state.runtimeType}',
        );

        if (state
            is SmallProjectSuccess) {
          await showRequestResultDialog(
            context: context,
            isSuccess: true,
            message: state.message,
            onSuccessConfirmed: () {
              if (!mounted) {
                return;
              }

              Navigator.of(context).popUntil(
                (Route<dynamic> route) {
                  return route.isFirst;
                },
              );
            },
          );
        } else if (state
            is SmallProjectFailure) {
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
            state is SmallProjectLoading;

        return Directionality(
          textDirection:
              TextDirection.rtl,
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
              title: const Text(
                'تفاصيل المشروع الصغير',
                style: TextStyle(
                  color:
                      AppColors.primary,
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                  fontFamily:
                      AppTextStyles
                          .fontFamily,
                ),
              ),
            ),
            body: SafeArea(
              child:
                  SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior
                        .onDrag,
                padding:
                    const EdgeInsets.fromLTRB(
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

                    const SizedBox(height: 24),

                    _buildSectionLabel(
                      'معلومات المشروع',
                    ),

                    CustomTextField(
                      label:
                          'اسم المشروع (عربي)',
                      hint:
                          'مثال: مخبز منزلي',
                      controller:
                          _projectNameArController,
                      suffixIcon:
                          Icons.storefront_outlined,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      label:
                          'Project name (English)',
                      hint:
                          'Example: Home bakery',
                      controller:
                          _projectNameEnController,
                      suffixIcon:
                          Icons.storefront_outlined,
                      isLtr: true,
                    ),

                    const SizedBox(height: 20),

                    CustomTextField(
                      label:
                          'تصنيف المشروع (عربي)',
                      hint:
                          'مثال: إنتاج غذائي',
                      controller:
                          _projectCategoryArController,
                      suffixIcon:
                          Icons.category_outlined,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      label:
                          'Project category (English)',
                      hint:
                          'Example: Food production',
                      controller:
                          _projectCategoryEnController,
                      suffixIcon:
                          Icons.category_outlined,
                      isLtr: true,
                    ),

                    const SizedBox(height: 20),

                    CustomTextField(
                      label:
                          'عدد الأشخاص المتوقع دعمهم',
                      hint: 'مثال: 3',
                      controller:
                          _numberOfPeopleController,
                      keyboardType:
                          TextInputType.number,
                      suffixIcon:
                          Icons.groups_outlined,
                      isLtr: true,
                    ),

                    const SizedBox(height: 24),

                    CustomTextField(
                      label:
                          'تفاصيل المشروع (عربي)',
                      hint:
                          'اشرح فكرة المشروع، أهدافه، وخطة الاستفادة منه باللغة العربية...',
                      controller:
                          _detailsArController,
                      maxLines: 5,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      label:
                          'Project details (English)',
                      hint:
                          'Explain the project idea, goals, and expected benefit in English...',
                      controller:
                          _detailsEnController,
                      maxLines: 5,
                      isLtr: true,
                    ),

                    const SizedBox(height: 24),

                    CustomTextField(
                      label:
                          'التكلفة المالية المتوقعة',
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
                      'إرفاق الوثائق الثبوتية',
                    ),

                    CustomAttachmentUploader(
                      title:
                          'رفع الملفات أو التقاط صور',
                      description:
                          'دراسة جدوى، صور، فواتير أو وثائق تدعم المشروع',
                      icon:
                          Icons.upload_file_rounded,
                      onTap: isLoading
                          ? () {}
                          : _pickAttachments,
                    ),

                    _buildAttachmentsList(
                      isLoading,
                    ),

                    const SizedBox(height: 28),

                    _buildDecorativeCard(),
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

  String _getFileDescription(
    PlatformFile file,
  ) {
    final String size =
        _formatFileSize(
      file.size,
    );

    if (kIsWeb) {
      return '$size - ملف جاهز للرفع';
    }

    return '$size - ${file.path ?? ''}';
  }

  String _formatFileSize(
    int bytes,
  ) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }

    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
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
              isLoading ? null : _submit,
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
