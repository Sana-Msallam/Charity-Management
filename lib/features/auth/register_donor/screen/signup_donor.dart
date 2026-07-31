import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/routes/app_routes.dart';
import '../cubit/register_donor_cubit.dart';
import '../cubit/register_donor_state.dart';

import '/widgets/custom_text_fields.dart';
import 'package:country_picker/country_picker.dart';
import '/theme/app_colors.dart';

class SignUpDonorScreen extends StatefulWidget {
  const SignUpDonorScreen({super.key});

  @override
  State<SignUpDonorScreen> createState() => _SignUpDonorScreenState();
}

class _SignUpDonorScreenState extends State<SignUpDonorScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String selectedGender = 'MALE';

  String selectedCountryName = 'Saudi Arabia';
  String selectedCountryCode = '+966';
  String selectedCountryIsoCode = 'SA';
  String selectedCountryFlag = '🇸🇦';

  static const backgroundColor = Color(0xFFFFFAF0);
  static const cardColor = AppColors.primaryContainer;
  static const primaryColor = AppColors.primary;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _selectCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      favorite: const ['SA', 'SY', 'AE', 'JO', 'EG', 'LB', 'IQ'],
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: 520,
        inputDecoration: InputDecoration(
          labelText: AppLocalizations.of(context).search,
          hintText: AppLocalizations.of(context).countrySearchHint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          selectedCountryName = country.name;
          selectedCountryCode = '+${country.phoneCode}';
          selectedCountryIsoCode = country.countryCode;
          selectedCountryFlag = country.flagEmoji;
        });

        debugPrint('Selected country name: $selectedCountryName');
        debugPrint('Selected country code: $selectedCountryCode');
      },
    );
  }

  void _createAccount() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final normalizedPhoneNumber = _cleanPhoneNumber(phoneController.text);

    context.read<RegisterDonorCubit>().register(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      number: normalizedPhoneNumber,
      countryName: selectedCountryName,
      countryCode: selectedCountryCode,
      gender: selectedGender,
      localizations: AppLocalizations.of(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocListener<RegisterDonorCubit, RegisterDonorState>(
        listener: (context, state) {
          if (state is RegisterDonorFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state is RegisterDonorSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.response.message.isNotEmpty
                      ? state.response.message
                      : localizations.otpSentToPhone,
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );

            Navigator.pushReplacementNamed(
              context,
              AppRoutes.otp,
              arguments: OtpRouteArguments(
                countryCode: selectedCountryCode,
                phoneNumber: _cleanPhoneNumber(phoneController.text),
                userType: 'donor',
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back),
                              color: primaryColor,
                            ),
                          ),
                          Text(
                            localizations.createAccount,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      Text(
                        localizations.donorWelcome,
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),

                      const SizedBox(height: 6),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.78,
                  ),
                  padding: const EdgeInsets.all(24),
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
                        CustomTextField(
                          labelText: localizations.firstName,
                          hintText: localizations.firstNameHint,
                          controller: firstNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return localizations.firstNameRequired;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        CustomTextField(
                          labelText: localizations.lastName,
                          hintText: localizations.lastNameHint,
                          controller: lastNameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return localizations.lastNameRequired;
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        CustomTextField(
                          labelText: localizations.phoneNumber,
                          hintText: 'xxxxxxxxx',
                          controller: phoneController,
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
                                border: BorderDirectional(
                                  end: BorderSide(color: Color(0xFFE7D9A8)),
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      selectedCountryFlag,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      selectedCountryCode,
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
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return localizations.phoneRequired;
                            }

                            if (value.trim().length < 8) {
                              return localizations.invalidPhoneNumber;
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        CustomTextField(
                          labelText: localizations.email,
                          hintText: 'example@domain.com',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return localizations.emailRequired;
                            }

                            if (!value.contains('@')) {
                              return localizations.invalidEmail;
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        _GenderSelector(
                          selectedGender: selectedGender,
                          onGenderChanged: (gender) {
                            setState(() {
                              selectedGender = gender;
                            });
                          },
                        ),

                        const SizedBox(height: 12),

                        CustomTextField(
                          labelText: localizations.password,
                          hintText: '********',
                          controller: passwordController,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localizations.passwordRequired;
                            }

                            if (value.length < 6) {
                              return localizations.passwordMin6;
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        CustomTextField(
                          labelText: localizations.confirmPassword,
                          hintText: '********',
                          controller: confirmPasswordController,
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

                        const SizedBox(height: 22),

                        BlocBuilder<RegisterDonorCubit, RegisterDonorState>(
                          builder: (context, state) {
                            final isLoading = state is RegisterDonorLoading;

                            return SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: isLoading ? null : _createAccount,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: primaryColor
                                      .withValues(alpha: 0.6),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
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
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.person_add_alt_1,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            localizations.createNewAccount,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 14),

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
                              onPressed: () {
                                Navigator.pop(context);
                              },
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
      ),
    );
  }
}

class _GenderSelector extends StatelessWidget {
  const _GenderSelector({
    required this.selectedGender,
    required this.onGenderChanged,
  });

  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

  static const primaryColor = Color(0xFF7A6500);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            AppLocalizations.of(context).gender,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 11,
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: _GenderButton(
                  text: AppLocalizations.of(context).female,
                  isSelected: selectedGender == 'FEMALE',
                  onTap: () => onGenderChanged('FEMALE'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _GenderButton(
                  text: AppLocalizations.of(context).male,
                  isSelected: selectedGender == 'MALE',
                  onTap: () => onGenderChanged('MALE'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _cleanPhoneNumber(String value) {
  String number = value.trim().replaceAll(' ', '').replaceAll('-', '');

  if (number.startsWith('0')) {
    number = number.substring(1);
  }

  return number;
}

class _GenderButton extends StatelessWidget {
  const _GenderButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  static const selectedGenderColor = AppColors.secondary;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? selectedGenderColor : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColors.primary : Colors.grey,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
