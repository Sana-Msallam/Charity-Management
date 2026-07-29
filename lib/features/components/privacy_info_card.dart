import 'package:charity_management/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PrivacyInfoCard extends StatelessWidget {
  const PrivacyInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: AppColors.secondary.withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user_outlined, color: AppColors.secondary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'خصوصية البيانات',
                  style: TextStyle(color: AppColors.secondary, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'يتم التعامل مع كافة البيانات المرفوعة بمنتهى السرية والخصوصية التامة وفقاً للمعايير الأمنية.',
                  style: TextStyle(color: AppColors.brandGray, fontSize: 12, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}