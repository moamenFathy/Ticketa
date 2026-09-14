import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'package:provider/provider.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/services/locale_service.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentLocale = Localizations.localeOf(context);
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;

    if (isiOS) {
      return _buildNative(context, isDark, currentLocale.languageCode);
    }

    return _buildFlutter(context, theme, isDark, currentLocale.languageCode);
  }

  Widget _buildNative(BuildContext context, bool isDark, String languageCode) {
    final current = languageCode == 'ar' ? 'العربية' : 'EN';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: 84,
        height: 32,
        child: CNPopupMenuButton(
          buttonLabel: current,
          shrinkWrap: true,
          tint: isDark ? AppColors.lighterOrange : AppColors.warmOrange,
          items: const [
            CNPopupMenuItem(label: 'English'),
            CNPopupMenuItem(label: 'العربية'),
          ],
          onSelected: (index) {
            context.read<LocaleService>().setLocale(
              index == 0 ? const Locale('en') : const Locale('ar'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFlutter(BuildContext context, ThemeData theme, bool isDark,
      String languageCode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: languageCode,
          dropdownColor: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          elevation: 4,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
            fontSize: 13,
            letterSpacing: 0,
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  value == 'en' ? 'English' : 'العربية',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                    fontSize: 13,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}