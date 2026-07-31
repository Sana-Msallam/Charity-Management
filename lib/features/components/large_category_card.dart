import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:flutter/material.dart';

class LargeCategoryCard extends StatelessWidget {
  final VoidCallback onTap;

  const LargeCategoryCard({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    const cardColor = Color(0xFFD3DC7C); // اللون المعتمد في كودك للطلب السكني
    
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
          color: cardColor.withOpacity(0.15), // خلفية واضحة ومميزة للزر السكني
          child: InkWell(
            onTap: onTap,
            splashColor: cardColor.withOpacity(0.25),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: cardColor.withOpacity(0.4), width: 1.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  Row(
                    children: [
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
                            )
                          ],
                        ),
                        child: const Icon(Icons.home_outlined, color: AppColors.tertiary, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [ 
                          const Text(
                            'طلب سكني',
                            style: TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppTextStyles.fontFamily,
                            ),
                          ),
                          Text(
                            'تحسين المسكن أو إيجار',
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
                  const Icon(Icons.chevron_left, color: AppColors.onSurface, size: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}