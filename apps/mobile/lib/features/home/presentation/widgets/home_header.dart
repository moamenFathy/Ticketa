import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketa/core/constants/app_constants.dart';
import 'package:ticketa/core/di/injection.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/features/auth/data/auth_repository.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class HomeHeader extends StatefulWidget {
  final VoidCallback? onAvatarTap;

  const HomeHeader({super.key, this.onAvatarTap});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String _initials = '';
  bool _isGuest = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isGuest = prefs.getBool(AppConstants.isGuestKey) ?? true;
      String initials = '';

      if (!isGuest) {
        final profile = await getIt<AuthRepository>().getProfile();
        final firstName = profile['firstName'] as String? ?? '';
        final lastName = profile['lastName'] as String? ?? '';
        final fullName = ' '.trim();
        final email = profile['email'] as String? ?? prefs.getString(AppConstants.userEmailKey) ?? '';

        initials = _calculateInitials(fullName.isNotEmpty ? fullName : email);
      }

      if (!mounted) return;
      setState(() {
        _isGuest = isGuest;
        _initials = initials;
      });
    } catch (_) {
      // Keep default if failed
    }
  }

  static String _calculateInitials(String text) {
    final cleaned = text.trim();
    if (cleaned.isEmpty) return '';
    final parts = cleaned.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0].length >= 2
        ? parts[0].substring(0, 2).toUpperCase()
        : parts[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 2, 20, 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TICKETA',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.warmOrange,
                  letterSpacing: 0.5,
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
                    l10n.locationPlaceholder,
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
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final isGuest =
                      prefs.getBool(AppConstants.isGuestKey) ?? true;
                  if (isGuest && widget.onAvatarTap != null) {
                    widget.onAvatarTap!();
                  } else {
                    await Navigator.of(context).pushNamed('/edit-profile');
                    _loadUser();
                  }
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.warmOrange,
                        AppColors.lighterOrange,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.warmOrange.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark ? const Color(0xFF19191C) : Colors.white,
                    ),
                    child: Center(
                      child: _isGuest || _initials.isEmpty
                          ? Icon(
                              Icons.person_rounded,
                              color: AppColors.warmOrange,
                              size: 22,
                            )
                          : Text(
                              _initials,
                              style: const TextStyle(
                                color: AppColors.warmOrange,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
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
