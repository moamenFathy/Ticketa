import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/services/theme_service.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import '../widgets/profile_header.dart';
import '../widgets/premium_stats.dart';
import '../widgets/settings_tile.dart';
import '../widgets/language_selector.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            expandedHeight: 104,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: false,
            title: Text(
              l10n.settings,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.warmOrange.withValues(
                        alpha: isDark ? 0.16 : 0.11,
                      ),
                      theme.scaffoldBackgroundColor,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProfileHeader(),
                  const SizedBox(height: 16),
                  const PremiumStats(),
                  const SizedBox(height: 28),

                  _buildSectionHeader(
                    l10n.appSettings,
                    Icons.tune_rounded,
                    theme,
                  ),
                  const SizedBox(height: 12),
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
                      activeThumbColor: AppColors.warmOrange,
                      activeTrackColor: AppColors.warmOrange.withValues(
                        alpha: 0.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),
                  _buildSectionHeader(
                    l10n.account,
                    Icons.person_outline_rounded,
                    theme,
                  ),
                  const SizedBox(height: 12),
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

                  const SizedBox(height: 28),
                  _buildSectionHeader(
                    l10n.privacySecurity,
                    Icons.security_rounded,
                    theme,
                  ),
                  const SizedBox(height: 12),
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

                  const SizedBox(height: 28),
                  _buildElegantLogout(theme, l10n),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, color: AppColors.warmOrange, size: 20),
        const SizedBox(width: 12),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildElegantLogout(ThemeData theme, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.14)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.signOut,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
