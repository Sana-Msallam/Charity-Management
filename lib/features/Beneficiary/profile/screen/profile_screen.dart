import 'package:cached_network_image/cached_network_image.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/features/Beneficiary/profile/cubit/profile_cubit.dart';
import 'package:charity_management/features/Beneficiary/profile/cubit/profile_state.dart';
import 'package:charity_management/features/Beneficiary/profile/model/profile_model.dart';
import 'package:charity_management/features/Beneficiary/profile/screen/edit_profile_screen.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/widgets/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    debugPrint('======================================');
    debugPrint('ProfilePage opened');
    debugPrint('======================================');

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (!mounted) {
          return;
        }

        context
            .read<ProfileCubit>()
            .loadProfile(
              localizations:
                  AppLocalizations.of(context),
            );
      },
    );
  }

  // ==================================================
  // BUILD
  // ==================================================

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

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
          l10n.myAccount,
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

      body: BlocBuilder<
          ProfileCubit,
          ProfileState>(
        builder: (
          context,
          state,
        ) {
          debugPrint(
            'ProfilePage state: '
            '${state.runtimeType}',
          );

          if (state is ProfileInitial ||
              state is ProfileLoading) {
            return _buildLoading();
          }

          if (state is ProfileFailure) {
            return _buildError(
              context,
              state.message,
            );
          }

          if (state is ProfileSuccess) {
            return _buildProfile(
              context,
              state.profile,
            );
          }

          if (state is ProfileUpdating) {
            return _buildProfile(
              context,
              state.currentProfile,
            );
          }

          if (state
              is ProfileUpdateFailure) {
            return _buildProfile(
              context,
              state.currentProfile,
            );
          }

          return const SizedBox.shrink();
        },
      ),

      bottomNavigationBar:
          const CustomBottomNavigation(
        currentIndex: 2,
      ),
    );
  }

  // ==================================================
  // LOADING
  // ==================================================

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }

  // ==================================================
  // ERROR
  // ==================================================

  Widget _buildError(
    BuildContext context,
    String message,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: AppColors.error
                    .withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 42,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              l10n.profileLoadError,
              textAlign: TextAlign.center,
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

            const SizedBox(height: 10),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color:
                    AppColors.brandGray,
                fontSize: 14,
                height: 1.6,
                fontFamily:
                    AppTextStyles
                        .fontFamily,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: 180,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  context
                      .read<ProfileCubit>()
                      .loadProfile(
                        localizations:
                            AppLocalizations.of(context),
                      );
                },
                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      AppColors.primary,
                  foregroundColor:
                      Colors.white,
                  elevation: 0,
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 20,
                ),
                label: Text(
                  l10n.retry,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
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
    );
  }

  // ==================================================
  // PROFILE
  // ==================================================

  Widget _buildProfile(
    BuildContext context,
    ProfileModel profile,
  ) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () {
        return context
            .read<ProfileCubit>()
            .refreshProfile(
              localizations:
                  AppLocalizations.of(context),
            );
      },
      child: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding:
            const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          35,
        ),
        child: Column(
          children: [
            _buildProfileHeader(
              context,
              profile,
            ),

            const SizedBox(height: 22),

            _buildPersonalInfoCard(
              context,
              profile,
            ),

            const SizedBox(height: 16),

            _buildAddressCard(
              context,
              profile,
            ),

            const SizedBox(height: 16),

            _buildEditButton(
              context,
              profile,
            ),

            const SizedBox(height: 16),

            _buildAccountHint(
              context,
            ),
          ],
        ),
      ),
    );
  }

  // ==================================================
  // EDIT BUTTON
  // ==================================================

  Widget _buildEditButton(
    BuildContext context,
    ProfileModel profile,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context)
              .push<bool>(
            MaterialPageRoute<bool>(
              builder: (_) {
                return BlocProvider<
                    ProfileCubit>.value(
                  value: context
                      .read<ProfileCubit>(),
                  child:
                      EditProfileScreen(
                    profile: profile,
                  ),
                );
              },
            ),
          );
        },
        style:
            ElevatedButton.styleFrom(
          backgroundColor:
              AppColors.primary,
          foregroundColor:
              Colors.white,
          elevation: 0,
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              16,
            ),
          ),
        ),
        icon: const Icon(
          Icons.edit_outlined,
        ),
        label: Text(
          l10n.editProfile,
          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
            fontFamily:
                AppTextStyles.fontFamily,
          ),
        ),
      ),
    );
  }

  // ==================================================
  // PROFILE HEADER
  // ==================================================

  Widget _buildProfileHeader(
    BuildContext context,
    ProfileModel profile,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String? imageUrl =
        _getProfileImageUrl(
      profile.personalPhoto,
    );

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 26,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(26),
        border: Border.all(
          color: AppColors.brandGray
              .withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.035,
            ),
            blurRadius: 18,
            offset:
                const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.all(
              4,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color:
                    AppColors.primary,
                width: 2,
              ),
            ),
            child: Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors
                    .primaryContainer
                    .withOpacity(
                  0.35,
                ),
              ),
              child: ClipOval(
                child:
                    _buildProfileImage(
                  imageUrl,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            profile.fullName.trim().isEmpty
                ? l10n.beneficiary
                : profile.fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color:
                  AppColors.onSurface,
              fontSize: 21,
              fontWeight:
                  FontWeight.bold,
              fontFamily:
                  AppTextStyles
                      .fontFamily,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: AppColors
                  .primaryContainer
                  .withOpacity(
                0.35,
              ),
              borderRadius:
                  BorderRadius.circular(
                20,
              ),
            ),
            child: Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                const Icon(
                  Icons.phone_outlined,
                  color:
                      AppColors.primary,
                  size: 17,
                ),

                const SizedBox(width: 6),

                Text(
                  _formatPhone(
                    profile.countryCode,
                    profile.number,
                    l10n,
                  ),
                  textDirection:
                      TextDirection.ltr,
                  style:
                      const TextStyle(
                    color:
                        AppColors.primary,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.w600,
                    fontFamily:
                        AppTextStyles
                            .fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // PROFILE IMAGE
  // ==================================================

  Widget _buildProfileImage(
    String? imageUrl,
  ) {
    if (imageUrl == null ||
        imageUrl.trim().isEmpty) {
      return _profileImagePlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 108,
      height: 108,
      fit: BoxFit.cover,
      fadeInDuration:
          const Duration(
        milliseconds: 120,
      ),
      fadeOutDuration:
          const Duration(
        milliseconds: 80,
      ),
      placeholder: (
        context,
        url,
      ) {
        return _profileImagePlaceholder();
      },
      errorWidget: (
        context,
        url,
        error,
      ) {
        debugPrint(
          'Profile image error: $error',
        );

        return _profileImagePlaceholder();
      },
    );
  }

  Widget _profileImagePlaceholder() {
    return Container(
      color: AppColors
          .primaryContainer
          .withValues(
        alpha: 0.35,
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.person_rounded,
        size: 62,
        color: AppColors.primary,
      ),
    );
  }

  // ==================================================
  // PERSONAL INFO
  // ==================================================

  Widget _buildPersonalInfoCard(
    BuildContext context,
    ProfileModel profile,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return _buildCard(
      title:
          l10n.personalInformation,
      icon:
          Icons.person_outline_rounded,
      child: Column(
        children: [
          _buildInfoRow(
            icon: Icons.email_outlined,
            title: l10n.email,
            value:
                profile.email.trim().isEmpty
                    ? l10n.unspecified
                    : profile.email,
            valueTextDirection:
                TextDirection.ltr,
          ),

          _buildDivider(),

          _buildInfoRow(
            icon: Icons
                .calendar_month_outlined,
            title: l10n.dateOfBirth,
            value: _formatDateOfBirth(
              profile.dateOfBirth,
              l10n,
            ),
            valueTextDirection:
                TextDirection.ltr,
          ),

          _buildDivider(),

          _buildInfoRow(
            icon: Icons.cake_outlined,
            title: l10n.age,
            value: profile.age == null
                ? l10n.unspecified
                : l10n.ageWithYears(
                    profile.age!,
                  ),
          ),

          _buildDivider(),

          _buildInfoRow(
            icon: Icons.wc_outlined,
            title: l10n.gender,
            value: _localizedGender(
              profile.gender,
              l10n,
            ),
          ),

          _buildDivider(),

          _buildInfoRow(
            icon: Icons
                .favorite_border_rounded,
            title:
                l10n.socialStatus,
            value:
                _localizedSocialStatus(
              profile.socialStatus,
              l10n,
            ),
          ),

          _buildDivider(),

          _buildInfoRow(
            icon: profile.isUnemployed
                ? Icons
                    .work_off_outlined
                : Icons
                    .work_outline_rounded,
            title:
                l10n.employmentStatus,
            value: profile.isUnemployed
                ? l10n.unemployed
                : l10n.employed,
          ),
        ],
      ),
    );
  }

  // ==================================================
  // ADDRESS
  // ==================================================

  Widget _buildAddressCard(
    BuildContext context,
    ProfileModel profile,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return _buildCard(
      title: l10n.residence,
      icon:
          Icons.location_on_outlined,
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors
                  .primaryContainer
                  .withOpacity(
                0.35,
              ),
              borderRadius:
                  BorderRadius.circular(
                13,
              ),
            ),
            child: const Icon(
              Icons
                  .location_on_outlined,
              color:
                  AppColors.primary,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  l10n.address,
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

                const SizedBox(height: 5),

                Text(
                  profile.address
                          .trim()
                          .isEmpty
                      ? l10n.unspecified
                      : profile.address,
                  style:
                      const TextStyle(
                    color: AppColors
                        .onSurface,
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w600,
                    height: 1.5,
                    fontFamily:
                        AppTextStyles
                            .fontFamily,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // GENERIC CARD
  // ==================================================

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.brandGray
              .withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.025,
            ),
            blurRadius: 14,
            offset:
                const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration:
                    BoxDecoration(
                  color: AppColors
                      .primaryContainer
                      .withOpacity(
                    0.35,
                  ),
                  borderRadius:
                      BorderRadius
                          .circular(
                    11,
                  ),
                ),
                child: Icon(
                  icon,
                  color:
                      AppColors.primary,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              Text(
                title,
                style:
                    const TextStyle(
                  color:
                      AppColors.onSurface,
                  fontSize: 16,
                  fontWeight:
                      FontWeight.bold,
                  fontFamily:
                      AppTextStyles
                          .fontFamily,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          child,
        ],
      ),
    );
  }

  // ==================================================
  // INFO ROW
  // ==================================================

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    TextDirection? valueTextDirection,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 4,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color:
                  AppColors.background,
              borderRadius:
                  BorderRadius.circular(
                12,
              ),
            ),
            child: Icon(
              icon,
              color:
                  AppColors.primary,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              title,
              style:
                  const TextStyle(
                color:
                    AppColors.brandGray,
                fontSize: 14,
                fontFamily:
                    AppTextStyles
                        .fontFamily,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Flexible(
            child: Text(
              value,
              textDirection:
                  valueTextDirection,
              textAlign: TextAlign.end,
              style:
                  const TextStyle(
                color:
                    AppColors.onSurface,
                fontSize: 14,
                fontWeight:
                    FontWeight.w600,
                fontFamily:
                    AppTextStyles
                        .fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // DIVIDER
  // ==================================================

  Widget _buildDivider() {
    return Divider(
      height: 20,
      thickness: 1,
      color: AppColors.brandGray
          .withOpacity(
        0.08,
      ),
    );
  }

  // ==================================================
  // ACCOUNT HINT
  // ==================================================

  Widget _buildAccountHint(
    BuildContext context,
  ) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors
            .primaryContainer
            .withOpacity(
          0.23,
        ),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary
              .withOpacity(0.08),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons
                .verified_user_outlined,
            color: AppColors.primary,
            size: 22,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              l10n.profileAccountHint,
              style:
                  const TextStyle(
                color:
                    AppColors.onSurface,
                fontSize: 13,
                height: 1.6,
                fontFamily:
                    AppTextStyles
                        .fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // LOCALIZED GENDER
  // ==================================================

  String _localizedGender(
    String gender,
    AppLocalizations l10n,
  ) {
    switch (
        gender.trim().toUpperCase()) {
      case 'MALE':
        return l10n.male;

      case 'FEMALE':
        return l10n.female;

      default:
        return gender.trim().isEmpty
            ? l10n.unspecified
            : gender;
    }
  }

  // ==================================================
  // LOCALIZED SOCIAL STATUS
  // ==================================================

  String _localizedSocialStatus(
    String socialStatus,
    AppLocalizations l10n,
  ) {
    switch (
        socialStatus.trim().toUpperCase()) {
      case 'SINGLE':
        return l10n.single;

      case 'MARRIED':
        return l10n.married;

      case 'WIDOWED':
      case 'WIDOW':
        return l10n.widowed;

      case 'DIVORCED':
        return l10n.divorced;

      default:
        return socialStatus
                .trim()
                .isEmpty
            ? l10n.unspecified
            : socialStatus;
    }
  }

  // ==================================================
  // IMAGE URL
  // ==================================================

  String? _getProfileImageUrl(
    String? url,
  ) {
    if (url == null ||
        url.trim().isEmpty) {
      return null;
    }

    String fixedUrl =
        url.trim();

    fixedUrl =
        fixedUrl.replaceFirst(
      'http://localhost:3000',
      ApiConstants.baseUrl,
    );

    fixedUrl =
        fixedUrl.replaceFirst(
      'http://127.0.0.1:3000',
      ApiConstants.baseUrl,
    );

    if (fixedUrl.startsWith('/')) {
      fixedUrl =
          '${ApiConstants.baseUrl}$fixedUrl';
    }

    debugPrint(
      'Final profile image URL: '
      '$fixedUrl',
    );

    return fixedUrl;
  }

  // ==================================================
  // DATE OF BIRTH
  // ==================================================

  String _formatDateOfBirth(
    String? dateOfBirth,
    AppLocalizations l10n,
  ) {
    final String value =
        dateOfBirth?.trim() ?? '';

    if (value.isEmpty) {
      return l10n.unspecified;
    }

    final DateTime? parsedDate =
        DateTime.tryParse(
      value,
    );

    if (parsedDate == null) {
      return value;
    }

    final String year =
        parsedDate.year
            .toString()
            .padLeft(
              4,
              '0',
            );

    final String month =
        parsedDate.month
            .toString()
            .padLeft(
              2,
              '0',
            );

    final String day =
        parsedDate.day
            .toString()
            .padLeft(
              2,
              '0',
            );

    return '$year-$month-$day';
  }

  // ==================================================
  // PHONE
  // ==================================================

  String _formatPhone(
    String countryCode,
    String number,
    AppLocalizations l10n,
  ) {
    final String code =
        countryCode.trim();

    final String value =
        number.trim();

    if (value.isEmpty) {
      return l10n.unspecified;
    }

    if (value.startsWith('+')) {
      return value;
    }

    if (code.isNotEmpty) {
      final String internationalNumber =
          value.startsWith('0')
              ? value.substring(1)
              : value;

      return '$code $internationalNumber';
    }

    if (value.length == 9 &&
        !value.startsWith('0')) {
      return '0$value';
    }

    return value;
  }
}