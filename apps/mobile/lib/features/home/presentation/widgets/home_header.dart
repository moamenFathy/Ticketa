import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketa/core/constants/app_constants.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback? onAvatarTap;

  const HomeHeader({super.key, this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.appName,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.warmOrange,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.52),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Cairo, Egypt",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.52,
                      ),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Tooltip(
            message: l10n.editProfile,
            child: Material(
              color: theme.colorScheme.surface.withValues(alpha: 0.72),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final isGuest =
                      prefs.getBool(AppConstants.isGuestKey) ?? true;
                  if (isGuest && onAvatarTap != null) {
                    onAvatarTap!();
                  } else {
                    Navigator.of(context).pushNamed('/edit-profile');
                  }
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.08,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: theme.brightness == Brightness.dark
                              ? 0.22
                              : 0.06,
                        ),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.76),
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
