import 'package:charity_management/features/Beneficiary/change_password/cubit/change_password_cubit.dart';
import 'package:charity_management/features/Beneficiary/change_password/cubit/change_password_state.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/widgets/custom_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({
    super.key,
  });

  @override
  State<ChangePasswordScreen> createState() {
    return _ChangePasswordScreenState();
  }
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  final TextEditingController
      _currentPasswordController =
      TextEditingController();

  final TextEditingController
      _newPasswordController =
      TextEditingController();

  final TextEditingController
      _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ??
        false)) {
      return;
    }

    context
        .read<ChangePasswordCubit>()
        .changePassword(
          currentPassword:
              _currentPasswordController.text,
          newPassword:
              _newPasswordController.text,
          confirmPassword:
              _confirmPasswordController.text,
          localizations:
              AppLocalizations.of(context),
        );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations =
        AppLocalizations.of(context);

    return BlocConsumer<
        ChangePasswordCubit,
        ChangePasswordState>(
      listener: (
        BuildContext context,
        ChangePasswordState state,
      ) {
        if (state is ChangePasswordSuccess) {
          _currentPasswordController.clear();
          _newPasswordController.clear();
          _confirmPasswordController.clear();

          Navigator.of(context).pop(
            state.message,
          );
        } else if (state
            is ChangePasswordFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
                backgroundColor:
                    AppColors.error,
              ),
            );
        }
      },
      builder: (
        BuildContext context,
        ChangePasswordState state,
      ) {
        final bool isLoading =
            state is ChangePasswordLoading;

        return Scaffold(
          backgroundColor:
              AppColors.background,

          // ==========================================
          // APP BAR
          // ==========================================

          appBar: AppBar(
            backgroundColor:
                AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            title: Text(
              localizations.changePassword,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily:
                    AppTextStyles.fontFamily,
              ),
            ),
          ),

          // ==========================================
          // BODY
          // ==========================================

          body: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                32,
              ),
              child: Form(
                key: _formKey,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.all(
                    20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(
                      22,
                    ),
                    border: Border.all(
                      color: AppColors.brandGray
                          .withOpacity(
                        0.12,
                      ),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(
                          0.025,
                        ),
                        blurRadius: 12,
                        offset:
                            const Offset(
                          0,
                          4,
                        ),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .stretch,
                    children: <Widget>[
                      // ==================================
                      // ICON
                      // ==================================

                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          color: AppColors
                              .primaryContainer
                              .withOpacity(
                            0.3,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons
                              .lock_outline_rounded,
                          color:
                              AppColors.primary,
                          size: 30,
                        ),
                      ),

                      const SizedBox(
                        height: 22,
                      ),

                      // ==================================
                      // CURRENT PASSWORD
                      // ==================================

                      CustomTextField(
                        labelText:
                            localizations
                                .currentPassword,
                        hintText: '********',
                        controller:
                            _currentPasswordController,
                        isPassword: true,
                        enabled: !isLoading,
                        validator: (
                          String? value,
                        ) {
                          if (value == null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return localizations
                                .currentPasswordRequired;
                          }

                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // ==================================
                      // NEW PASSWORD
                      // ==================================

                      CustomTextField(
                        labelText:
                            localizations
                                .newPassword,
                        hintText: '********',
                        controller:
                            _newPasswordController,
                        isPassword: true,
                        enabled: !isLoading,
                        validator: (
                          String? value,
                        ) {
                          if (value == null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return localizations
                                .newPasswordRequired;
                          }

                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 18,
                      ),

                      // ==================================
                      // CONFIRM PASSWORD
                      // ==================================

                      CustomTextField(
                        labelText:
                            localizations
                                .confirmNewPassword,
                        hintText: '********',
                        controller:
                            _confirmPasswordController,
                        isPassword: true,
                        enabled: !isLoading,
                        validator: (
                          String? value,
                        ) {
                          if (value == null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return localizations
                                .confirmPasswordRequired;
                          }

                          if (value !=
                              _newPasswordController
                                  .text) {
                            return localizations
                                .passwordsDoNotMatch;
                          }

                          return null;
                        },
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      // ==================================
                      // BUTTON
                      // ==================================

                      SizedBox(
                        height: 50,
                        child:
                            ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : _submit,
                          style:
                              ElevatedButton
                                  .styleFrom(
                            backgroundColor:
                                AppColors.primary,
                            foregroundColor:
                                Colors.white,
                            disabledBackgroundColor:
                                AppColors.primary
                                    .withValues(
                              alpha: 0.6,
                            ),
                            elevation: 0,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                12,
                              ),
                            ),
                          ),
                          icon: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(
                                    strokeWidth:
                                        2,
                                    color: Colors
                                        .white,
                                  ),
                                )
                              : const Icon(
                                  Icons
                                      .save_outlined,
                                ),
                          label: Text(
                            isLoading
                                ? localizations
                                    .changingPassword
                                : localizations
                                    .changePassword,
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                              fontFamily:
                                  AppTextStyles
                                      .fontFamily,
                            ),
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
      },
    );
  }
}