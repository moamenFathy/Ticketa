import 'dart:ui';
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Premium Cinematic Header
          SliverAppBar(
            expandedHeight: size.height * 0.45,
            pinned: true,
            stretch: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background with Blur Overlay
                  Image.network(
                    "https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?q=80&w=2670&auto=format&fit=crop",
                    fit: BoxFit.cover,
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(color: (isDark ? Colors.black : Colors.white).withOpacity(0.3)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.2, 0.9, 1.0],
                        colors: [
                          (isDark ? Colors.black : Colors.white).withOpacity(0.4),
                          (isDark ? Colors.black : Colors.white).withOpacity(0.8),
                          theme.scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                  // Profile Details
                  const ProfileHeader(),
                ],
              ),
            ),
          ),

          // Main Account Dashboard
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dashboard Stats
                  const PremiumStats(),
                  const SizedBox(height: 40),

                  // Section: Preferences
                  _buildSectionHeader(l10n.appSettings, Icons.tune_rounded, theme),
                  const SizedBox(height: 16),
                  SettingsTile(
                    icon: Icons.language_rounded,
                    title: l10n.language,
                    subtitle: l10n.changeLanguage,
                    trailing: const LanguageSelector(),
                  ),
                  SettingsTile(
                    icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    title: l10n.darkMode,
                    subtitle: l10n.toggleDarkLight,
                    trailing: Switch.adaptive(
                      value: isDark,
                      onChanged: (val) {
                        context.read<ThemeService>().setTheme(val ? ThemeMode.dark : ThemeMode.light);
                      },
                      activeColor: AppColors.warmOrange,
                    ),
                  ),

                  const SizedBox(height: 40),
                  // Section: My Activity
                  _buildSectionHeader(l10n.account, Icons.person_outline_rounded, theme),
                  const SizedBox(height: 16),
                  SettingsTile(
                    icon: Icons.confirmation_number_outlined,
                    title: l10n.myTickets,
                    subtitle: "8 upcoming • 4 past",
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
                  ),

                  const SizedBox(height: 40),
                  // Section: Security & Legal
                  _buildSectionHeader("Security & Legal", Icons.security_rounded, theme),
                  const SizedBox(height: 16),
                  const SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: "Password",
                    subtitle: "Update your credentials",
                  ),
                  SettingsTile(
                    icon: Icons.description_outlined,
                    title: l10n.privacyPolicy,
                    subtitle: "Read our terms of service",
                  ),

                  const SizedBox(height: 48),
                  // Logout Button
                  _buildElegantLogout(theme, l10n),
                  const SizedBox(height: 120),
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
            color: theme.colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildElegantLogout(ThemeData theme, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.redAccent.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Text(
            l10n.signOut.toUpperCase(),
            style: const TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}