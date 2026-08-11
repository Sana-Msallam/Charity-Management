import 'package:charity_management/features/auth/forgot_password/cubit/forgot_password_cubit.dart';
import 'package:charity_management/features/auth/forgot_password/cubit/forgot_password_state.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/widgets/custom_text_fields.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void requestOtp() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final String phoneNumber = phoneController.text.trim().replaceAll(' ', '');

    context.read<ForgotPasswordCubit>().requestOtp(
      phoneNumber: phoneNumber,
      localizations: AppLocalizations.of(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFFFF8E6);
    final localizations = AppLocalizations.of(context);

    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordOtpSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.pushNamed(
            context,
            AppRoutes.newPassword,
            arguments: context.read<ForgotPasswordCubit>(),
          );
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
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          localizations.forgotPasswordTitle,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 55),

                    const Icon(
                      Icons.lock_reset_rounded,
                      size: 85,
                      color: AppColors.primary,
                    ),

                    const SizedBox(height: 25),

                    Text(
                      localizations.forgotPasswordDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 30),

                    CustomTextField(
                      labelText: localizations.phoneNumber,
                      hintText: '+963934206455',
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                        LengthLimitingTextInputFormatter(16),
                      ],
                      validator: (value) {
                        final String phone =
                            value?.trim().replaceAll(' ', '') ?? '';

                        if (phone.isEmpty) {
                          return localizations.phoneWithCountryRequired;
                        }

                        if (!phone.startsWith('+')) {
                          return localizations.countryCodeRequired;
                        }

                        if (!RegExp(r'^\+\d{8,15}$').hasMatch(phone)) {
                          return localizations.invalidFullPhoneNumber;
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 35),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : requestOtp,
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
                                Icons.send_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                        label: Text(
                          isLoading
                              ? localizations.sendingCode
                              : localizations.sendVerificationCode,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.primary.withValues(
                            alpha: 0.6,
                          ),
                          elevation: 8,
                          shadowColor: AppColors.primary.withValues(
                            alpha: 0.35,
                          ),
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
