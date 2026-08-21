import 'package:cached_network_image/cached_network_image.dart';
import 'package:charity_management/constants/api_constants.dart';
import 'package:charity_management/features/notifications/widget/notification_bell_button.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.profileImageUrl,
    this.onProfileTap,
  });

  final String? profileImageUrl;
  final VoidCallback? onProfileTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n =
        AppLocalizations.of(context);

    final String languageCode =
        Localizations.localeOf(context)
            .languageCode;

    final String? fixedProfileImageUrl =
        _getProfileImageUrl(
      profileImageUrl,
    );

    return AppBar(
      backgroundColor:
          AppColors.surface.withValues(
        alpha: 0.9,
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 20,

      // ==========================================
      // اسم الجمعية + اللوغو
      // ==========================================

      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ========================================
          // اللوغو
          // ========================================

          Container(
            width: 44,
            height: 44,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary
                    .withValues(
                  alpha: 0.2,
                ),
                width: 2,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/img/logo_isolated.svg.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          // ========================================
          // اسم الجمعية
          // ========================================

          Text(
            l10n.associationName,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      // ==========================================
      // PROFILE + NOTIFICATION
      //
      // بالعربي والإنكليزي:
      // نحافظ على مكان الصورة بالنسبة للجرس
      // ==========================================

      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Directionality(
            textDirection:
                languageCode == 'ar'
                    ? TextDirection.ltr
                    : TextDirection.rtl,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ==================================
                // صورة البروفايل
                // ==================================

                InkWell(
                  onTap: onProfileTap,
                  borderRadius:
                      BorderRadius.circular(
                    30,
                  ),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors
                          .primaryContainer
                          .withValues(
                        alpha: 0.3,
                      ),
                      border: Border.all(
                        color: AppColors.primary
                            .withValues(
                          alpha: 0.25,
                        ),
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child:
                          _buildProfileImage(
                        fixedProfileImageUrl,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  width: 6,
                ),

                // ==================================
                // الجرس
                // ==================================

                const NotificationBellButton(
                  iconColor:
                      AppColors.brandGray,
                  iconSize: 28,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // PROFILE IMAGE
  // ==========================================

  Widget _buildProfileImage(
    String? imageUrl,
  ) {
    if (imageUrl == null ||
        imageUrl.trim().isEmpty) {
      return const Center(
        child: Icon(
          Icons.person_rounded,
          color: AppColors.primary,
          size: 26,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: 42,
      height: 42,
      fit: BoxFit.cover,

      // ======================================
      // انتقال سريع للصورة
      // ======================================

      fadeInDuration:
          const Duration(
        milliseconds: 120,
      ),

      fadeOutDuration:
          const Duration(
        milliseconds: 80,
      ),

      // ======================================
      // أثناء تحميل الصورة
      // ======================================

      placeholder: (
        context,
        url,
      ) {
        return const Center(
          child: Icon(
            Icons.person_rounded,
            color: AppColors.primary,
            size: 26,
          ),
        );
      },

      // ======================================
      // في حال فشل تحميل الصورة
      // ======================================

      errorWidget: (
        context,
        url,
        error,
      ) {
        debugPrint(
          'CustomAppBar profile image error: '
          '$error',
        );

        return const Center(
          child: Icon(
            Icons.person_rounded,
            color: AppColors.primary,
            size: 26,
          ),
        );
      },
    );
  }

  // ==========================================
  // FIX PROFILE IMAGE URL
  // ==========================================

  String? _getProfileImageUrl(
    String? url,
  ) {
    if (url == null ||
        url.trim().isEmpty) {
      return null;
    }

    String fixedUrl = url.trim();

    // ========================================
    // localhost -> API base URL
    // ========================================

    fixedUrl = fixedUrl.replaceFirst(
      'http://localhost:3000',
      ApiConstants.baseUrl,
    );

    // ========================================
    // 127.0.0.1 -> API base URL
    // ========================================

    fixedUrl = fixedUrl.replaceFirst(
      'http://127.0.0.1:3000',
      ApiConstants.baseUrl,
    );

    // ========================================
    // Relative URL
    // ========================================

    if (fixedUrl.startsWith('/')) {
      fixedUrl =
          '${ApiConstants.baseUrl}$fixedUrl';
    }

    debugPrint(
      'CustomAppBar profile image URL: '
      '$fixedUrl',
    );

    return fixedUrl;
  }

  // ==========================================
  // APP BAR HEIGHT
  // ==========================================

  @override
  Size get preferredSize =>
      const Size.fromHeight(
        kToolbarHeight,
      );
}