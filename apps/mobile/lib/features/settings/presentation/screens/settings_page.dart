import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:ticketa/core/services/theme_service.dart';
import 'package:ticketa/core/services/locale_service.dart';
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildAnimatedAvatar(theme, isDark),
                      const SizedBox(height: 20),
                      Text(
                        "MOHAMED AHMED",
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "mohamed@ticketa.com",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 25),
                      _buildEditProfileButton(l10n, theme, isDark),
                      const SizedBox(height: 50),
                    ],
                  ),
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
                  _buildPremiumStats(theme, l10n, isDark),
                  const SizedBox(height: 40),

                  // Section: Preferences
                  _buildSectionHeader(l10n.appSettings, Icons.tune_rounded, theme),
                  const SizedBox(height: 16),
                  _buildPremiumTile(
                    theme: theme,
                    isDark: isDark,
                    icon: Icons.language_rounded,
                    title: l10n.language,
                    subtitle: l10n.changeLanguage,
                    trailing: _buildLanguageSelector(context, theme, l10n, isDark),
                  ),
                  _buildPremiumTile(
                    theme: theme,
                    isDark: isDark,
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
                  _buildPremiumTile(
                    theme: theme,
                    isDark: isDark,
                    icon: Icons.confirmation_number_outlined,
                    title: l10n.myTickets,
                    subtitle: "8 upcoming • 4 past",
                  ),
                  _buildPremiumTile(
                    theme: theme,
                    isDark: isDark,
                    icon: Icons.favorite_border_rounded,
                    title: "Watchlist",
                    subtitle: "15 movies saved",
                  ),
                  _buildPremiumTile(
                    theme: theme,
                    isDark: isDark,
                    icon: Icons.notifications_none_rounded,
                    title: l10n.notifications,
                    subtitle: l10n.manageNotifications,
                  ),

                  const SizedBox(height: 40),
                  // Section: Security & Legal
                  _buildSectionHeader("Security & Legal", Icons.security_rounded, theme),
                  const SizedBox(height: 16),
                  _buildPremiumTile(
                    theme: theme,
                    isDark: isDark,
                    icon: Icons.lock_outline_rounded,
                    title: "Password",
                    subtitle: "Update your credentials",
                  ),
                  _buildPremiumTile(
                    theme: theme,
                    isDark: isDark,
                    icon: Icons.description_outlined,
                    title: l10n.privacyPolicy,
                    subtitle: "Read our terms of service",
                  ),

                  const SizedBox(height: 48),
                  // Logout Button
                  _buildElegantLogout(theme, l10n, isDark),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedAvatar(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.warmOrange, Colors.orangeAccent],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.warmOrange.withOpacity(0.3),
            blurRadius: 25,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: 55,
          backgroundColor: theme.colorScheme.onSurface.withOpacity(0.05),
          child: Icon(
            Icons.person_rounded,
            size: 60,
            color: theme.colorScheme.onSurface.withOpacity(0.2),
          ),
        ),
      ),
    );
  }

  Widget _buildEditProfileButton(AppLocalizations l10n, ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_rounded, color: theme.colorScheme.onSurface, size: 14),
                const SizedBox(width: 8),
                Text(
                  "EDIT PROFILE",
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumStats(ThemeData theme, AppLocalizations l10n, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.03),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCircle("12", l10n.totalTickets, AppColors.warmOrange, theme),
          Container(width: 1, height: 40, color: theme.colorScheme.onSurface.withOpacity(0.1)),
          _buildStatCircle("850", "Points", Colors.blueAccent, theme),
          Container(width: 1, height: 40, color: theme.colorScheme.onSurface.withOpacity(0.1)),
          _buildStatCircle("4", "Reviews", Colors.greenAccent, theme),
        ],
      ),
    );
  }

  Widget _buildStatCircle(String val, String label, Color color, ThemeData theme) {
    return Column(
      children: [
        Text(
          val,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.3),
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ],
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

  Widget _buildPremiumTile({
    required ThemeData theme,
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, color: theme.colorScheme.onSurface.withOpacity(0.7), size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.4),
            fontSize: 12,
          ),
        ),
        trailing: trailing ?? Icon(Icons.chevron_right_rounded, color: theme.colorScheme.onSurface.withOpacity(0.2)),
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, ThemeData theme, AppLocalizations l10n, bool isDark) {
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
          dropdownColor: theme.scaffoldBackgroundColor,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.warmOrange),
          style: const TextStyle(color: AppColors.warmOrange, fontWeight: FontWeight.bold, fontSize: 12),
          onChanged: (String? newValue) {
            if (newValue != null) {
              context.read<LocaleService>().setLocale(Locale(newValue));
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

  Widget _buildElegantLogout(ThemeData theme, AppLocalizations l10n, bool isDark) {
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