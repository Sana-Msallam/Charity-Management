import 'package:charity_management/features/auth/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:charity_management/features/auth/forgot_password/cubit/forgot_password_state.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/widgets/custom_text_fields.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController otpController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void saveNewPassword() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    context.read<ForgotPasswordCubit>().resetPassword(
      code: otpController.text.trim(),
      newPassword: passwordController.text.trim(),
      localizations: AppLocalizations.of(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFFFF8E6);
    const Color buttonColor = AppColors.primary;
    final localizations = AppLocalizations.of(context);

    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordResetSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.of(context).popUntil((route) => route.isFirst);
        }

        if (state is ForgotPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final bool isLoading = state is ForgotPasswordLoading;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                  const SizedBox(height: 14),

                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: IconButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    Navigator.pop(context);
                                  },
                            icon: const Icon(Icons.arrow_back),
                            color: buttonColor,
                          ),
                        ),
                        Text(
                          localizations.resetPassword,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    CustomTextField(
                      labelText: localizations.verificationCode,
                      hintText: localizations.verificationCodeHint,
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      validator: (value) {
                        final String code = value?.trim() ?? '';

                        if (code.isEmpty) {
                          return localizations.verificationCodeRequired;
                        }

                        if (code.length < 4) {
                          return localizations.invalidVerificationCode;
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    CustomTextField(
                      labelText: localizations.newPassword,
                      hintText: '********',
                      controller: passwordController,
                      isPassword: true,
                      validator: (value) {
                        final String password = value ?? '';

                        if (password.trim().isEmpty) {
                          return localizations.newPasswordRequired;
                        }

                        if (password.length < 6) {
                          return localizations.passwordMin6;
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 18),

                    CustomTextField(
                      labelText: localizations.confirmNewPassword,
                      hintText: '********',
                      controller: confirmPasswordController,
                      isPassword: true,
                      validator: (value) {
                        final String confirmPassword = value ?? '';

                        if (confirmPassword.trim().isEmpty) {
                          return localizations.confirmPasswordRequired;
                        }

                        if (confirmPassword != passwordController.text) {
                          return localizations.passwordsDoNotMatch;
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 38),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : saveNewPassword,
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.check_circle,
                                size: 20,
                                color: Colors.white,
                              ),
                        label: Text(
                          isLoading
                              ? localizations.changingPassword
                              : localizations.changePassword,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          disabledBackgroundColor: buttonColor.withValues(
                            alpha: 0.6,
                          ),
                          elevation: 8,
                          shadowColor: buttonColor.withValues(alpha: 0.35),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
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
    );
  }
}
