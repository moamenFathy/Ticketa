import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/services/locale_service.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLocale = Localizations.localeOf(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.warmOrange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentLocale.languageCode,
          dropdownColor: theme.scaffoldBackgroundColor,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: AppColors.warmOrange,
          ),
          style: const TextStyle(
            color: AppColors.warmOrange,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) {
              context.read<LocaleService>().setLocale(Locale(newValue));
            }
          },
          items: <String>['en', 'ar'].map<DropdownMenuItem<String>>((
            String value,
          ) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value.toUpperCase()),
            );
          }).toList(),
        ),
      ),
    );
  }
}
