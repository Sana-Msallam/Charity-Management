import 'package:charity_management/features/Beneficiary/change_password/cubit/change_password_cubit.dart';
import 'package:charity_management/features/Beneficiary/change_password/screen/change_password_screen.dart';
import 'package:charity_management/features/Beneficiary/change_password/service/change_password_service.dart';
import 'package:charity_management/features/auth/services/auth_service.dart';
import 'package:charity_management/features/language/cubit/language_cubit.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/routes/app_routes.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String currentLanguage =
        context
            .watch<LanguageCubit>()
            .state
            .locale
            .languageCode;

    debugPrint(
      'SettingsPage language: $currentLanguage',
    );

    return Scaffold(
      backgroundColor: AppColors.background,

      // ==========================================
      // APP BAR
      // ==========================================

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          l10n.settings,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: AppTextStyles.fontFamily,
          ),
        ),
      ),

      // ==========================================
      // BODY
      // ==========================================

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            16,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              // ======================================
              // APP PREFERENCES
              // ======================================

              Text(
                l10n.appPreferences,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily:
                      AppTextStyles.fontFamily,
                ),
              ),

              const SizedBox(height: 14),

              // ======================================
              // LANGUAGE
              // ======================================

              _buildSettingCard(
                icon: Icons.language_rounded,
                title: l10n.language,
                subtitle: currentLanguage == 'ar'
                    ? '${l10n.changeAppLanguage} · ${l10n.arabic}'
                    : '${l10n.changeAppLanguage} · ${l10n.english}',
                onTap: () {
                  _showLanguageDialog(
                    context,
                  );
                },
              ),

              const SizedBox(height: 14),

              // ======================================
              // APPEARANCE
              // ======================================

              _buildSettingCard(
                icon: Icons.dark_mode_outlined,
                title: l10n.appearance,
                subtitle:
                    l10n.changeAppAppearance,
                onTap: () {
                  // لاحقاً نربط الوضع الداكن
                },
              ),

              const SizedBox(height: 28),

              // ======================================
              // ACCOUNT
              // ======================================

              Text(
                l10n.accountSection,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily:
                      AppTextStyles.fontFamily,
                ),
              ),

              const SizedBox(height: 14),

              // ======================================
              // CHANGE PASSWORD
              // ======================================

              _buildSettingCard(
                icon: Icons.lock_outline_rounded,
                title: l10n.changePassword,
                subtitle:
                    l10n.changePasswordSubtitle,
                onTap: () {
                  _openChangePassword(
                    context,
                  );
                },
              ),

              const SizedBox(height: 14),

              // ======================================
              // LOGOUT
              // ======================================

              _buildLogoutCard(
                title: l10n.logout,
                subtitle:
                    l10n.logoutSubtitle,
                onTap: () {
                  _confirmLogout(
                    context,
                  );
                },
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar:
          const CustomBottomNavigation(
        currentIndex: 3,
      ),
    );
  }

  // ============================================
  // LANGUAGE DIALOG
  // ============================================

  Future<void> _showLanguageDialog(
    BuildContext context,
  ) async {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final LanguageCubit languageCubit =
        context.read<LanguageCubit>();

    final String currentLanguage =
        languageCubit
            .state
            .locale
            .languageCode;

    final String? selectedLanguage =
        await showDialog<String>(
      context: context,
      builder: (
        BuildContext dialogContext,
      ) {
        return AlertDialog(
          backgroundColor:
              AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          // ======================================
          // TITLE
          // ======================================

          title: Row(
            children: [
              const Icon(
                Icons.language_rounded,
                color: AppColors.primary,
                size: 25,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  l10n.chooseLanguage,
                  style: const TextStyle(
                    color:
                        AppColors.onSurface,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                    fontFamily:
                        AppTextStyles
                            .fontFamily,
                  ),
                ),
              ),
            ],
          ),

          // ======================================
          // LANGUAGES
          // ======================================

          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context: dialogContext,
                title: l10n.arabic,
                languageCode: 'ar',
                currentLanguage:
                    currentLanguage,
              ),

              const SizedBox(height: 8),

              _buildLanguageOption(
                context: dialogContext,
                title: l10n.english,
                languageCode: 'en',
                currentLanguage:
                    currentLanguage,
              ),
            ],
          ),

          // ======================================
          // CANCEL
          // ======================================

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop();
              },
              child: Text(
                l10n.cancel,
                style: const TextStyle(
                  color:
                      AppColors.brandGray,
                  fontWeight:
                      FontWeight.bold,
                  fontFamily:
                      AppTextStyles
                          .fontFamily,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (selectedLanguage == null) {
      return;
    }

    if (selectedLanguage ==
        currentLanguage) {
      return;
    }

    debugPrint(
      '======================================',
    );

    debugPrint(
      'Changing app language',
    );

    debugPrint(
      'From: $currentLanguage',
    );

    debugPrint(
      'To: $selectedLanguage',
    );

    debugPrint(
      '======================================',
    );

    await languageCubit.changeLanguage(
      selectedLanguage,
    );
  }

  // ============================================
  // LANGUAGE OPTION
  // ============================================

  Widget _buildLanguageOption({
    required BuildContext context,
    required String title,
    required String languageCode,
    required String currentLanguage,
  }) {
    final bool isSelected =
        languageCode ==
            currentLanguage;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(
            languageCode,
          );
        },
        borderRadius:
            BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors
                    .primaryContainer
                    .withOpacity(0.45)
                : Colors.transparent,
            borderRadius:
                BorderRadius.circular(
              14,
            ),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.brandGray
                      .withOpacity(0.18),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration:
                    BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.primary
                      : Colors
                          .transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors
                            .brandGray,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 15,
                      )
                    : null,
              ),

              const SizedBox(width: 12),

              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors
                          .onSurface,
                  fontSize: 15,
                  fontWeight:
                      isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                  fontFamily:
                      AppTextStyles
                          .fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================
  // CHANGE PASSWORD
  // ============================================

  Future<void> _openChangePassword(
    BuildContext context,
  ) async {
    final String? successMessage =
        await Navigator.of(context)
            .push<String>(
      MaterialPageRoute<String>(
        builder: (_) {
          return BlocProvider<
              ChangePasswordCubit>(
            create: (_) =>
                ChangePasswordCubit(
              ChangePasswordService(),
            ),
            child:
                const ChangePasswordScreen(),
          );
        },
      ),
    );

    if (!context.mounted ||
        successMessage == null) {
      return;
    }

    final String message =
        successMessage.trim();

    if (message.isEmpty) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor:
              Colors.green,
        ),
      );
  }

  // ============================================
  // CONFIRM LOGOUT
  // ============================================

  Future<void> _confirmLogout(
    BuildContext context,
  ) async {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final bool? shouldLogout =
        await showDialog<bool>(
      context: context,
      builder: (
        BuildContext dialogContext,
      ) {
        return AlertDialog(
          backgroundColor:
              AppColors.surface,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              20,
            ),
          ),

          title: Row(
            children: [
              const Icon(
                Icons.logout_rounded,
                color: AppColors.error,
                size: 26,
              ),

              const SizedBox(width: 10),

              Text(
                l10n.logout,
                style: const TextStyle(
                  color:
                      AppColors.onSurface,
                  fontSize: 19,
                  fontWeight:
                      FontWeight.bold,
                  fontFamily:
                      AppTextStyles
                          .fontFamily,
                ),
              ),
            ],
          ),

          content: Text(
            l10n.logoutConfirmation,
            style: const TextStyle(
              color:
                  AppColors.brandGray,
              fontSize: 15,
              fontFamily:
                  AppTextStyles
                      .fontFamily,
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(false);
              },
              child: Text(
                l10n.cancel,
                style: const TextStyle(
                  color:
                      AppColors.brandGray,
                  fontWeight:
                      FontWeight.bold,
                  fontFamily:
                      AppTextStyles
                          .fontFamily,
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(
                  dialogContext,
                ).pop(true);
              },
              child: Text(
                l10n.logout,
                style: const TextStyle(
                  color:
                      AppColors.error,
                  fontWeight:
                      FontWeight.bold,
                  fontFamily:
                      AppTextStyles
                          .fontFamily,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    await _logout(context);
  }

  // ============================================
  // LOGOUT
  // ============================================

  Future<void> _logout(
    BuildContext context,
  ) async {
    _showLogoutLoading(
      context,
    );

    try {
      await AuthService().logout();
    } catch (
      error,
      stackTrace
    ) {
      debugPrint(
        'Logout request error: $error',
      );

      debugPrint(
        'Logout stack trace: '
        '$stackTrace',
      );
    }

    if (!context.mounted) {
      return;
    }

    Navigator.of(
      context,
      rootNavigator: true,
    ).pop();

    if (!context.mounted) {
      return;
    }

    Navigator.of(context)
        .pushNamedAndRemoveUntil(
      AppRoutes.authGate,
      (route) => false,
    );
  }

  // ============================================
  // LOGOUT LOADING
  // ============================================

  void _showLogoutLoading(
    BuildContext context,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return const PopScope(
          canPop: false,
          child: Center(
            child:
                CircularProgressIndicator(
              color:
                  AppColors.primary,
            ),
          ),
        );
      },
    );
  }

  // ============================================
  // SETTING CARD
  // ============================================

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(
              18,
            ),
            border: Border.all(
              color: AppColors
                  .brandGray
                  .withOpacity(0.12),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(0.025),
                blurRadius: 12,
                offset:
                    const Offset(
                  0,
                  4,
                ),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration:
                    BoxDecoration(
                  color: AppColors
                      .primaryContainer
                      .withOpacity(0.3),
                  borderRadius:
                      BorderRadius
                          .circular(14),
                ),
                child: Icon(
                  icon,
                  color:
                      AppColors.primary,
                  size: 25,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(
                        color: AppColors
                            .onSurface,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                        fontFamily:
                            AppTextStyles
                                .fontFamily,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors
                            .brandGray
                            .withOpacity(
                              0.85,
                            ),
                        fontSize: 13,
                        fontFamily:
                            AppTextStyles
                                .fontFamily,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons
                    .chevron_left_rounded,
                color:
                    AppColors.brandGray,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================
  // LOGOUT CARD
  // ============================================

  Widget _buildLogoutCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: AppColors.error
                .withOpacity(0.05),
            borderRadius:
                BorderRadius.circular(
              18,
            ),
            border: Border.all(
              color: AppColors.error
                  .withOpacity(0.15),
              width: 1.1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration:
                    BoxDecoration(
                  color: AppColors.error
                      .withOpacity(0.10),
                  borderRadius:
                      BorderRadius
                          .circular(14),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                  size: 25,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      title,
                      style:
                          const TextStyle(
                        color:
                            AppColors.error,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                        fontFamily:
                            AppTextStyles
                                .fontFamily,
                      ),
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      subtitle,
                      style:
                          const TextStyle(
                        color: AppColors
                            .brandGray,
                        fontSize: 13,
                        fontFamily:
                            AppTextStyles
                                .fontFamily,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Icon(
                Icons
                    .chevron_left_rounded,
                color: AppColors.error,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}