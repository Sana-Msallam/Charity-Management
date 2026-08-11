import 'package:charity_management/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomAttachmentUploader extends StatelessWidget {
  final String title; // العنوان (مثلاً: إرفاق تقارير طبية أو وثائق ثبوتية)
  final String description; // النص التوضيحي المساعد
  final IconData icon; // الأيقونة (كاميرا أو ملف)
  final VoidCallback onTap; // الحدث عند الضغط

  const CustomAttachmentUploader({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: AppColors.brandGray.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Icon(
                icon, // الأيقونة المتغيرة
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title, // العنوان المتغير
              style: const TextStyle(
                color: AppColors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description, // الوصف المتغير
              style: const TextStyle(color: AppColors.brandGray, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
