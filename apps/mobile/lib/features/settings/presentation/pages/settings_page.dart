import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/main.dart';
import 'package:ticketa/l10n/app_localizations.dart';

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
          // Premium Header
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image/Gradient
                  Image.network(
                    "https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&q=80&w=1000",
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          theme.scaffoldBackgroundColor.withOpacity(0.8),
                          theme.scaffoldBackgroundColor,
                        ],
                      ),
                    ),
                  ),
                  // Profile Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildAnimatedAvatar(theme),
                        const SizedBox(height: 12),
                        Text(
                          "Mohamed Ahmed",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          "mohamed@ticketa.com",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Section
                  _buildPremiumStats(theme, l10n),
                  const SizedBox(height: 32),

                  // App Settings Section
                  _buildSectionTitle(l10n.appSettings, theme),
                  const SizedBox(height: 16),
                  _buildGlassTile(
                    theme: theme,
                    icon: Icons.translate_rounded,
                    title: l10n.language,
                    subtitle: l10n.changeLanguage,
                    trailing: _buildLanguageSelector(context, theme, l10n),
                  ),
                  const SizedBox(height: 12),
                  _buildGlassTile(
                    theme: theme,
                    icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    title: l10n.darkMode,
                    subtitle: l10n.toggleDarkLight,
                    trailing: Switch.adaptive(
                      value: isDark,
                      onChanged: (val) {
                        MyApp.setTheme(context, val ? ThemeMode.dark : ThemeMode.light);
                      },
                      activeColor: AppColors.warmOrange,
                    ),
                  ),

                  const SizedBox(height: 32),
                  // Account Section
                  _buildSectionTitle(l10n.account, theme),
                  const SizedBox(height: 16),
                  _buildGlassTile(
                    theme: theme,
                    icon: Icons.confirmation_number_outlined,
                    title: l10n.myTickets,
                    subtitle: "12 active bookings",
                  ),
                  const SizedBox(height: 12),
                  _buildGlassTile(
                    theme: theme,
                    icon: Icons.notifications_none_rounded,
                    title: l10n.notifications,
                    subtitle: l10n.manageNotifications,
                  ),
                  const SizedBox(height: 12),
                  _buildGlassTile(
                    theme: theme,
                    icon: Icons.security_rounded,
                    title: l10n.privacySecurity,
                    subtitle: l10n.privacyPolicy,
                  ),

                  const SizedBox(height: 48),
                  // Logout Button
                  _buildPremiumLogout(theme, l10n),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedAvatar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.warmOrange, Colors.orangeAccent],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warmOrange.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: const CircleAvatar(
        radius: 45,
        backgroundColor: Colors.white10,
        backgroundImage: NetworkImage("https://api.dicebear.com/7.x/avataaars/svg?seed=Felix"),
      ),
    );
  }

  Widget _buildPremiumStats(ThemeData theme, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(child: _buildStatItem(theme, "12", l10n.totalTickets, Icons.local_activity_outlined)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatItem(theme, "850", "Points", Icons.stars_rounded)),
      ],
    );
  }

  Widget _buildStatItem(ThemeData theme, String val, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.warmOrange, size: 24),
          const SizedBox(height: 8),
          Text(
            val,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.textTheme.labelSmall?.color?.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppColors.warmOrange,
        ),
      ),
    );
  }

  Widget _buildGlassTile({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.warmOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: AppColors.warmOrange, size: 22),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
          ),
        ),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    final currentLocale = Localizations.localeOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.warmOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentLocale.languageCode,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.warmOrange),
          style: const TextStyle(color: AppColors.warmOrange, fontWeight: FontWeight.bold, fontSize: 13),
          onChanged: (String? newValue) {
            if (newValue != null) {
              MyApp.setLocale(context, Locale(newValue));
            }
          },
          items: <String>['en', 'ar'].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value.toUpperCase()),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPremiumLogout(ThemeData theme, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [Colors.red.shade900.withOpacity(0.1), Colors.red.shade400.withOpacity(0.05)],
        ),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 22),
        label: Text(
          l10n.signOut,
          style: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}