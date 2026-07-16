import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '/widgets/custom_text_fields.dart';
import 'dart:io';
import '/theme/app_colors.dart';


class SignUpBeneficiaryScreen extends StatefulWidget {
  const SignUpBeneficiaryScreen({super.key});

  @override
  State<SignUpBeneficiaryScreen> createState() =>
      _SignUpBeneficiaryScreenState();
}

class _SignUpBeneficiaryScreenState extends State<SignUpBeneficiaryScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  File? personalImage;
  File? familyStatementImage;
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final monthlyIncomeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final childrenCountController = TextEditingController();

  String? selectedAddress;
  String selectedSocialStatus = 'أعزب';

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

  final List<String> socialStatusOptions = ['أعزب', 'متزوج', 'مطلق', 'أرمل'];

  String selectedGender = 'ذكر';
  bool isUnemployed = true;

  static const backgroundColor = Color(0xFFFFFAF0);
  static const cardColor = AppColors.primaryContainer;
  static const primaryColor = AppColors.primary;

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    monthlyIncomeController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    childrenCountController.dispose();
    super.dispose();
  }

  void _createAccount() {
    if (!_formKey.currentState!.validate()) return;

    final beneficiaryData = {
      'fullName': fullNameController.text.trim(),
      'phone': phoneController.text.trim(),
      'email': emailController.text.trim(),
      'address': selectedAddress,
      'gender': selectedGender,
      'isUnemployed': isUnemployed,
      'monthlyIncome': monthlyIncomeController.text.trim(),
      'socialStatus': selectedSocialStatus,
      'childrenCount': childrenCountController.text.trim(),
      'password': passwordController.text,
    };

    debugPrint(beneficiaryData.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم التحقق من بيانات المستفيد بنجاح')),
    );
  }

  @override
  void initState() {
    super.initState();
    childrenCountController.text = '0';
    monthlyIncomeController.text = '0';
  }

  Future<void> _pickImage({
    required bool isPersonalImage,
    required ImageSource source,
  }) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    setState(() {
      if (isPersonalImage) {
        personalImage = File(pickedFile.path);
      } else {
        familyStatementImage = File(pickedFile.path);
      }
    });
  }

  void _showImageSourceSheet({required bool isPersonalImage}) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('اختيار من الاستديو'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(
                      isPersonalImage: isPersonalImage,
                      source: ImageSource.gallery,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('التقاط صورة بالكاميرا'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(
                      isPersonalImage: isPersonalImage,
                      source: ImageSource.camera,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
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
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back),
                              color: primaryColor,
                            ),
                          ),
                          const Text(
                            'إنشاء حساب',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'سجل بياناتك للانضمام إلى برنامج رعاية المستفيدين',
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
                          onTap: () =>
                              _showImageSourceSheet(isPersonalImage: true),
                        ),
                        const SizedBox(height: 8),

                        CustomTextField(
                          labelText: 'الاسم الكامل',
                          hintText: 'مثال: سارة محمد',
                          controller: fullNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال الاسم الكامل';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 8),

                        CustomTextField(
                          labelText: 'رقم الجوال',
                          hintText: '5xxxxxxxx',
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال رقم الجوال';
                            }
                            if (value.trim().length < 8) {
                              return 'رقم الجوال غير صحيح';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 8),

                        CustomTextField(
                          labelText: 'البريد الإلكتروني',
                          hintText: 'example@domain.com',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال البريد الإلكتروني';
                            }
                            if (!value.contains('@')) {
                              return 'البريد الإلكتروني غير صحيح';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 8),

                        _DropdownField(
                          labelText: 'عنوان السكن',
                          hintText: 'اختر عنوان السكن',
                          value: selectedAddress,
                          items: addressOptions,
                          onChanged: (value) {
                            setState(() {
                              selectedAddress = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء اختيار عنوان السكن';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 8),

                        _TwoOptionSelector(
                          title: 'الجنس',
                          firstText: 'أنثى',
                          secondText: 'ذكر',
                          selectedText: selectedGender,
                          onChanged: (value) {
                            setState(() {
                              selectedGender = value;
                            });
                          },
                        ),

                        const SizedBox(height: 8),

                        _EmploymentSelector(
                          isUnemployed: isUnemployed,
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
                          title: 'صورة عن البيان العائلي',
                          imageFile: familyStatementImage,
                          onTap: () =>
                              _showImageSourceSheet(isPersonalImage: false),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Expanded(
                              child: _DropdownField(
                                labelText: 'الحالة الاجتماعية',
                                hintText: 'اختر الحالة',
                                value: selectedSocialStatus,
                                items: socialStatusOptions,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSocialStatus = value!;

                                    if (selectedSocialStatus == 'أعزب') {
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
                                labelText: 'عدد الأولاد',
                                hintText: '0',
                                controller: childrenCountController,
                                enabled: selectedSocialStatus != 'أعزب',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (selectedSocialStatus == 'أعزب')
                                    return null;

                                  if (value == null || value.trim().isEmpty) {
                                    return 'أدخل عدد الأولاد';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        CustomTextField(
                          labelText: 'الراتب الشهري',
                          hintText: '0.00',
                          controller: monthlyIncomeController,
                          enabled: !isUnemployed,
                          suffixText: 'ل.س',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*'),
                            ),
                          ],
                          validator: (value) {
                            if (isUnemployed) return null;

                            if (value == null || value.trim().isEmpty) {
                              return 'الرجاء إدخال الراتب الشهري';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),

                        CustomTextField(
                          labelText: 'كلمة المرور',
                          hintText: '********',
                          controller: passwordController,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال كلمة المرور';
                            }
                            if (value.length < 6) {
                              return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 8),

                        CustomTextField(
                          labelText: 'تأكيد كلمة المرور',
                          hintText: '********',
                          controller: confirmPasswordController,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء تأكيد كلمة المرور';
                            }
                            if (value != passwordController.text) {
                              return 'كلمتا المرور غير متطابقتين';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _createAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_add_alt_1, size: 19),
                                SizedBox(width: 8),
                                Text(
                                  'إنشاء حساب جديد',
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
                            const Text(
                              'لديك حساب بالفعل؟',
                              style: TextStyle(
                                color: Color(0xFF8C805F),
                                fontSize: 12,
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'تسجيل الدخول',
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
      ),
    );
  }
}

class _ProfileImagePicker extends StatelessWidget {
  const _ProfileImagePicker({required this.imageFile, required this.onTap});

  final File? imageFile;
  final VoidCallback onTap;

  static const primaryColor = Color(0xFF7A6500);

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
            backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
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
        const Text(
          'صورة شخصية',
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
  final VoidCallback onTap;

  static const primaryColor = Color(0xFF7A6500);

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
          child: Container(
            width: double.infinity,
            height: 68,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryColor.withOpacity(0.45)),
            ),
            child: imageFile == null
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file, color: primaryColor, size: 22),
                      SizedBox(height: 4),
                      Text(
                        'اضغط لاختيار صورة',
                        style: TextStyle(
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
    required this.secondText,
    required this.selectedText,
    required this.onChanged,
  });

  final String title;
  final String firstText;
  final String secondText;
  final String selectedText;
  final ValueChanged<String> onChanged;

  static const primaryColor = AppColors.primary;

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
                  isSelected: selectedText == firstText,
                  onTap: () => onChanged(firstText),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SmallSelectButton(
                  text: secondText,
                  isSelected: selectedText == secondText,
                  onTap: () => onChanged(secondText),
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
  });

  final bool isUnemployed;
  final ValueChanged<bool> onChanged;

  static const primaryColor = Color(0xFF7A6500);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الحالة المهنية',
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
                  text: 'لا أعمل',
                  isSelected: isUnemployed,
                  onTap: () => onChanged(true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _SmallSelectButton(
                  text: 'أعمل',
                  isSelected: !isUnemployed,
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
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  static const selectedColor = Color(0xFFAEEBCB);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
            color: isSelected ? AppColors.primary : Colors.grey,
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
  });

  final String labelText;
  final String hintText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

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
          value: value,
          isExpanded: true,
          hint: Text(
            hintText,
            style: const TextStyle(color: Colors.grey, fontSize: 11),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
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
              child: Text(item, style: const TextStyle(fontSize: 12)),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }
}
