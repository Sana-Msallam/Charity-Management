import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/language/cubit/language_cubit.dart';
import '../l10n/generated/app_localizations.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return TextButton.icon(
      onPressed: enabled
          ? () => context.read<LanguageCubit>().toggleLanguage()
          : null,
      icon: const Icon(Icons.language),
      label: Text(localizations.changeLanguage),
    );
  }
}
