import 'package:charity_management/features/auth/screens/new_password.dart';
import '../../otp/screen/otp_screen.dart';
import 'package:charity_management/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/widgets/custom_text_fields.dart';
import '/theme/app_colors.dart';
import '../../register_donor/screen/signup_donor.dart';
import '../../register_beneficiary/screen/signup_beneficiary.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import '../../register_donor/cubit/register_donor_cubit.dart';
import 'package:charity_management/features/auth/login/cubit/login_cubit.dart';
import 'package:charity_management/features/auth/login/cubit/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum RegisterType { donor, beneficiary }

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String selectedCountryCode = '+963';
String selectedCountryFlag = '🇸🇾';

  RegisterType? selectedRegisterType;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
  FocusScope.of(context).unfocus();

  if (_formKey.currentState?.validate() ?? false) {
    context.read<LoginCubit>().login(
      countryCode: selectedCountryCode,
      phoneNumber: _phoneController.text.trim(),
      password: _passwordController.text,
    );
  }
}

  void _onRegisterTypeSelected(RegisterType type) {
    setState(() {
      selectedRegisterType = type;
    });

    if (type == RegisterType.donor) {
      Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (_) => RegisterDonorCubit(
        authService: AuthService(),
      ),
      child: const SignUpDonorScreen(),
    ),
  ),
);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NewPasswordScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<LoginCubit, LoginState>(
  listener: (context, state) {
    if (state is LoginFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    if (state is LoginSuccess) {
      final user = state.response.user;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم تسجيل الدخول بنجاح، أهلاً ${user.firstName}',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
       Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const NewPasswordScreen(),
    ),
  );

      // if (user.isDonor) {
      //   Navigator.pushNamedAndRemoveUntil(
      //     context,
      //     '/donor-home',
      //     (route) => false,
      //   );
      // } else if (user.isBeneficiary) {
      //   Navigator.pushNamedAndRemoveUntil(
      //     context,
      //     '/beneficiary-home',
      //     (route) => false,
      //   );
      // }
    }
  },
  child: Directionality(
    textDirection: TextDirection.rtl,
    child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 32),

                Image.asset(
                  'assets/img/logo_isolated.svg.png',
                  height: 92,
                  width: 92,
                ),

                const SizedBox(height: 10),

                Text(
                  "جميعة الأثر",
                  style: GoogleFonts.notoKufiArabic(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 40),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(22, 49, 22, 32),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(72),
                      topRight: Radius.circular(72),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'تسجيل الدخول',
                          style: GoogleFonts.tajawal(
                            fontSize: 24,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 26),

                        CustomTextField(
  labelText: 'رقم الجوال',
  hintText: 'xxxxxxxxx',
  controller: _phoneController,
  keyboardType: TextInputType.phone,
  inputFormatters: [
    FilteringTextInputFormatter.digitsOnly,
  ],
  prefixWidget: InkWell(
    onTap: _selectCountry,
    child: Container(
      width: 105,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Color(0xFFE7D9A8),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            selectedCountryFlag,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 4),
          Text(
            selectedCountryCode,
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              color: Color(0xFF7A6500),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: Color(0xFF7A6500),
          ),
        ],
      ),
    ),
  ),
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

                        const SizedBox(height: 10),

                        CustomTextField(
                          labelText: 'كلمة المرور',
                          hintText: '••••••••',
                          controller: _passwordController,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال كلمة المرور';
                            }
                            return null;
                          },
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const NewPasswordScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'نسيت كلمة المرور؟',
                              style: GoogleFonts.tajawal(
                                fontSize: 12,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 6),

                        BlocBuilder<LoginCubit, LoginState>(
  builder: (context, state) {
    final isLoading = state is LoginLoading;

    return SizedBox(
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: isLoading ? null : _onLoginPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 3,
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'تسجيل الدخول',
                style: GoogleFonts.tajawal(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  },
),
                        const SizedBox(height: 10),

                        _RegisterDropdownButton(
                          selectedType: selectedRegisterType,
                          onChanged: (type) {
                            if (type != null) {
                              _onRegisterTypeSelected(type);
                            }
                          },
                        ),

                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppColors.primary.withOpacity(0.18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Text(
                                'أو',
                                style: GoogleFonts.tajawal(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: AppColors.primary.withOpacity(0.18),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: OutlinedButton(
                            onPressed: () {
                              // TODO: continue as visitor
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: BorderSide(
                                color: AppColors.primary.withOpacity(0.25),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'الدخول كزائر',
                              style: GoogleFonts.tajawal(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
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
      ),
    );
  }
  void _selectCountry() {
  showCountryPicker(
    context: context,
    showPhoneCode: true,
    favorite: const ['SY', 'SA', 'AE', 'JO', 'EG', 'LB', 'IQ'],
    countryListTheme: CountryListThemeData(
      bottomSheetHeight: 520,
      inputDecoration: InputDecoration(
        labelText: 'بحث',
        hintText: 'اكتب اسم البلد',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    onSelect: (Country country) {
      setState(() {
        selectedCountryCode = '+${country.phoneCode}';
        selectedCountryFlag = country.flagEmoji;
      });
    },
  );
}
}


class _RegisterDropdownButton extends StatelessWidget {
  const _RegisterDropdownButton({
    required this.selectedType,
    required this.onChanged,
  });

  final RegisterType? selectedType;
  final ValueChanged<RegisterType?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<RegisterType>(
      value: selectedType,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.25)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      hint: Center(
        child: Text(
          'إنشاء حساب جديد',
          style: GoogleFonts.tajawal(fontSize: 14, color: AppColors.primary),
        ),
      ),
      items: [
        DropdownMenuItem(
          value: RegisterType.donor,
          child: Text(
            'إنشاء حساب كمتبرع',
            style: GoogleFonts.tajawal(color: AppColors.primary),
          ),
        ),
        DropdownMenuItem(
          value: RegisterType.beneficiary,
          child: Text(
            'إنشاء حساب كمستفيد',
            style: GoogleFonts.tajawal(color: AppColors.primary),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
