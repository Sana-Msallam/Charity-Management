import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '/theme/app_colors.dart';
import '/widgets/custom_text_fields.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/routes/app_routes.dart';
import '../cubit/register_beneficiary_cubit.dart';
import '../cubit/register_beneficiary_state.dart';

class SignUpBeneficiaryScreen extends StatefulWidget {
  const SignUpBeneficiaryScreen({super.key});

  @override
  State<SignUpBeneficiaryScreen> createState() =>
      _SignUpBeneficiaryScreenState();
}

class _SignUpBeneficiaryScreenState extends State<SignUpBeneficiaryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  File? personalImage;
  File? familyStatementImage;

  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController dateOfBirthController = TextEditingController();

  final TextEditingController monthlyIncomeController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final TextEditingController childrenCountController = TextEditingController();

  String? selectedAddress;
  String selectedSocialStatus = 'SINGLE';
  String selectedGender = 'MALE';
  DateTime? selectedDateOfBirth;

  bool isUnemployed = true;

  final List<String> addressOptions = [
    'مزة',
    'ميدان',
    'مهاجرين',
    'عفيف',
    'ركن الدين',
    'صحنايا',
    'المالكي',
    'شارع بغداد',
    'كفرسوسة',
    'برزة',
    'شعلان',
    'شارع الحمرا',
    'ميسات',
    'الصالحية',
    'المزرعة',
    'ريف دمشق',
  ];

  final Map<String, String> addressEnglish = {
    'مزة': 'Al Mazzeh',
    'ميدان': 'Al Midan',
    'مهاجرين': 'Al Muhajireen',
    'عفيف': 'Afif',
    'ركن الدين': 'Rukn Al Din',
    'صحنايا': 'Sahnaya',
    'المالكي': 'Al Malki',
    'شارع بغداد': 'Baghdad Street',
    'كفرسوسة': 'Kafr Sousa',
    'برزة': 'Barzeh',
    'شعلان': 'Shaalan',
    'شارع الحمرا': 'Al Hamra Street',
    'ميسات': 'Maysat',
    'الصالحية': 'Al Salihiyah',
    'المزرعة': 'Al Mazraa',
    'ريف دمشق': 'Rural Damascus',
  };

  final List<String> socialStatusOptions = [
    'SINGLE',
    'MARRIED',
    'DIVORCED',
    'WIDOWED',
  ];

  static const Color backgroundColor = Color(0xFFFFFAF0);
  static const Color cardColor = AppColors.primaryContainer;
  static const Color primaryColor = AppColors.primary;

  @override
  void initState() {
    super.initState();

    childrenCountController.text = '0';
    monthlyIncomeController.text = '0';
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
    monthlyIncomeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    childrenCountController.dispose();

    super.dispose();
  }

  void _createAccount() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (personalImage == null) {
      _showError(AppLocalizations.of(context).personalPhotoRequired);
      return;
    }

    if (familyStatementImage == null) {
      _showError(AppLocalizations.of(context).familyStatementRequired);
      return;
    }

    if (selectedAddress == null) {
      _showError(AppLocalizations.of(context).addressRequired);
      return;
    }

    context.read<RegisterBeneficiaryCubit>().register(
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      password: passwordController.text,
      number: phoneController.text,
      countryName: 'Syria',
      countryCode: '+963',
      gender: selectedGender,
      dateOfBirth: dateOfBirthController.text,
      personalPhoto: personalImage!,
      familyStatement: familyStatementImage!,
      addressAr: selectedAddress!,
      addressEn: addressEnglish[selectedAddress!]!,
      socialStatus: selectedSocialStatus,
      isUnemployed: isUnemployed,
      monthlyIncome: monthlyIncomeController.text,
      numberOfChildren: childrenCountController.text,
      localizations: AppLocalizations.of(context),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
  }

  String _cleanPhoneNumber(String value) {
    String number = value.trim().replaceAll(' ', '').replaceAll('-', '');

    if (number.startsWith('0')) {
      number = number.substring(1);
    }

    return number;
  }

  Future<void> _pickDateOfBirth() async {
    final today = _dateOnly(DateTime.now());
    final initialDate =
        selectedDateOfBirth ??
        DateTime(today.year - 18, today.month, today.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(today) ? today : initialDate,
      firstDate: DateTime(1900),
      lastDate: today,
      helpText: AppLocalizations.of(context).selectDateOfBirth,
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    setState(() {
      selectedDateOfBirth = _dateOnly(pickedDate);
      dateOfBirthController.text = _formatDate(pickedDate);
    });
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Future<void> _pickImage({
    required bool isPersonalImage,
    required ImageSource source,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile == null || !mounted) {
        return;
      }

      setState(() {
        if (isPersonalImage) {
          personalImage = File(pickedFile.path);
        } else {
          familyStatementImage = File(pickedFile.path);
        }
      });
    } catch (_) {
      if (!mounted) return;

      _showError(AppLocalizations.of(context).imageSelectionFailed);
    }
  }

  void _showImageSourceSheet({required bool isPersonalImage}) {
    showModalBottomSheet<void>(
      context: context,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context).chooseFromGallery),
                onTap: () {
                  Navigator.pop(bottomSheetContext);

                  _pickImage(
                    isPersonalImage: isPersonalImage,
                    source: ImageSource.gallery,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(AppLocalizations.of(context).takePhoto),
                onTap: () {
                  Navigator.pop(bottomSheetContext);

                  _pickImage(
                    isPersonalImage: isPersonalImage,
                    source: ImageSource.camera,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return BlocConsumer<RegisterBeneficiaryCubit, RegisterBeneficiaryState>(
      listener: (context, state) {
        if (state is RegisterBeneficiarySuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.response.message.isNotEmpty
                      ? state.response.message
                      : localizations.otpSent,
                ),
                backgroundColor: Colors.green,
              ),
            );

          Navigator.pushReplacementNamed(
            context,
            AppRoutes.otp,
            arguments: OtpRouteArguments(
              countryCode: '+963',
              phoneNumber: _cleanPhoneNumber(phoneController.text),
              userType: 'beneficiary',
            ),
          );
        }
        if (state is RegisterBeneficiaryFailure) {
          _showError(state.message);
        }
      },
      builder: (context, state) {
        final bool isLoading = state is RegisterBeneficiaryLoading;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: IconButton(
                                onPressed: isLoading
                                    ? null
                                    : () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back),
                                color: primaryColor,
                              ),
                            ),
                            Text(
                              localizations.createAccount,
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          localizations.beneficiaryWelcome,
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(44),
                        topRight: Radius.circular(44),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _ProfileImagePicker(
                            imageFile: personalImage,
                            onTap: isLoading
                                ? null
                                : () {
                                    _showImageSourceSheet(
                                      isPersonalImage: true,
                                    );
                                  },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  labelText: localizations.firstName,
                                  hintText: localizations.firstNameHint,
                                  controller: firstNameController,
                                  enabled: !isLoading,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return localizations.firstNameRequired;
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: CustomTextField(
                                  labelText: localizations.lastName,
                                  hintText: localizations.lastNameHint,
                                  controller: lastNameController,
                                  enabled: !isLoading,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return localizations.lastNameRequired;
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            labelText: localizations.phoneNumber,
                            hintText: '9xxxxxxxx',
                            controller: phoneController,
                            enabled: !isLoading,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            validator: (value) {
                              final phone = value?.trim() ?? '';

                              if (phone.isEmpty) {
                                return localizations.phoneRequired;
                              }

                              if (phone.length < 8) {
                                return localizations.invalidPhoneNumber;
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            labelText: localizations.email,
                            hintText: 'example@domain.com',
                            controller: emailController,
                            enabled: !isLoading,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              final email = value?.trim() ?? '';

                              if (email.isEmpty) {
                                return localizations.emailRequired;
                              }

                              final emailRegex = RegExp(
                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                              );

                              if (!emailRegex.hasMatch(email)) {
                                return localizations.invalidEmail;
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            labelText: localizations.dateOfBirth,
                            hintText: localizations.dateOfBirthHint,
                            controller: dateOfBirthController,
                            enabled: !isLoading,
                            readOnly: true,
                            keyboardType: TextInputType.datetime,
                            suffixIcon: const Icon(
                              Icons.calendar_today_outlined,
                              color: primaryColor,
                              size: 18,
                            ),
                            onTap: isLoading ? null : _pickDateOfBirth,
                            validator: (value) {
                              final dateText = value?.trim() ?? '';

                              if (dateText.isEmpty) {
                                return localizations.dateOfBirthRequired;
                              }

                              final date = DateTime.tryParse(dateText);

                              if (date == null) {
                                return localizations.invalidDateOfBirth;
                              }

                              if (_dateOnly(
                                date,
                              ).isAfter(_dateOnly(DateTime.now()))) {
                                return localizations.dateOfBirthFutureInvalid;
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          _DropdownField(
                            labelText: localizations.residentialAddress,
                            hintText: localizations.selectResidentialAddress,
                            value: selectedAddress,
                            items: addressOptions,
                            itemLabelBuilder: (value) =>
                                _addressLabel(localizations, value),
                            enabled: !isLoading,
                            onChanged: (value) {
                              setState(() {
                                selectedAddress = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localizations.addressRequired;
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          _TwoOptionSelector(
                            title: localizations.gender,
                            firstText: localizations.female,
                            firstValue: 'FEMALE',
                            secondText: localizations.male,
                            secondValue: 'MALE',
                            selectedText: selectedGender,
                            enabled: !isLoading,
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          _EmploymentSelector(
                            isUnemployed: isUnemployed,
                            enabled: !isLoading,
                            onChanged: (value) {
                              setState(() {
                                isUnemployed = value;

                                if (isUnemployed) {
                                  monthlyIncomeController.text = '0';
                                } else {
                                  monthlyIncomeController.clear();
                                }
                              });
                            },
                          ),
                          const SizedBox(height: 8),
                          _DocumentUploadBox(
                            title: localizations.familyStatementPhoto,
                            imageFile: familyStatementImage,
                            onTap: isLoading
                                ? null
                                : () {
                                    _showImageSourceSheet(
                                      isPersonalImage: false,
                                    );
                                  },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _DropdownField(
                                  labelText: localizations.socialStatus,
                                  hintText: localizations.selectStatus,
                                  value: selectedSocialStatus,
                                  items: socialStatusOptions,
                                  itemLabelBuilder: (value) =>
                                      _socialStatusLabel(localizations, value),
                                  enabled: !isLoading,
                                  onChanged: (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setState(() {
                                      selectedSocialStatus = value;

                                      if (value == 'SINGLE') {
                                        childrenCountController.text = '0';
                                      } else {
                                        childrenCountController.clear();
                                      }
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: CustomTextField(
                                  labelText: localizations.numberOfChildren,
                                  hintText: '0',
                                  controller: childrenCountController,
                                  enabled:
                                      !isLoading &&
                                      selectedSocialStatus != 'SINGLE',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (value) {
                                    if (selectedSocialStatus == 'SINGLE') {
                                      return null;
                                    }

                                    if (value == null || value.trim().isEmpty) {
                                      return localizations.childrenRequired;
                                    }

                                    final childrenCount = int.tryParse(
                                      value.trim(),
                                    );

                                    if (childrenCount == null ||
                                        childrenCount < 0) {
                                      return localizations.invalidNumber;
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            labelText: localizations.monthlyIncome,
                            hintText: '0.00',
                            controller: monthlyIncomeController,
                            enabled: !isLoading && !isUnemployed,
                            suffixText: localizations.syrianPound,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*'),
                              ),
                            ],
                            validator: (value) {
                              if (isUnemployed) {
                                return null;
                              }

                              if (value == null || value.trim().isEmpty) {
                                return localizations.incomeRequired;
                              }

                              final monthlyIncome = double.tryParse(
                                value.trim(),
                              );

                              if (monthlyIncome == null || monthlyIncome < 0) {
                                return localizations.invalidIncome;
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            labelText: localizations.password,
                            hintText: '********',
                            controller: passwordController,
                            enabled: !isLoading,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localizations.passwordRequired;
                              }

                              if (value.length < 8) {
                                return localizations.passwordMin8;
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          CustomTextField(
                            labelText: localizations.confirmPassword,
                            hintText: '********',
                            controller: confirmPasswordController,
                            enabled: !isLoading,
                            isPassword: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localizations.confirmPasswordRequired;
                              }

                              if (value != passwordController.text) {
                                return localizations.passwordsDoNotMatch;
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : _createAccount,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: primaryColor
                                    .withValues(alpha: 0.6),
                                disabledForegroundColor: Colors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person_add_alt_1, size: 19),
                                        SizedBox(width: 8),
                                        Text(
                                          localizations.createNewAccount,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                localizations.alreadyHaveAccount,
                                style: TextStyle(
                                  color: Color(0xFF8C805F),
                                  fontSize: 12,
                                ),
                              ),
                              TextButton(
                                onPressed: isLoading
                                    ? null
                                    : () => Navigator.pop(context),
                                child: Text(
                                  localizations.login,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileImagePicker extends StatelessWidget {
  const _ProfileImagePicker({required this.imageFile, required this.onTap});

  final File? imageFile;
  final VoidCallback? onTap;

  static const Color primaryColor = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            backgroundImage: imageFile == null ? null : FileImage(imageFile!),
            child: imageFile == null
                ? const Icon(
                    Icons.add_a_photo_outlined,
                    color: primaryColor,
                    size: 25,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          AppLocalizations.of(context).personalPhoto,
          style: TextStyle(color: primaryColor, fontSize: 10),
        ),
      ],
    );
  }
}

class _DocumentUploadBox extends StatelessWidget {
  const _DocumentUploadBox({
    required this.title,
    required this.imageFile,
    required this.onTap,
  });

  final String title;
  final File? imageFile;
  final VoidCallback? onTap;

  static const Color primaryColor = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: primaryColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryColor.withValues(alpha: 0.45)),
            ),
            child: imageFile == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.upload_file,
                        color: primaryColor,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppLocalizations.of(context).tapToSelectPhoto,
                        style: const TextStyle(
                          color: Color(0xFF8C805F),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      imageFile!,
                      width: double.infinity,
                      height: 68,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class _TwoOptionSelector extends StatelessWidget {
  const _TwoOptionSelector({
    required this.title,
    required this.firstText,
    required this.firstValue,
    required this.secondText,
    required this.secondValue,
    required this.selectedText,
    required this.onChanged,
    this.enabled = true,
  });

  final String title;
  final String firstText;
  final String firstValue;
  final String secondText;
  final String secondValue;
  final String selectedText;
  final ValueChanged<String> onChanged;
  final bool enabled;

  static const Color primaryColor = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: primaryColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: _SmallSelectButton(
                  text: firstText,
                  isSelected: selectedText == firstValue,
                  enabled: enabled,
                  onTap: () => onChanged(firstValue),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SmallSelectButton(
                  text: secondText,
                  isSelected: selectedText == secondValue,
                  enabled: enabled,
                  onTap: () => onChanged(secondValue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmploymentSelector extends StatelessWidget {
  const _EmploymentSelector({
    required this.isUnemployed,
    required this.onChanged,
    this.enabled = true,
  });

  final bool isUnemployed;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  static const Color primaryColor = AppColors.primary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).employmentStatus,
          style: TextStyle(
            color: primaryColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 42,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: _SmallSelectButton(
                  text: AppLocalizations.of(context).unemployed,
                  isSelected: isUnemployed,
                  enabled: enabled,
                  onTap: () => onChanged(true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SmallSelectButton(
                  text: AppLocalizations.of(context).employed,
                  isSelected: !isUnemployed,
                  enabled: enabled,
                  onTap: () => onChanged(false),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SmallSelectButton extends StatelessWidget {
  const _SmallSelectButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.enabled = true,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: enabled
                ? isSelected
                      ? AppColors.primary
                      : Colors.grey
                : Colors.grey.shade400,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  const _DropdownField({
    required this.labelText,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.enabled = true,
    this.itemLabelBuilder,
  });

  final String labelText;
  final String hintText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final String Function(String)? itemLabelBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          hint: Text(
            hintText,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.primary,
            size: 18,
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                itemLabelBuilder?.call(item) ?? item,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: enabled ? onChanged : null,
          validator: validator,
        ),
      ],
    );
  }
}

String _socialStatusLabel(AppLocalizations localizations, String value) {
  return switch (value) {
    'MARRIED' => localizations.married,
    'DIVORCED' => localizations.divorced,
    'WIDOWED' => localizations.widowed,
    _ => localizations.single,
  };
}

String _addressLabel(AppLocalizations localizations, String value) {
  return switch (value) {
    'مزة' => localizations.addressMazzeh,
    'ميدان' => localizations.addressMidan,
    'مهاجرين' => localizations.addressMuhajireen,
    'عفيف' => localizations.addressAfif,
    'ركن الدين' => localizations.addressRuknAlDin,
    'صحنايا' => localizations.addressSahnaya,
    'المالكي' => localizations.addressMalki,
    'شارع بغداد' => localizations.addressBaghdadStreet,
    'كفرسوسة' => localizations.addressKafrSousa,
    'برزة' => localizations.addressBarzeh,
    'شعلان' => localizations.addressShaalan,
    'شارع الحمرا' => localizations.addressHamraStreet,
    'ميسات' => localizations.addressMaysat,
    'الصالحية' => localizations.addressSalihiyah,
    'المزرعة' => localizations.addressMazraa,
    'ريف دمشق' => localizations.addressRuralDamascus,
    _ => value,
  };
}
