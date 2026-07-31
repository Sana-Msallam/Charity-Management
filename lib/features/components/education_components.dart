import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:flutter/material.dart';

// 1. أزرار اختيار التحصيل الدراسي (مدرسي / جامعي)
class EduLevelButton extends StatelessWidget {
  final String level;
  final bool isActive;
  final VoidCallback onTap;

  const EduLevelButton({
    Key? key,
    required this.level,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 48,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryContainer : Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isActive ? AppColors.primary : AppColors.brandGray.withOpacity(0.1),
              width: isActive ? 2.0 : 1.0,
            ),
          ),
          child: Center(
            child: Text(
              level,
              style: TextStyle(
                color: isActive ? AppColors.primaryContainer : AppColors.brandGray,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontFamily: AppTextStyles.fontFamily,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 2. كبسولات الاختيار المتعدد لنوع المساعدة المطلوبة
class AssistanceToggleChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const AssistanceToggleChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary.withOpacity(0.4) : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isSelected ? AppColors.secondary.withOpacity(0.3) : AppColors.brandGray.withOpacity(0.1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check, size: 16, color: AppColors.secondary),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.secondary : AppColors.brandGray,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: AppTextStyles.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. الكرت الجمالي التوضيحي السفلي
class EducationalDecorativeCard extends StatelessWidget {
  const EducationalDecorativeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'لماذا نطلب هذه البيانات؟',
            style: TextStyle(color: AppColors.secondary, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            'نحرص على دقة البيانات لضمان وصول المساعدات لمستحقيها بأسرع وقت ممكن وبكل كرامة.',
            style: TextStyle(color: AppColors.onSurface, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }
}