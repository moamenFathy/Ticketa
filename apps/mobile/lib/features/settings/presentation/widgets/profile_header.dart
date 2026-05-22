import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.26 : 0.05),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAvatar(theme),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Mohamed Ahmed",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "mohamed@ticketa.com",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildMemberBadge(theme, l10n.loyaltyPoints),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildEditProfileButton(context, theme, l10n.editProfile),
        ],
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.warmOrange, Colors.orangeAccent],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warmOrange.withValues(alpha: 0.3),
            blurRadius: 25,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.person_rounded,
            size: 36,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberBadge(ThemeData theme, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.warmOrange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: AppColors.warmOrange,
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
        ),
      ),
    );
  }

  Widget _buildEditProfileButton(
    BuildContext context,
    ThemeData theme,
    String label,
  ) {
    return Tooltip(
      message: label,
      child: Material(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => Navigator.of(context).pushNamed('/edit-profile'),
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              Icons.edit_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
