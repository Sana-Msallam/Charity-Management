import 'package:charity_management/l10n/generated/app_localizations.dart';
import 'package:charity_management/routes/app_routes.dart';
import 'package:flutter/material.dart';

Future<void> showGuestLoginRequiredDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  final isArabic = Localizations.localeOf(context).languageCode == 'ar';

  return showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: Text(l10n.login),
        content: Text(
          isArabic
              ? 'يجب تسجيل الدخول للقيام بهذه العملية'
              : 'You must log in to perform this action',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login,
                (route) => false,
              );
            },
            child: Text(l10n.backToLogin),
          ),
        ],
      );
    },
  );
}
