
import 'package:charity_management/Donor/Profile/Cubit/profile_cubit.dart';
import 'package:charity_management/Donor/Profile/Cubit/profile_state.dart';
import 'package:charity_management/features/language/cubit/language_cubit.dart';
import 'package:charity_management/features/language/cubit/language_state.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/Donor/Profile/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:charity_management/features/auth/services/auth_service.dart';
import 'package:charity_management/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color primary = Color(0xFF765A00);
  static const Color gold = Color(0xFFF5C84C);
  static const Color darkText = Color(0xFF292B3A);
  static const Color grayText = Color(0xFF817B76);
  static const Color green = Color(0xFF3D523A);
  static const Color background = Color(0xFFF9F7F2);
  static const Color softGold = Color(0xFFFFF4D5);
  static const Color softGreen = Color(0xFFEAF1E8);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Directionality(
      textDirection: Directionality.of(context),
      child: Scaffold(
        backgroundColor: background,

        appBar: AppBar(
          backgroundColor: background,
          elevation: 0,
          centerTitle: true,
          title: Text(
            l10n.profileTitle,
            style: const TextStyle(
              color: primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
          iconTheme: const IconThemeData(
            color: primary,
          ),
        ),

        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primary,
                ),
              );
            }

            if (state is ProfileErrorState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    state.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: darkText,
                      fontFamily: 'IBM Plex Sans Arabic',
                    ),
                  ),
                ),
              );
            }

            if (state is ProfileSuccessState) {
              final profile = state.profile;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  children: [
                    _buildProfileHeader(
                      profile,
                      l10n,
                    ),

                    const SizedBox(height: 26),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [
                          _buildSectionTitle(
                            l10n.personalInformation,
                            Icons.person_outline_rounded,
                          ),

                          const SizedBox(height: 12),

                          _buildInfoGrid(
                            profile,
                            l10n,
                          ),

                          const SizedBox(height: 25),

                          _buildSectionTitle(
                            l10n.myAccount,
                            Icons.dashboard_outlined,
                          ),

                          const SizedBox(height: 12),

                          _buildDonationsButton(l10n),

                          const SizedBox(height: 12),

                          _buildSettingsButton(
                            context,
                            l10n,
                          ),

                          const SizedBox(height: 20),

                          _buildLogoutButton(
                            context,
                            l10n,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    ProfileModel profile,
    AppLocalizations l10n,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        25,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFF4D5),
            Color(0xFFFDFBF7),
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 122,
            height: 122,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: gold,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipOval(
              child: profile.personalPhoto != null &&
                      profile.personalPhoto!.isNotEmpty
                  ? Image.network(
                      'http://192.168.1.14:3000/${profile.personalPhoto}',
                      fit: BoxFit.cover,
                      errorBuilder: (
                        context,
                        error,
                        stackTrace,
                      ) {
                        return _defaultProfileIcon();
                      },
                    )
                  : _defaultProfileIcon(),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            profile.fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: darkText,
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.18),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.volunteer_activism_rounded,
                  size: 16,
                  color: Colors.white,
                ),

                const SizedBox(width: 6),

                Text(
                  l10n.donor,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _defaultProfileIcon() {
    return Container(
      color: softGold,
      child: const Icon(
        Icons.person_rounded,
        size: 65,
        color: primary,
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: softGold,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: primary,
            size: 20,
          ),
        ),

        const SizedBox(width: 10),

        Text(
          title,
          style: const TextStyle(
            color: darkText,
            fontSize: 17,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
      ],
    );
  }

  Widget _buildInfoGrid(
    ProfileModel profile,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSmallInfoCard(
                icon: Icons.cake_outlined,
                title: l10n.age,
                value: l10n.ageWithYears(profile.age),
                color: const Color(0xFFFFEED1),
                iconColor: const Color(0xFFB56B00),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _buildSmallInfoCard(
                icon: Icons.wc_outlined,
                title: l10n.gender,
                value: profile.gender == 'MALE'
                    ? l10n.male
                    : l10n.female,
                color: softGreen,
                iconColor: green,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        _buildInfoCard(
          icon: Icons.phone_outlined,
          title: l10n.phoneNumber,
          value: profile.number,
          color: const Color(0xFFEAF1FF),
          iconColor: const Color(0xFF4567A8),
          l10n: l10n,
        ),

        _buildInfoCard(
          icon: Icons.favorite_border_rounded,
          title: l10n.socialStatus,
          value: _getSocialStatus(
            profile.socialStatus,
            l10n,
          ),
          color: const Color(0xFFFFE9ED),
          iconColor: const Color(0xFFB84D64),
          l10n: l10n,
        ),

        _buildInfoCard(
          icon: Icons.location_on_outlined,
          title: l10n.address,
          value: _formatAddress(
            profile.address,
            l10n,
          ),
          color: const Color(0xFFE8F4EF),
          iconColor: const Color(0xFF39785C),
          l10n: l10n,
        ),

        _buildInfoCard(
          icon: Icons.work_outline_rounded,
          title: l10n.workStatus,
          value: profile.isUnemployed
              ? l10n.unemployedStatus
              : l10n.employedStatus,
          color: const Color(0xFFF0E9FF),
          iconColor: const Color(0xFF7453A6),
          l10n: l10n,
        ),
      ],
    );
  }

  Widget _buildSmallInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(
              color: grayText,
              fontSize: 11,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),

          const SizedBox(height: 3),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: darkText,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'IBM Plex Sans Arabic',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color iconColor,
    required AppLocalizations l10n,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 21,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: grayText,
                    fontSize: 11,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value.isEmpty ? l10n.unspecified : value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: darkText,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonationsButton(
    AppLocalizations l10n,
  ) {
    return _buildMainAction(
      icon: Icons.volunteer_activism_rounded,
      title: l10n.myDonations,
      subtitle: l10n.followDonations,
      background: primary,
      iconBackground: Colors.white.withOpacity(0.15),
      iconColor: Colors.white,
      textColor: Colors.white,
      subtitleColor: Colors.white.withOpacity(0.75),
      arrowColor: Colors.white,
      onTap: () {
        // TODO: Navigate to My Donations
      },
    );
  }

  Widget _buildSettingsButton(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return _buildMainAction(
      icon: Icons.settings_outlined,
      title: l10n.settings,
      subtitle: l10n.languageAndAppearance,
      background: Colors.white,
      iconBackground: softGold,
      iconColor: primary,
      textColor: darkText,
      subtitleColor: grayText,
      arrowColor: primary,
      border: true,
      onTap: () {
        _showSettingsBottomSheet(
          context,
          l10n,
        );
      },
    );
  }

  Widget _buildMainAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color background,
    required Color iconBackground,
    required Color iconColor,
    required Color textColor,
    required Color subtitleColor,
    required Color arrowColor,
    required VoidCallback onTap,
    bool border = false,
  }) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: border
                ? Border.all(
                    color: Colors.black.withOpacity(0.06),
                  )
                : null,
            boxShadow: border
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.025),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Sans Arabic',
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 11,
                        fontFamily: 'IBM Plex Sans Arabic',
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.arrow_forward_ios_rounded,
                color: arrowColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () {
          _showLogoutDialog(
            context,
            l10n,
          );
        },
        icon: Icon(
          Icons.logout_rounded,
          size: 20,
          color: Colors.red.shade700,
        ),
        label: Text(
          l10n.logout,
          style: TextStyle(
            color: Colors.red.shade700,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.red.shade50,
          side: BorderSide(
            color: Colors.red.shade100,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  void _showSettingsBottomSheet(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: Directionality.of(context),
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              28,
            ),
            decoration: const BoxDecoration(
              color: background,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 22),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    l10n.settings,
                    style: const TextStyle(
                      color: darkText,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'IBM Plex Sans Arabic',
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                BlocBuilder<LanguageCubit, LanguageState>(
                  builder: (context, state) {
                    final isArabic =
                        state.locale.languageCode == 'ar';

                    return _buildSettingsItem(
                      icon: Icons.language_rounded,
                      title: l10n.language,
                      subtitle: isArabic
                          ? l10n.arabic
                          : l10n.english,
                      onTap: () {
                        context
                            .read<LanguageCubit>()
                            .toggleLanguage();
                      },
                    );
                  },
                ),

                _buildSettingsItem(
                  icon: Icons.dark_mode_outlined,
                  title: l10n.darkMode,
                  subtitle: l10n.changeAppAppearance,
                  trailing: Switch(
                    value: Theme.of(context).brightness ==
                        Brightness.dark,
                    activeColor: primary,
                    onChanged: (value) {
                      // TODO: Theme
                    },
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.black.withOpacity(0.05),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 4,
        ),
        leading: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: softGold,
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: primary,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: darkText,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: grayText,
            fontSize: 11,
            fontFamily: 'IBM Plex Sans Arabic',
          ),
        ),
        trailing: trailing,
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: Directionality.of(context),
              child: AlertDialog(
                backgroundColor: background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                title: Text(
                  l10n.logout,
                  style: const TextStyle(
                    color: darkText,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
                content: Text(
                  isLoading
                      ? l10n.loggingOut
                      : l10n.logoutConfirmation,
                  style: const TextStyle(
                    color: grayText,
                    fontFamily: 'IBM Plex Sans Arabic',
                  ),
                ),
                actions: [
                  if (!isLoading)
                    TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      child: Text(
                        l10n.cancel,
                        style: const TextStyle(
                          color: grayText,
                          fontFamily: 'IBM Plex Sans Arabic',
                        ),
                      ),
                    ),

                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              await AuthService().logout();

                              if (!context.mounted) return;

                              Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                AppRoutes.authGate,
                                (route) => false,
                              );
                            } catch (_) {
                              if (!context.mounted) return;

                              setState(() {
                                isLoading = false;
                              });

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.logoutError,
                                    style: const TextStyle(
                                      fontFamily:
                                          'IBM Plex Sans Arabic',
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                    child: Text(
                      l10n.logout,
                      style: TextStyle(
                        color: isLoading
                            ? Colors.grey
                            : Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'IBM Plex Sans Arabic',
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _getSocialStatus(
    String status,
    AppLocalizations l10n,
  ) {
    switch (status.toUpperCase()) {
      case 'SINGLE':
        return l10n.single;

      case 'MARRIED':
        return l10n.married;

      case 'DIVORCED':
        return l10n.divorced;

      case 'WIDOWED':
        return l10n.widowed;

      default:
        return status.isEmpty
            ? l10n.unspecified
            : status;
    }
  }

  String _formatAddress(
    Map<String, dynamic> address,
    AppLocalizations l10n,
  ) {
    if (address.isEmpty) {
      return l10n.unspecified;
    }

    final parts = <String>[];

    for (final entry in address.entries) {
      final value = entry.value;

      if (value != null &&
          value.toString().trim().isNotEmpty) {
        parts.add(value.toString());
      }
    }

    return parts.isEmpty
        ? l10n.unspecified
        : parts.join('، ');
  }
}
