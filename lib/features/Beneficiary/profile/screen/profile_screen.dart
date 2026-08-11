import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/features/Beneficiary/profile/cubit/profile_cubit.dart';
import 'package:charity_management/features/Beneficiary/profile/cubit/profile_state.dart';
import 'package:charity_management/features/Beneficiary/profile/model/profile_model.dart';
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
            .loadProfile();
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            AppColors.background,
        appBar: AppBar(
          backgroundColor:
              AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            'حسابي',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily:
                  AppTextStyles.fontFamily,
            ),
          ),
        ),
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
                state.message,
              );
            }

            if (state is ProfileSuccess) {
              return _buildProfile(
                state.profile,
              );
            }

            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar:
            const CustomBottomNavigation(
          currentIndex: 2,
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildError(
    String message,
  ) {
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
                    .withOpacity(
                  0.1,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons
                    .error_outline_rounded,
                color: AppColors.error,
                size: 42,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'تعذر تحميل الملف الشخصي',
              textAlign: TextAlign.center,
              style: TextStyle(
                color:
                    AppColors.onSurface,
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
                fontFamily:
                    AppTextStyles.fontFamily,
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
                    AppTextStyles.fontFamily,
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
                      .loadProfile();
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
                  Icons.refresh_rounded,
                  size: 20,
                ),
                label: const Text(
                  'إعادة المحاولة',
                  style: TextStyle(
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

  Widget _buildProfile(
    ProfileModel profile,
  ) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () {
        return context
            .read<ProfileCubit>()
            .refreshProfile();
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
              profile,
            ),

            const SizedBox(height: 22),

            _buildPersonalInfoCard(
              profile,
            ),

            const SizedBox(height: 16),

            _buildAddressCard(
              profile,
            ),

            const SizedBox(height: 16),

            _buildAccountHint(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(
    ProfileModel profile,
  ) {
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
              .withOpacity(
            0.12,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(
              0.035,
            ),
            blurRadius: 18,
            offset:
                const Offset(
              0,
              6,
            ),
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
              decoration:
                  BoxDecoration(
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
            profile.fullName.isEmpty
                ? 'المستفيد'
                : profile.fullName,
            textAlign:
                TextAlign.center,
            style: const TextStyle(
              color:
                  AppColors.onSurface,
              fontSize: 21,
              fontWeight:
                  FontWeight.bold,
              fontFamily:
                  AppTextStyles.fontFamily,
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
                    profile.number,
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

  Widget _buildProfileImage(
    String? imageUrl,
  ) {
    if (imageUrl == null ||
        imageUrl.trim().isEmpty) {
      return const Icon(
        Icons.person_rounded,
        size: 62,
        color: AppColors.primary,
      );
    }

    return Image.network(
      imageUrl,
      width: 108,
      height: 108,
      fit: BoxFit.cover,
      loadingBuilder: (
        context,
        child,
        progress,
      ) {
        if (progress == null) {
          return child;
        }

        return const Center(
          child:
              CircularProgressIndicator(
            strokeWidth: 2,
            color:
                AppColors.primary,
          ),
        );
      },
      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        debugPrint(
          'Profile image error: '
          '$error',
        );

        return const Icon(
          Icons.person_rounded,
          size: 62,
          color:
              AppColors.primary,
        );
      },
    );
  }

  Widget _buildPersonalInfoCard(
    ProfileModel profile,
  ) {
    return _buildCard(
      title: 'المعلومات الشخصية',
      icon:
          Icons.person_outline_rounded,
      child: Column(
        children: [
          _buildInfoRow(
            icon:
                Icons.cake_outlined,
            title: 'العمر',
            value: profile.age == null
                ? 'غير محدد'
                : '${profile.age} سنة',
          ),

          _buildDivider(),

          _buildInfoRow(
            icon:
                Icons.wc_outlined,
            title: 'الجنس',
            value:
                profile.genderArabic,
          ),

          _buildDivider(),

          _buildInfoRow(
            icon:
                Icons.favorite_border_rounded,
            title:
                'الحالة الاجتماعية',
            value: profile
                .socialStatusArabic,
          ),

          _buildDivider(),

          _buildInfoRow(
            icon: profile.isUnemployed
                ? Icons
                    .work_off_outlined
                : Icons
                    .work_outline_rounded,
            title: 'حالة العمل',
            value: profile
                .employmentStatusArabic,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(
    ProfileModel profile,
  ) {
    return _buildCard(
      title: 'مكان الإقامة',
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
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'العنوان',
                  style: TextStyle(
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
                      ? 'غير محدد'
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
              .withOpacity(
            0.12,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(
              0.025,
            ),
            blurRadius: 14,
            offset:
                const Offset(
              0,
              5,
            ),
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

              const SizedBox(
                width: 10,
              ),

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
            ],
          ),

          const SizedBox(height: 18),

          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
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
            decoration:
                BoxDecoration(
              color: AppColors
                  .background,
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
              textAlign:
                  TextAlign.end,
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

  Widget _buildAccountHint() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer
            .withOpacity(
          0.23,
        ),
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary
              .withOpacity(
            0.08,
          ),
        ),
      ),
      child: const Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons
                .verified_user_outlined,
            color: AppColors.primary,
            size: 22,
          ),

          SizedBox(width: 10),

          Expanded(
            child: Text(
              'يتم عرض بيانات حسابك المسجلة لدى الجمعية.',
              style: TextStyle(
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

  String? _getProfileImageUrl(
    String? url,
  ) {
    if (url == null ||
        url.trim().isEmpty) {
      return null;
    }

    String fixedUrl = url.trim();

    /*
     * الباك قد يعيد الصورة بهذا الشكل:
     *
     * http://localhost:3000/uploads/...
     *
     * localhost لا يعمل من الموبايل،
     * لذلك نستبدله بـ baseUrl الحالي.
     */
    fixedUrl = fixedUrl.replaceFirst(
      'http://localhost:3000',
      ApiConstants.baseUrl,
    );

    fixedUrl = fixedUrl.replaceFirst(
      'http://127.0.0.1:3000',
      ApiConstants.baseUrl,
    );

    /*
     * إذا رجع الباك مسارًا فقط:
     * /uploads/beneficiaries/...
     */
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

  String _formatPhone(
    String number,
  ) {
    final String value =
        number.trim();

    if (value.isEmpty) {
      return 'غير محدد';
    }

    /*
     * إذا الباك يعيد مثلاً:
     * 993602106
     *
     * نضيف صفر للعرض فقط.
     */
    if (value.length == 9 &&
        !value.startsWith('0')) {
      return '0$value';
    }

    return value;
  }
}