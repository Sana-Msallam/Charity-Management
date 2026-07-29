import 'package:charity_management/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BeneficiariesCounter extends StatelessWidget {
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const BeneficiariesCounter({
    Key? key,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.tertiary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.tertiary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'عدد الأفراد المحتاجين للدعم',
                style: TextStyle(color: AppColors.brandGray, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                '$count ${count == 1 ? 'فرد' : 'أفراد'}',
                style: const TextStyle(color: AppColors.tertiary, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: onDecrement,
                icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary, size: 28),
              ),
              IconButton(
                onPressed: onIncrement,
                icon: const Icon(Icons.add_circle, color: AppColors.primary, size: 28),
              ),
            ],
          )
        ],
      ),
    );
  }
}