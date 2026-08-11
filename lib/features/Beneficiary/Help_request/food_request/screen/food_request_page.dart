import 'package:charity_management/features/Beneficiary/Help_request/applicantInfo/model/applicant_info_model.dart';
import 'package:charity_management/features/Beneficiary/Help_request/food_request/cubit/food_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/food_request/cubit/food_state.dart';
import 'package:charity_management/features/Beneficiary/Help_request/food_request/model/food_aid_type.dart';
import 'package:charity_management/features/Beneficiary/Help_request/food_request/model/food_request_model.dart';
import 'package:charity_management/features/components/custom_attachment_uploader.dart';
import 'package:charity_management/features/components/custom_step_Indicator.dart';
import 'package:charity_management/features/components/request_result_dialog.dart';
import 'package:charity_management/features/components/selection_chip.dart';
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
  });

  final ApplicantInfoModel applicantInfo;

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

  final List<PlatformFile> _attachments = [];

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
    debugPrint('======================================');
  }

  @override
  void dispose() {
    _detailsArController.dispose();
    _detailsEnController.dispose();
    _costController.dispose();

    debugPrint('FoodRequestPage disposed');

    super.dispose();
  }

  Future<void> _pickAttachments() async {
    debugPrint('======================================');
    debugPrint('Food attachment picker opened');

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
          'Food attachment selection cancelled',
        );
        debugPrint('======================================');
        return;
      }

      if (!mounted) {
        debugPrint(
          'Widget is not mounted after file selection',
        );
        return;
      }

      debugPrint(
        'Selected files count: ${result.files.length}',
      );

      for (final PlatformFile file in result.files) {
        debugPrint('Selected food attachment:');
        debugPrint('Name: ${file.name}');
        debugPrint('Path: ${file.path}');
        debugPrint('Size: ${file.size} bytes');
        debugPrint('Extension: ${file.extension}');
        debugPrint(
          'Bytes available: ${file.bytes != null}',
        );
      }

      final List<PlatformFile> selectedFiles =
          result.files.where(
        (PlatformFile newFile) {
          final bool alreadyExists =
              _attachments.any(
            (PlatformFile existingFile) {
              return existingFile.name == newFile.name &&
                  existingFile.size == newFile.size;
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
          'الملفات المحددة مضافة مسبقاً',
        );

        return;
      }

      final List<PlatformFile> validFiles = [];

      for (final PlatformFile file in selectedFiles) {
        if (kIsWeb) {
          if (file.bytes == null ||
              file.bytes!.isEmpty) {
            debugPrint(
              'Web food file bytes are missing: ${file.name}',
            );
            continue;
          }
        } else {
          if (file.path == null ||
              file.path!.trim().isEmpty) {
            debugPrint(
              'Mobile food file path is missing: ${file.name}',
            );
            continue;
          }
        }

        validFiles.add(file);
      }

      if (validFiles.isEmpty) {
        debugPrint(
          'No valid food files were found',
        );

        _showValidationMessage(
          'تعذر الوصول إلى الملفات المحددة',
        );

        return;
      }

      setState(() {
        _attachments.addAll(validFiles);
      });

      debugPrint(
        'Food files added successfully: ${validFiles.length}',
      );
      debugPrint(
        'Total food attachments: ${_attachments.length}',
      );
      debugPrint('======================================');
    } catch (error, stackTrace) {
      debugPrint(
        'Food attachment picker error',
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
        'Invalid food attachment index: $index',
      );
      return;
    }

    final PlatformFile removedFile =
        _attachments[index];

    setState(() {
      _attachments.removeAt(index);
    });

    debugPrint(
      'Food attachment removed: ${removedFile.name}',
    );
    debugPrint(
      'Remaining food attachments: ${_attachments.length}',
    );
  }

  void _incrementIndividuals() {
    setState(() {
      _numberIndividuals++;
    });

    debugPrint(
      'Number individuals increased: $_numberIndividuals',
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
      'Number individuals decreased: $_numberIndividuals',
    );
  }

  void _submit() {
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
        costText.replaceAll(',', '.');

    final double? cost = double.tryParse(
      normalizedCostText,
    );

    debugPrint(
      'Selected food aid label: '
      '${_selectedFoodAidType?.arabicLabel}',
    );
    debugPrint(
      'Selected food aid API value: '
      '${_selectedFoodAidType?.apiValue}',
    );
    debugPrint(
      'Number individuals: $_numberIndividuals',
    );
    debugPrint(
      'Arabic details length: ${detailsAr.length}',
    );
    debugPrint(
      'English details length: ${detailsEn.length}',
    );
    debugPrint(
      'Raw cost: $costText',
    );
    debugPrint(
      'Normalized cost: $normalizedCostText',
    );
    debugPrint(
      'Parsed cost: $cost',
    );
    debugPrint(
      'Attachments count: ${_attachments.length}',
    );

    if (_selectedFoodAidType == null) {
      debugPrint(
        'Validation failed: Food aid type is missing',
      );

      _showValidationMessage(
        'يرجى اختيار نوع المساعدة الغذائية',
      );

      return;
    }

    if (_numberIndividuals <= 0) {
      debugPrint(
        'Validation failed: Invalid number individuals',
      );

      _showValidationMessage(
        'يرجى إدخال عدد أفراد صحيح',
      );

      return;
    }

    final String? arabicDetailsError =
        _validateArabicDetails(detailsAr);

    if (arabicDetailsError != null) {
      debugPrint(
        'Validation failed: $arabicDetailsError',
      );

      _showValidationMessage(
        arabicDetailsError,
      );

      return;
    }

    final String? englishDetailsError =
        _validateEnglishDetails(detailsEn);

    if (englishDetailsError != null) {
      debugPrint(
        'Validation failed: $englishDetailsError',
      );

      _showValidationMessage(
        englishDetailsError,
      );

      return;
    }

    if (cost == null || cost <= 0) {
      debugPrint(
        'Validation failed: Invalid cost',
      );

      _showValidationMessage(
        'يرجى إدخال تكلفة صحيحة',
      );

      return;
    }

    if (_attachments.isEmpty) {
      debugPrint(
        'Validation failed: No attachments',
      );

      _showValidationMessage(
        'يرجى إرفاق وثيقة واحدة على الأقل',
      );

      return;
    }

    final FoodRequestModel request =
        FoodRequestModel(
      applicantInfo: widget.applicantInfo,
      typeAid: _selectedFoodAidType!,
      numberIndividuals: _numberIndividuals,
      detailsAr: detailsAr,
      detailsEn: detailsEn,
      cost: cost,
      media: List<PlatformFile>.unmodifiable(
        _attachments,
      ),
    );

    debugPrint(
      'FoodRequestModel created successfully',
    );
    debugPrint(
      'Request first name: ${request.applicantInfo.firstName}',
    );
    debugPrint(
      'Request father name: ${request.applicantInfo.fatherName}',
    );
    debugPrint(
      'Request last name: ${request.applicantInfo.lastName}',
    );
    debugPrint(
      'Request typeAid: ${request.typeAid.apiValue}',
    );
    debugPrint(
      'Request numberIndividuals: ${request.numberIndividuals}',
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
      'Request media count: ${request.media.length}',
    );

    for (final PlatformFile file
        in request.media) {
      debugPrint(
        'Request food attachment name: ${file.name}',
      );
      debugPrint(
        'Request food attachment path: ${file.path}',
      );
      debugPrint(
        'Request food attachment bytes available: '
        '${file.bytes != null}',
      );
    }

    debugPrint(
      'Calling FoodCubit.submitFoodRequest',
    );
    debugPrint('======================================');

    context
        .read<FoodCubit>()
        .submitFoodRequest(request);
  }

  String? _validateArabicDetails(
    String value,
  ) {
    final String text = value.trim();

    if (text.isEmpty) {
      return 'يرجى إدخال تفاصيل الطلب باللغة العربية';
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

  String? _validateEnglishDetails(
    String value,
  ) {
    final String text = value.trim();

    if (text.isEmpty) {
      return 'Please enter the request details in English';
    }

    if (text.length < 5) {
      return 'Please provide clearer details in English';
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

  void _showValidationMessage(
    String message,
  ) {
    if (!mounted) {
      debugPrint(
        'Cannot show SnackBar: widget is not mounted',
      );
      return;
    }

    debugPrint(
      'Showing food validation SnackBar: $message',
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
              margin: const EdgeInsets.only(
                bottom: 10,
              ),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(14),
                side: BorderSide(
                  color: AppColors.brandGray
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
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer
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
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  file.name,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.w600,
                    fontFamily:
                        AppTextStyles.fontFamily,
                  ),
                ),
                subtitle: Text(
                  _getFileDescription(file),
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
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
    );
  }

  Widget _buildDecorativeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color:
            AppColors.primaryContainer.withOpacity(
          0.35,
        ),
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withOpacity(
            0.12,
          ),
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.volunteer_activism_outlined,
            size: 52,
            color: AppColors.primary,
          ),
          SizedBox(height: 12),
          Text(
            'معاً نساهم في توفير الغذاء لكل أسرة محتاجة',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily:
                  AppTextStyles.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
        FoodCubit,
        FoodState>(
      listener: (context, state) async {
        debugPrint(
          'FoodRequestPage listener state: '
          '${state.runtimeType}',
        );

        if (state is FoodSuccess) {
          debugPrint(
            'Food request succeeded',
          );
          debugPrint(
            'Success message: ${state.message}',
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
        } else if (state is FoodFailure) {
          debugPrint(
            'Food request failed',
          );
          debugPrint(
            'Failure message: ${state.message}',
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
            state is FoodLoading;

        debugPrint(
          'FoodRequestPage builder state: '
          '${state.runtimeType}',
        );
        debugPrint(
          'FoodRequestPage isLoading: $isLoading',
        );

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
                  color: AppColors.primary,
                ),
                onPressed: isLoading
                    ? null
                    : () {
                        debugPrint(
                          'Food page back button pressed',
                        );
                        Navigator.pop(context);
                      },
              ),
              title: const Text(
                'تفاصيل الطلب الغذائي',
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
                      'نوع المساعدة الغذائية المطلوبة',
                    ),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          FoodAidType.values.map(
                        (FoodAidType type) {
                          return SelectionChip(
                            label:
                                type.arabicLabel,
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
                                      'Arabic label: '
                                      '${type.arabicLabel}',
                                    );
                                    debugPrint(
                                      'API value: '
                                      '${type.apiValue}',
                                    );

                                    setState(() {
                                      _selectedFoodAidType =
                                          type;
                                    });
                                  },
                          );
                        },
                      ).toList(),
                    ),

                    const SizedBox(height: 24),

                    BeneficiariesCounter(
                      count:
                          _numberIndividuals,
                      onIncrement: isLoading
                          ? () {}
                          : _incrementIndividuals,
                      onDecrement: isLoading
                          ? () {}
                          : _decrementIndividuals,
                    ),

                    const SizedBox(height: 24),

                    CustomTextField(
                      label:
                          'تفاصيل الحالة والاحتياج الغذائي (عربي)',
                      hint:
                          'اشرح نوع الاحتياج والظروف الحالية للأسرة باللغة العربية...',
                      controller:
                          _detailsArController,
                      maxLines: 5,
                    ),

                    const SizedBox(height: 16),

                    CustomTextField(
                      label:
                          'Food request details (English)',
                      hint:
                          'Explain the family situation and food needs in English...',
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
                          'يرجى إرفاق أي وثائق تدعم الطلب الغذائي',
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
    final String formattedSize =
        _formatFileSize(
      file.size,
    );

    if (kIsWeb) {
      return '$formattedSize - ملف جاهز للرفع';
    }

    return '$formattedSize - ${file.path ?? ''}';
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      final double kilobytes =
          bytes / 1024;

      return '${kilobytes.toStringAsFixed(1)} KB';
    }

    final double megabytes =
        bytes / (1024 * 1024);

    return '${megabytes.toStringAsFixed(1)} MB';
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
          color: Colors.white.withOpacity(
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
