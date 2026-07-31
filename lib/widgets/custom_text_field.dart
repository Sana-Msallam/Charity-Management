import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
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
  });

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
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Stack(
          alignment: Alignment.centerLeft,
          children: [
            TextFormField(
              controller: controller,
              enabled: enabled,

              keyboardType: isMultiline
                  ? TextInputType.multiline
                  : keyboardType,

              maxLines: maxLines,

              textInputAction: isMultiline
                  ? TextInputAction.newline
                  : TextInputAction.next,

              validator: validator,

              textDirection: isLtr
                  ? TextDirection.ltr
                  : Directionality.of(context),

              style: TextStyle(
                fontWeight: isCurrency ? FontWeight.bold : FontWeight.normal,
              ),

              decoration: InputDecoration(
                hintText: hint,

                hintStyle: TextStyle(
                  color: AppColors.brandGray.withOpacity(0.5),
                  fontSize: 14,
                ),

                fillColor: Colors.white,
                filled: true,

                errorMaxLines: 2,

                suffixIcon: suffixIcon != null && !isCurrency
                    ? Icon(suffixIcon, color: AppColors.brandGray, size: 22)
                    : null,

                contentPadding: EdgeInsets.only(
                  right: 16,
                  left: isCurrency ? 60 : 16,
                  top: 14,
                  bottom: 14,
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: AppColors.brandGray.withOpacity(0.1),
                  ),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
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
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: AppColors.brandGray.withOpacity(0.08),
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
