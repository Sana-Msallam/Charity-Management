import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.isLtr = false,
    this.maxLines = 1,
    this.isCurrency = false,
    this.validator,
    this.enabled = true,
    this.onChanged,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final IconData? suffixIcon;
  final bool isLtr;
  final int maxLines;
  final bool isCurrency;
  final String? Function(String?)? validator;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final bool isMultiline = maxLines > 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0, bottom: 8.0),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.brandGray,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: AppTextStyles.fontFamily,
            ),
          ),
        ),

        Stack(
          alignment: Alignment.centerLeft,
          children: [
            TextFormField(
              controller: controller,
              enabled: enabled,
              validator: validator,
              onChanged: onChanged,

              keyboardType: isMultiline
                  ? TextInputType.multiline
                  : keyboardType,

              textInputAction: isMultiline
                  ? TextInputAction.newline
                  : TextInputAction.next,

              maxLines: maxLines,
            

              textDirection: isLtr
                  ? TextDirection.ltr
                  : Directionality.of(context),

              textAlign: isLtr
                  ? TextAlign.left
                  : TextAlign.right,

              style: TextStyle(
                fontWeight: isCurrency ? FontWeight.bold : FontWeight.normal,
              ),

              decoration: InputDecoration(
                hintText: hint,

                hintStyle: TextStyle(
                  color: AppColors.brandGray.withOpacity(
                    0.55,
                  ),
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  fontFamily: AppTextStyles.fontFamily,
                ),

                filled: true,

                fillColor: enabled
                    ? Colors.white
                    : AppColors.brandGray.withOpacity(
                        0.05,
                      ),

                suffixIcon: suffixIcon != null && !isCurrency
                    ? Icon(suffixIcon, color: AppColors.brandGray, size: 22)
                    : null,

                contentPadding: EdgeInsets.only(
                  right: 16,
                  left: isCurrency ? 72 : 16,
                  top: isMultiline ? 16 : 15,
                  bottom: isMultiline ? 16 : 15,
                ),

                errorMaxLines: 2,

                errorStyle: const TextStyle(
                  fontSize: 12,
                  fontFamily: AppTextStyles.fontFamily,
                ),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                  borderSide: BorderSide(
                    color: AppColors.brandGray.withOpacity(
                      0.3,
                    ),
                    width: 1.2,
                  ),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                  borderSide: BorderSide(
                    color: AppColors.brandGray.withOpacity(
                      0.32,
                    ),
                    width: 1.25,
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.8,
                  ),
                ),

                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.red),
                ),

                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),

                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                  borderSide: BorderSide(
                    color: AppColors.brandGray.withOpacity(
                      0.15,
                    ),
                    width: 1,
                  ),
                ),
              ),
            ),

            if (isCurrency)
              Positioned(
                left: 16,
                child: Container(
                  padding: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: AppColors.brandGray.withOpacity(0.2),
                      ),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context).currencyRiyal,
                    style: const TextStyle(
                      color: AppColors.brandGray,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
