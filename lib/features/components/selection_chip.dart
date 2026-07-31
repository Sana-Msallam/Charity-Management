import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:flutter/material.dart';

class SelectionChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectionChip({
    Key? key,
    required this.label,
    this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          // الخلفية تصبح ذهبية عند الاختيار وبيضاء عند عدم الاختيار
          color: isSelected ? AppColors.primaryContainer : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? AppColors.primaryContainer : AppColors.secondary.withOpacity(0.1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon, 
                // التعديل السحري: إذا تم الاختيار يظهر لون الأيقونة رمادي داكن جداً ليتباين مع الذهبي
                color: isSelected ? const Color(0xFF2C2A29) : AppColors.brandGray, 
                size: 20,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                // التعديل السحري: إذا تم الاختيار يظهر النص بلون رمادي داكن جداً (أو الأسود) لكي يبرز فوق الذهبي
                color: isSelected ? const Color(0xFF2C2A29) : AppColors.onSurface,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontFamily: AppTextStyles.fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}