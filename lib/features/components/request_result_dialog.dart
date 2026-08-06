import 'package:charity_management/theme/app_colors.dart';
import 'package:charity_management/theme/app_font.dart';
import 'package:flutter/material.dart';

Future<void> showRequestResultDialog({
  required BuildContext context,
  required bool isSuccess,
  required String message,
  VoidCallback? onRetry,
  VoidCallback? onSuccessConfirmed,
}) async {
  final bool isLoginError =
      message.contains('تسجيل الدخول');

  final bool isConnectionError =
      message.contains('مهلة الاتصال') ||
      message.contains('تعذر الاتصال') ||
      message.contains('الاتصال بالخادم');

  final String title;

  if (isSuccess) {
    title = 'تم إرسال الطلب';
  } else if (isLoginError) {
    title = 'تسجيل الدخول مطلوب';
  } else if (isConnectionError) {
    title = 'تعذر الاتصال';
  } else {
    title = 'تعذر إرسال الطلب';
  }

  final IconData icon;

  if (isSuccess) {
    icon = Icons.check_circle_rounded;
  } else if (isLoginError) {
    icon = Icons.lock_outline_rounded;
  } else if (isConnectionError) {
    icon = Icons.wifi_off_rounded;
  } else {
    icon = Icons.error_outline_rounded;
  }

  final Color statusColor = isSuccess
      ? const Color(0xFF3D8060)
      : AppColors.error;

  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      final double maxDialogHeight =
          MediaQuery.sizeOf(dialogContext).height * 0.82;

      return PopScope(
        canPop: false,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 24,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxDialogHeight,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: statusColor.withOpacity(0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: statusColor,
                        size: 40,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppTextStyles.fontFamily,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Flexible(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.brandGray,
                            fontSize: 14,
                            height: 1.6,
                            fontFamily: AppTextStyles.fontFamily,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (!isSuccess &&
                        isConnectionError &&
                        onRetry != null) ...[
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();

                            Future<void>.delayed(
                              const Duration(milliseconds: 250),
                              onRetry,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(
                            Icons.refresh_rounded,
                          ),
                          label: const Text(
                            'إعادة المحاولة',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppTextStyles.fontFamily,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                    ],

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();

                          if (isSuccess &&
                              onSuccessConfirmed != null) {
                            onSuccessConfirmed();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSuccess
                              ? AppColors.primary
                              : AppColors.primaryContainer,
                          foregroundColor: isSuccess
                              ? Colors.white
                              : AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          isSuccess
                              ? 'حسنًا'
                              : 'العودة إلى الطلب',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppTextStyles.fontFamily,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}