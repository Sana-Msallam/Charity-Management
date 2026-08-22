import 'package:charity_management/routes/app_routes.dart';
import 'package:flutter/material.dart';

import '/widgets/custom_text_fields.dart';
import '/theme/app_colors.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:charity_management/features/auth/login/cubit/login_cubit.dart';
import 'package:charity_management/features/auth/login/cubit/login_state.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';

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
        localizations: AppLocalizations.of(context),
      );
    }
  }

  void _onRegisterTypeSelected(RegisterType type) {
    setState(() {
      selectedRegisterType = type;
    });

    if (type == RegisterType.donor) {
      Navigator.pushNamed(context, AppRoutes.registerDonor);
    } else if (type == RegisterType.beneficiary) {
      Navigator.pushNamed(context, AppRoutes.registerBeneficiary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
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
                content: Text(localizations.loginSuccess(user.firstName)),
                behavior: SnackBarBehavior.floating,
              ),
            );

            if (user.isDonor) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.donorHome,
                (route) => false,
              );
            } else if (user.isBeneficiary) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.beneficiaryHome,
                (route) => false,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.unexpectedError),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        },
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final metrics = _LoginLayoutMetrics.from(
                constraints,
                MediaQuery.of(context).viewInsets.bottom > 0,
              );

              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: metrics.contentWidth,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: metrics.topGap),

                          Image.asset(
                            'assets/img/logo_isolated.svg.png',
                            height: metrics.logoSize,
                            width: metrics.logoSize,
                          ),

                          SizedBox(height: metrics.logoTitleGap),

                          Text(
                            localizations.associationName,
                            style: TextStyle(
                              fontSize: metrics.associationFontSize,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),

                          SizedBox(height: metrics.beforeFormGap),

                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(
                              metrics.horizontalPadding,
                              metrics.formTopPadding,
                              metrics.horizontalPadding,
                              metrics.formBottomPadding,
                            ),
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
                                    localizations.login,
                                    style: TextStyle(
                                      fontSize: metrics.titleFontSize,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  SizedBox(height: metrics.titleBottomGap),

                                  CustomTextField(
                                    labelText: localizations.phoneNumber,
                                    hintText: 'xxxxxxxxx',
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    contentPadding: metrics.fieldContentPadding,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    prefixWidget: InkWell(
                                      onTap: _selectCountry,
                                      child: Container(
                                        width: metrics.countryPickerWidth,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          border: BorderDirectional(
                                            end: BorderSide(
                                              color: Color(0xFFE7D9A8),
                                            ),
                                          ),
                                        ),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                selectedCountryFlag,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                selectedCountryCode,
                                                textDirection:
                                                    TextDirection.ltr,
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
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return localizations.phoneRequired;
                                      }

                                      if (value.trim().length < 8) {
                                        return localizations.invalidPhoneNumber;
                                      }

                                      return null;
                                    },
                                  ),

                                  SizedBox(height: metrics.fieldGap),

                                  CustomTextField(
                                    labelText: localizations.password,
                                    hintText: '••••••••',
                                    controller: _passwordController,
                                    isPassword: true,
                                    contentPadding: metrics.fieldContentPadding,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return localizations.passwordRequired;
                                      }
                                      return null;
                                    },
                                  ),

                                  Align(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.forgotPassword,
                                        );
                                      },
                                      child: Text(
                                        localizations.forgotPassword,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height: metrics.forgotButtonBottomGap,
                                  ),

                                  BlocBuilder<LoginCubit, LoginState>(
                                    builder: (context, state) {
                                      final isLoading = state is LoginLoading;

                                      return SizedBox(
                                        width: double.infinity,
                                        height: metrics.buttonHeight,
                                        child: ElevatedButton(
                                          onPressed: isLoading
                                              ? null
                                              : _onLoginPressed,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.primary,
                                            foregroundColor: Colors.white,
                                            disabledBackgroundColor: AppColors
                                                .primary
                                                .withValues(alpha: 0.6),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            elevation: 3,
                                          ),
                                          child: isLoading
                                              ? const SizedBox(
                                                  width: 22,
                                                  height: 22,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                )
                                              : Text(
                                                  localizations.login,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: metrics.fieldGap),

                                  _RegisterDropdownButton(
                                    selectedType: selectedRegisterType,
                                    localizations: localizations,
                                    compact: metrics.compactHeight,
                                    onChanged: (type) {
                                      if (type != null) {
                                        _onRegisterTypeSelected(type);
                                      }
                                    },
                                  ),

                                  SizedBox(height: metrics.sectionGap),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.18,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                        ),
                                        child: Text(
                                          localizations.or,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: metrics.sectionGap),

                                  SizedBox(
                                    width: double.infinity,
                                    height: metrics.buttonHeight,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          AppRoutes.donorHome,
                                          (route) => false,
                                          arguments:
                                              const DonorHomeRouteArguments(
                                                isGuest: true,
                                              ),
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.primary,
                                        side: BorderSide(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.25,
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        localizations.continueAsGuest,
                                        style: TextStyle(
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
              );
            },
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
          labelText: AppLocalizations.of(context).search,
          hintText: AppLocalizations.of(context).countrySearchHint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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

class _LoginLayoutMetrics {
  const _LoginLayoutMetrics({
    required this.compactHeight,
    required this.contentWidth,
    required this.logoSize,
    required this.topGap,
    required this.logoTitleGap,
    required this.associationFontSize,
    required this.beforeFormGap,
    required this.horizontalPadding,
    required this.formTopPadding,
    required this.formBottomPadding,
    required this.titleFontSize,
    required this.titleBottomGap,
    required this.fieldGap,
    required this.forgotButtonBottomGap,
    required this.sectionGap,
    required this.buttonHeight,
    required this.fieldContentPadding,
    required this.countryPickerWidth,
  });

  factory _LoginLayoutMetrics.from(
    BoxConstraints constraints,
    bool keyboardOpen,
  ) {
    final availableHeight = constraints.maxHeight;
    final compactHeight = availableHeight < 700 || keyboardOpen;
    final veryCompactHeight = availableHeight < 620 || keyboardOpen;

    return _LoginLayoutMetrics(
      compactHeight: compactHeight,
      contentWidth: constraints.maxWidth > 560 ? 480.0 : constraints.maxWidth,
      logoSize: (availableHeight * 0.12).clamp(64.0, 92.0).toDouble(),
      topGap: (availableHeight * 0.045).clamp(16.0, 34.0).toDouble(),
      logoTitleGap: compactHeight ? 6.0 : 10.0,
      associationFontSize: compactHeight ? 20.0 : 22.0,
      beforeFormGap: (availableHeight * 0.04).clamp(18.0, 40.0).toDouble(),
      horizontalPadding: constraints.maxWidth < 360 ? 18.0 : 22.0,
      formTopPadding: (availableHeight * 0.06).clamp(24.0, 49.0).toDouble(),
      formBottomPadding: (availableHeight * 0.04).clamp(20.0, 32.0).toDouble(),
      titleFontSize: compactHeight ? 22.0 : 24.0,
      titleBottomGap: (availableHeight * 0.035).clamp(16.0, 26.0).toDouble(),
      fieldGap: compactHeight ? 8.0 : 10.0,
      forgotButtonBottomGap: compactHeight ? 2.0 : 6.0,
      sectionGap: (availableHeight * 0.025).clamp(12.0, 24.0).toDouble(),
      buttonHeight: compactHeight ? 42.0 : 46.0,
      fieldContentPadding: EdgeInsets.symmetric(
        horizontal: 14,
        vertical: veryCompactHeight ? 10 : 12,
      ),
      countryPickerWidth: constraints.maxWidth < 360 ? 94.0 : 105.0,
    );
  }

  final bool compactHeight;
  final double contentWidth;
  final double logoSize;
  final double topGap;
  final double logoTitleGap;
  final double associationFontSize;
  final double beforeFormGap;
  final double horizontalPadding;
  final double formTopPadding;
  final double formBottomPadding;
  final double titleFontSize;
  final double titleBottomGap;
  final double fieldGap;
  final double forgotButtonBottomGap;
  final double sectionGap;
  final double buttonHeight;
  final EdgeInsetsGeometry fieldContentPadding;
  final double countryPickerWidth;
}

class _RegisterDropdownButton extends StatelessWidget {
  const _RegisterDropdownButton({
    required this.selectedType,
    required this.onChanged,
    required this.localizations,
    required this.compact,
  });

  final RegisterType? selectedType;
  final ValueChanged<RegisterType?> onChanged;
  final AppLocalizations localizations;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<RegisterType>(
      initialValue: selectedType,
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: compact ? 9 : 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.25),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      hint: Center(
        child: Text(
          localizations.createNewAccount,
          style: TextStyle(fontSize: 14, color: AppColors.primary),
        ),
      ),
      items: [
        DropdownMenuItem(
          value: RegisterType.donor,
          child: Text(
            localizations.createDonorAccount,
            style: TextStyle(color: AppColors.primary),
          ),
        ),
        DropdownMenuItem(
          value: RegisterType.beneficiary,
          child: Text(
            localizations.createBeneficiaryAccount,
            style: TextStyle(color: AppColors.primary),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
