import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/constants/app_constants.dart';
import 'package:ticketa/core/services/theme_service.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import '../widgets/profile_header.dart';
import '../widgets/premium_stats.dart';
import '../widgets/settings_tile.dart';
import '../widgets/language_selector.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLoading = true;
  bool _isGuest = true;

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
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isLoading) return const SizedBox.shrink();

    if (_isGuest) {
      return _buildGuestView(theme, isDark);
    }

    return _buildSettingsView(theme, isDark);
  }

  Widget _buildGuestView(ThemeData theme, bool isDark) {
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.warmOrange.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: AppColors.warmOrange,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Welcome to Ticketa',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Sign in to access your tickets,\nbookings and preferences',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
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
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.warmOrange,
                      side: BorderSide(color: AppColors.warmOrange.withValues(alpha: 0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsView(ThemeData theme, bool isDark) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            title: Text(
              l10n.settings,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfileHeader(),
                  const SizedBox(height: 16),
                  const PremiumStats(),
                  const SizedBox(height: 32),

                  SettingsSection(
                    title: l10n.appSettings,
                    icon: Icons.tune_rounded,
                    children: [
                      SettingsTile(
                        icon: Icons.language_rounded,
                        title: l10n.language,
                        subtitle: l10n.changeLanguage,
                        trailing: const LanguageSelector(),
                      ),
                      SettingsTile(
                        icon: isDark
                            ? Icons.dark_mode_rounded
                            : Icons.light_mode_rounded,
                        title: l10n.darkMode,
                        subtitle: l10n.toggleDarkLight,
                        trailing: Switch.adaptive(
                          value: isDark,
                          onChanged: (val) {
                            context.read<ThemeService>().setTheme(
                              val ? ThemeMode.dark : ThemeMode.light,
                            );
                          },
                          activeThumbColor: Colors.white,
                          activeTrackColor: AppColors.warmOrange,
                          inactiveThumbColor: isDark ? Colors.grey[400] : Colors.grey[200],
                          inactiveTrackColor: isDark ? Colors.grey[800] : Colors.grey[300],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SettingsSection(
                    title: l10n.account,
                    icon: Icons.person_outline_rounded,
                    children: [
                      SettingsTile(
                        icon: Icons.confirmation_number_outlined,
                        title: l10n.myTickets,
                        subtitle: "8 upcoming • 4 past",
                        onTap: () => Navigator.of(context).pushNamed('/my-tickets'),
                      ),
                      const SettingsTile(
                        icon: Icons.favorite_border_rounded,
                        title: "Watchlist",
                        subtitle: "15 movies saved",
                      ),
                      SettingsTile(
                        icon: Icons.notifications_none_rounded,
                        title: l10n.notifications,
                        subtitle: l10n.manageNotifications,
                        onTap: () =>
                            Navigator.of(context).pushNamed('/notifications'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SettingsSection(
                    title: l10n.privacySecurity,
                    icon: Icons.security_rounded,
                    children: [
                      SettingsTile(
                        icon: Icons.lock_outline_rounded,
                        title: "Password",
                        subtitle: "Update your credentials",
                        onTap: () => Navigator.of(context).pushNamed('/security'),
                      ),
                      SettingsTile(
                        icon: Icons.description_outlined,
                        title: l10n.privacyPolicy,
                        subtitle: "Read our terms of service",
                        onTap: () => Navigator.of(context).pushNamed('/privacy'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 36),

                  _buildElegantLogout(theme, l10n, isDark),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElegantLogout(ThemeData theme, AppLocalizations l10n, bool isDark) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Colors.redAccent.withValues(alpha: 0.12),
                  Colors.redAccent.withValues(alpha: 0.04),
                ]
              : [
                  Colors.redAccent.withValues(alpha: 0.08),
                  Colors.white,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.redAccent.withValues(alpha: isDark ? 0.25 : 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withValues(alpha: isDark ? 0.04 : 0.01),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleLogout,
          splashColor: Colors.redAccent.withValues(alpha: 0.1),
          highlightColor: Colors.redAccent.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.power_settings_new_rounded,
                  color: Colors.redAccent,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.signOut,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w900,
                    fontSize: 14.5,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.isGuestKey);
    await prefs.remove(AppConstants.isLoggedInKey);
    await prefs.remove(AppConstants.userEmailKey);
    await prefs.remove(AppConstants.tokenKey);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }
}
