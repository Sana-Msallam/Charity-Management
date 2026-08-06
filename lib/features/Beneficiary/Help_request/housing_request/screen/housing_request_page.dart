import 'package:charity_management/features/Beneficiary/Help_request/applicantInfo/model/applicant_info_model.dart';


import 'package:charity_management/features/Beneficiary/Help_request/housing_request/cubit/housing_cubit.dart';
import 'package:charity_management/features/Beneficiary/Help_request/housing_request/cubit/housing_state.dart';
import 'package:charity_management/features/Beneficiary/Help_request/housing_request/model/housing_request_model.dart';
import 'package:charity_management/features/Beneficiary/Help_request/housing_request/model/housing_sub_category.dart';
import 'package:charity_management/features/components/custom_attachment_uploader.dart';
import 'package:charity_management/features/components/custom_step_Indicator.dart';
import 'package:charity_management/features/components/request_result_dialog.dart';
import 'package:charity_management/features/components/selection_chip.dart';

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
  });

  final ApplicantInfoModel applicantInfo;

  @override
  State<HousingRequestPage> createState() {
    return _HousingRequestPageState();
  }
}

class _HousingRequestPageState
    extends State<HousingRequestPage> {
  /*
   * الحقول المشتركة:
   * details
   * cost
   * media
   */
  final TextEditingController _detailsArController =
      TextEditingController();

  final TextEditingController _detailsEnController =
      TextEditingController();

  final TextEditingController _costController =
      TextEditingController();

  final List<PlatformFile> _attachments = [];

  /*
   * subCategoryId = 1
   * تأمين منزل
   */
  final TextEditingController
      _currentPlaceOfResidenceController =
      TextEditingController();

  final TextEditingController
      _reasonForLockController =
      TextEditingController();

  final TextEditingController
      _housingSpecificationsController =
      TextEditingController();

  /*
   * subCategoryId = 2
   * مساعدة في إيجار البيت
   */
  final TextEditingController _currentRentController =
      TextEditingController();

  /*
   * subCategoryId = 3
   * إصلاحات منزلية
   */
  final TextEditingController
      _currentHousingSituationController =
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
      'Social status: '
      '${widget.applicantInfo.socialStatus}',
    );

    debugPrint(
      'Phone number: '
      '${widget.applicantInfo.phoneNumber}',
    );

    debugPrint(
      'Address AR: ${widget.applicantInfo.addressAr}',
    );

    debugPrint(
      'Address EN: ${widget.applicantInfo.addressEn}',
    );

    debugPrint(
      'Is unemployed: '
      '${widget.applicantInfo.isUnemployed}',
    );

    debugPrint('======================================');
  }

  @override
  void dispose() {
    _detailsArController.dispose();
    _detailsEnController.dispose();
    _costController.dispose();

    _currentPlaceOfResidenceController.dispose();
    _reasonForLockController.dispose();
    _housingSpecificationsController.dispose();

    _currentRentController.dispose();

    _currentHousingSituationController.dispose();

    debugPrint('HousingRequestPage disposed');

    super.dispose();
  }

  void _selectSubCategory(
    HousingSubCategory subCategory,
  ) {
    debugPrint('======================================');
    debugPrint('Housing subcategory selected');
    debugPrint(
      'Arabic label: ${subCategory.arabicLabel}',
    );
    debugPrint(
      'API id: ${subCategory.apiId}',
    );
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
          _currentHousingSituationController.clear();
          break;

        case HousingSubCategory.rentAssistance:
          _currentPlaceOfResidenceController.clear();
          _reasonForLockController.clear();
          _housingSpecificationsController.clear();
          _currentHousingSituationController.clear();
          break;

        case HousingSubCategory.homeRepairs:
          _currentPlaceOfResidenceController.clear();
          _reasonForLockController.clear();
          _housingSpecificationsController.clear();
          _currentRentController.clear();
          break;
      }
    });
  }

  Future<void> _pickAttachments() async {
    debugPrint('======================================');
    debugPrint('Housing attachment picker opened');

    try {
      final FilePickerResult? result =
          await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'pdf',
        ],

        /*
         * على Web نحتاج bytes.
         * على Android نستخدم path.
         */
        withData: kIsWeb,
      );

      if (result == null) {
        debugPrint(
          'Attachment selection cancelled',
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
        'Selected platform files count: '
        '${result.files.length}',
      );

      for (final PlatformFile file in result.files) {
        debugPrint('Selected file information:');
        debugPrint('Name: ${file.name}');
        debugPrint('Path: ${file.path}');
        debugPrint('Size: ${file.size} bytes');
        debugPrint(
          'Extension: ${file.extension}',
        );
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
          'All selected files already exist',
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
              'Web file bytes are missing: '
              '${file.name}',
            );

            continue;
          }
        } else {
          if (file.path == null ||
              file.path!.trim().isEmpty) {
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
        debugPrint(
          'No valid accessible files found',
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
        'Housing files added: '
        '${validFiles.length}',
      );

      debugPrint(
        'Total housing attachments: '
        '${_attachments.length}',
      );

      debugPrint('======================================');
    } catch (error, stackTrace) {
      debugPrint(
        'Housing attachment picker error',
      );

      debugPrint(
        'Error: $error',
      );

      debugPrint(
        'Stack trace: $stackTrace',
      );

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
      'Housing attachment removed: '
      '${removedFile.name}',
    );

    debugPrint(
      'Remaining attachments: '
      '${_attachments.length}',
    );
  }

  void _submit() {
    debugPrint('======================================');
    debugPrint(
      'HousingRequestPage: Submit clicked',
    );

    FocusScope.of(context).unfocus();

    if (_selectedSubCategory == null) {
      debugPrint(
        'Validation failed: '
        'Subcategory is missing',
      );

      _showValidationMessage(
        'يرجى اختيار نوع المساعدة السكنية',
      );

      return;
    }

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
      'Selected subcategory: '
      '${_selectedSubCategory!.arabicLabel}',
    );

    debugPrint(
      'Selected subcategory API id: '
      '${_selectedSubCategory!.apiId}',
    );

    debugPrint(
      'Details AR: $detailsAr',
    );

    debugPrint(
      'Details EN: $detailsEn',
    );

    debugPrint(
      'Raw cost: $costText',
    );

    debugPrint(
      'Parsed cost: $cost',
    );

    debugPrint(
      'Attachments count: '
      '${_attachments.length}',
    );

    /*
     * نتحقق أولًا من حقول الـ subCategory.
     */
    switch (_selectedSubCategory!) {
      case HousingSubCategory.homeProvision:
        final String currentPlace =
            _currentPlaceOfResidenceController
                .text
                .trim();

        final String reason =
            _reasonForLockController.text.trim();

        final String specifications =
            _housingSpecificationsController
                .text
                .trim();

        if (currentPlace.isEmpty) {
          _showValidationMessage(
            'يرجى إدخال مكان الإقامة الحالي',
          );

          return;
        }

        if (reason.isEmpty) {
          _showValidationMessage(
            'يرجى إدخال سبب طلب تأمين المنزل',
          );

          return;
        }

        if (specifications.isEmpty) {
          _showValidationMessage(
            'يرجى إدخال مواصفات المنزل المطلوب',
          );

          return;
        }

        break;

      case HousingSubCategory.rentAssistance:
        final String currentRentText =
            _currentRentController.text.trim();

        final double? currentRent =
            double.tryParse(
          currentRentText.replaceAll(',', '.'),
        );

        if (currentRent == null ||
            currentRent <= 0) {
          _showValidationMessage(
            'يرجى إدخال قيمة الإيجار الحالي بشكل صحيح',
          );

          return;
        }

        break;

      case HousingSubCategory.homeRepairs:
        final String housingSituation =
            _currentHousingSituationController
                .text
                .trim();

        if (housingSituation.isEmpty) {
          _showValidationMessage(
            'يرجى وصف حالة المنزل والإصلاحات المطلوبة',
          );

          return;
        }

        break;
    }

    /*
     * التحقق من الحقول المشتركة.
     */
    final String? arabicDetailsError =
        _validateArabicDetails(
      detailsAr,
    );

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
        _validateEnglishDetails(
      detailsEn,
    );

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

    double? currentRent;

    if (_selectedSubCategory ==
        HousingSubCategory.rentAssistance) {
      currentRent = double.tryParse(
        _currentRentController.text
            .trim()
            .replaceAll(',', '.'),
      );
    }

    final HousingRequestModel request =
        HousingRequestModel(
      applicantInfo: widget.applicantInfo,

      subCategory: _selectedSubCategory!,

      detailsAr: detailsAr,

      detailsEn: detailsEn,

      cost: cost,

      media: List<PlatformFile>.unmodifiable(
        _attachments,
      ),

      /*
       * حقول subCategoryId = 1
       */
      currentPlaceOfResidence:
          _selectedSubCategory ==
                  HousingSubCategory.homeProvision
              ? _currentPlaceOfResidenceController
                  .text
                  .trim()
              : null,

      reasonForLock:
          _selectedSubCategory ==
                  HousingSubCategory.homeProvision
              ? _reasonForLockController.text.trim()
              : null,

      housingSpecifications:
          _selectedSubCategory ==
                  HousingSubCategory.homeProvision
              ? _housingSpecificationsController
                  .text
                  .trim()
              : null,

      /*
       * حقل subCategoryId = 2
       */
      currentRent:
          _selectedSubCategory ==
                  HousingSubCategory.rentAssistance
              ? currentRent
              : null,

      /*
       * حقل subCategoryId = 3
       */
      currentHousingSituation:
          _selectedSubCategory ==
                  HousingSubCategory.homeRepairs
              ? _currentHousingSituationController
                  .text
                  .trim()
              : null,
    );

    debugPrint(
      'HousingRequestModel created successfully',
    );

    debugPrint(
      'Request subCategoryId: '
      '${request.subCategory.apiId}',
    );

    debugPrint(
      'Request details AR: ${request.detailsAr}',
    );

    debugPrint(
      'Request details EN: ${request.detailsEn}',
    );

    debugPrint(
      'Request cost: ${request.cost}',
    );

    debugPrint(
      'Request currentPlaceOfResidence: '
      '${request.currentPlaceOfResidence}',
    );

    debugPrint(
      'Request reasonForLock: '
      '${request.reasonForLock}',
    );

    debugPrint(
      'Request housingSpecifications: '
      '${request.housingSpecifications}',
    );

    debugPrint(
      'Request currentRent: '
      '${request.currentRent}',
    );

    debugPrint(
      'Request currentHousingSituation: '
      '${request.currentHousingSituation}',
    );

    debugPrint(
      'Request media count: '
      '${request.media.length}',
    );

    for (final PlatformFile file
        in request.media) {
      debugPrint(
        'Request attachment: ${file.name}',
      );
    }

    debugPrint(
      'Calling HousingCubit.submitHousingRequest',
    );

    debugPrint('======================================');

    context
        .read<HousingCubit>()
        .submitHousingRequest(request);
  }

  String? _validateArabicDetails(
    String value,
  ) {
    final String text = value.trim();

    if (text.isEmpty) {
      return 'يرجى إدخال تفاصيل الطلب السكني باللغة العربية';
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
      return 'Please enter the housing request details in English';
    }

    if (text.length < 5) {
      return 'Please provide clearer housing details in English';
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
      debugPrint(
        'Cannot show SnackBar: '
        'widget is not mounted',
      );

      return;
    }

    debugPrint(
      'Showing SnackBar: $message',
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
          fontWeight: FontWeight.w500,
          fontFamily: AppTextStyles.fontFamily,
        ),
      ),
    );
  }

  Widget _buildSubCategoryFields(
    bool isLoading,
  ) {
    final HousingSubCategory? selected =
        _selectedSubCategory;

    if (selected == null) {
      return const SizedBox.shrink();
    }

    switch (selected) {
      case HousingSubCategory.homeProvision:
        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            /*_buildSectionLabel(
              'بيانات تأمين المنزل',
            ),*/

            CustomTextField(
              label:
                  'مكان الإقامة الحالي بالتفصيل',
              hint:
                  'مثال: دمشق - المزة - سكن مؤقت',
              controller:
                  _currentPlaceOfResidenceController,
              maxLines: 2,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              label:
                  'سبب طلب تأمين منزل',
              hint:
                  'اشرح سبب الحاجة إلى منزل...',
              controller:
                  _reasonForLockController,
              maxLines: 4,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              label:
                  'مواصفات المنزل المطلوب',
              hint:
                  'مثال: غرفتان، قريب من المدرسة...',
              controller:
                  _housingSpecificationsController,
              maxLines: 3,
            ),
          ],
        );

      case HousingSubCategory.rentAssistance:
        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
         /*   _buildSectionLabel(
              'بيانات مساعدة الإيجار',
            ),*/

            CustomTextField(
              label:
                  'قيمة الإيجار الحالي',
              hint: 'مثال: 250',
              controller:
                  _currentRentController,
              keyboardType:
                  const TextInputType
                      .numberWithOptions(
                decimal: true,
              ),
              isCurrency: true,
            ),
          ],
        );

      case HousingSubCategory.homeRepairs:
        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            /*_buildSectionLabel(
              'بيانات الإصلاحات المنزلية',
            ),*/

            CustomTextField(
              label:
                  'وصف حالة المنزل الحالية',
              hint:
                  'اشرح الأضرار والإصلاحات المطلوبة...',
              controller:
                  _currentHousingSituationController,
              maxLines: 5,
            ),
          ],
        );
    }
  }

  Widget _buildCommonFields(
    bool isLoading,
  ) {
    if (_selectedSubCategory == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

       /* _buildSectionLabel(
          'البيانات المشتركة للطلب',
        ),*/

        CustomTextField(
          label:
              'تفاصيل الطلب السكني (عربي)',
          hint:
              'اشرح الحالة والحاجة إلى المساعدة باللغة العربية...',
          controller:
              _detailsArController,
          maxLines: 5,
        ),

        const SizedBox(height: 16),

        CustomTextField(
          label:
              'Housing request details (English)',
          hint:
              'Explain the housing situation and need in English...',
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
              'عقد إيجار، صور السكن، أو أي وثيقة تدعم الطلب',
          icon:
              Icons.upload_file_rounded,
          onTap: isLoading
              ? () {
                  debugPrint(
                    'Housing attachment picker ignored while loading',
                  );
                }
              : _pickAttachments,
        ),

        if (_attachments.isNotEmpty) ...[
          const SizedBox(height: 12),

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

        const SizedBox(height: 28),

        _buildDecorativeCard(),
      ],
    );
  }

  Widget _buildDecorativeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer
            .withValues(
          alpha: 0.35,
        ),
        borderRadius:
            BorderRadius.circular(24),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.home_work_outlined,
            size: 52,
            color: AppColors.primary,
          ),

          SizedBox(height: 12),

          Text(
            'نسعى لتوفير بيئة آمنة وكريمة لكل أسرة',
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
        HousingCubit,
        HousingState>(
      listener: (context, state) async {
        debugPrint(
          'HousingRequestPage listener state: '
          '${state.runtimeType}',
        );

        if (state is HousingSuccess) {
          debugPrint(
            'Housing request succeeded',
          );

          debugPrint(
            'Success message: ${state.message}',
          );

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
        } else if (state is HousingFailure) {
          debugPrint(
            'Housing request failed',
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
            state is HousingLoading;

        return Directionality(
          textDirection:
              TextDirection.rtl,
          child: Scaffold(
            backgroundColor:
                AppColors.background,
            appBar: AppBar(
              backgroundColor:
                  AppColors.background
                      .withValues(
                alpha: 0.8,
              ),
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
                'تفاصيل الطلب السكني',
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
                      CrossAxisAlignment
                          .start,
                  children: [
                    const CustomStepIndicator(
                      currentStep: 2,
                      totalSteps: 2,
                    ),

                    const SizedBox(height: 24),

                    _buildSectionLabel(
                      'نوع المساعدة السكنية المطلوبة',
                    ),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          HousingSubCategory
                              .values
                              .map(
                        (
                          HousingSubCategory
                              subCategory,
                        ) {
                          return SelectionChip(
                            label:
                                subCategory
                                    .arabicLabel,
                            isSelected:
                                _selectedSubCategory ==
                                    subCategory,
                            onTap: isLoading
                                ? () {
                                    debugPrint(
                                      'Subcategory selection ignored while loading',
                                    );
                                  }
                                : () {
                                    _selectSubCategory(
                                      subCategory,
                                    );
                                  },
                          );
                        },
                      ).toList(),
                    ),

                    /*
                     * قبل اختيار النوع نظهر تنبيهًا فقط،
                     * ولا نظهر أي حقل.
                     */
                    if (_selectedSubCategory ==
                        null) ...[
                      const SizedBox(
                        height: 20,
                      ),

                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(
                          16,
                        ),
                        decoration:
                            BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                          border: Border.all(
                            color: AppColors
                                .brandGray
                                .withValues(
                              alpha: 0.15,
                            ),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons
                                  .info_outline,
                              color: AppColors
                                  .primary,
                            ),

                            SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                'اختر نوع المساعدة السكنية لعرض الحقول المطلوبة',
                                style:
                                    TextStyle(
                                  color:
                                      AppColors
                                          .brandGray,
                                  fontSize: 14,
                                  fontFamily:
                                      AppTextStyles
                                          .fontFamily,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (_selectedSubCategory !=
                        null) ...[
                      const SizedBox(height: 24),

                      _buildSubCategoryFields(
                        isLoading,
                      ),

                      _buildCommonFields(
                        isLoading,
                      ),
                    ],
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