import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/constants/app_constants.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  bool _isGuest = true;
  bool _isLoading = true;
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadAuth();
  }

  Future<void> _loadAuth() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _isGuest = prefs.getBool(AppConstants.isGuestKey) ?? true;
      _email = prefs.getString(AppConstants.userEmailKey) ?? '';
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) return const SizedBox.shrink();

    if (_isGuest) {
      return _buildGuestPrompt(theme, isDark);
    }

    return _buildProfile(theme, isDark);
  }

  Widget _buildGuestPrompt(ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  theme.colorScheme.surface,
                  theme.colorScheme.surface.withValues(alpha: 0.8),
                ]
              : [
                  Colors.white,
                  AppColors.lightCream.withValues(alpha: 0.8),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? AppColors.warmOrange.withValues(alpha: 0.12)
              : theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.warmOrange.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.warmOrange.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.warmOrange,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Welcome to Ticketa',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to access your tickets,\nbookings and preferences',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.warmOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile(ThemeData theme, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  theme.colorScheme.surface,
                  theme.colorScheme.surface.withValues(alpha: 0.8),
                ]
              : [
                  Colors.white,
                  AppColors.lightCream.withValues(alpha: 0.8),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark
              ? AppColors.warmOrange.withValues(alpha: 0.12)
              : theme.colorScheme.onSurface.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? AppColors.warmOrange.withValues(alpha: 0.04)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildAvatar(theme, isDark),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _email.contains('@') ? _email.split('@')[0] : _email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 17,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.verified_rounded,
                      color: AppColors.warmOrange,
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildEditProfileButton(context, theme, l10n.editProfile, isDark),
        ],
      ),
    );
  }

  Widget _buildAvatar(ThemeData theme, bool isDark) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [AppColors.warmOrange, AppColors.lighterOrange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.warmOrange.withValues(alpha: isDark ? 0.25 : 0.15),
                blurRadius: 16,
                spreadRadius: 2,
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
                size: 34,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.warmOrange,
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.scaffoldBackgroundColor,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
              ),
            ],
          ),
          child: const Icon(
            Icons.star_rounded,
            color: Colors.white,
            size: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildEditProfileButton(
    BuildContext context,
    ThemeData theme,
    String label,
    bool isDark,
  ) {
    return Tooltip(
      message: label,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isDark
                ? AppColors.warmOrange.withValues(alpha: 0.15)
                : theme.colorScheme.onSurface.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: Material(
          color: isDark
              ? AppColors.warmOrange.withValues(alpha: 0.06)
              : theme.colorScheme.onSurface.withValues(alpha: 0.03),
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed('/edit-profile'),
            child: SizedBox(
              width: 42,
              height: 42,
              child: Icon(
                Icons.edit_rounded,
                color: AppColors.warmOrange,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
