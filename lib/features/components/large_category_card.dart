import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class LargeCategoryCard extends StatelessWidget {
  final VoidCallback onTap;

  const LargeCategoryCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    const cardColor = Color(0xFFD3DC7C);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.15),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Material(
          color: cardColor.withOpacity(0.15),
          child: InkWell(
            onTap: onTap,
            splashColor: cardColor.withOpacity(0.25),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(
                  color: cardColor.withOpacity(0.15),
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // ======================================
                      // ICON
                      // ======================================

                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.0),
                          boxShadow: [
                            BoxShadow(
                              color: cardColor.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.home_outlined,
                          color: AppColors.tertiary,
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // ======================================
                      // TEXT
                      // ======================================

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.housingRequest,
                            style: const TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppTextStyles.fontFamily,
                            ),
                          ),

                          Text(
                            l10n.housingRequestSubtitle,
                            style: TextStyle(
                              color: AppColors.onSurface.withOpacity(0.7),
                              fontSize: 13,
                              fontFamily: AppTextStyles.fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // ======================================
                  // ARROW
                  //
                  // AR → يتجه حسب RTL
                  // EN → يتجه حسب LTR
                  // ======================================

                 Icon(
  Directionality.of(context) == TextDirection.rtl
      ? Icons.chevron_left_rounded
      : Icons.chevron_right_rounded,
  color: AppColors.onSurface,
  size: 24,
),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}