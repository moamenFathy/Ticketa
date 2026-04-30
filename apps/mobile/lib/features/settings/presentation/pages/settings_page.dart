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

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.account, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_note_rounded, color: theme.colorScheme.primary),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 10),
          _buildProfileHeader(theme, l10n),
          const SizedBox(height: 32),
          _buildStatsRow(theme, l10n),
          const SizedBox(height: 40),
          
          _buildSectionHeader(l10n.appSettings, theme),
          const SizedBox(height: 12),
          _buildLanguageDropdownTile(context, theme, l10n),
          const SizedBox(height: 12),
          _buildSettingTile(
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
          _buildSectionHeader(l10n.account, theme),
          const SizedBox(height: 12),
          _buildSettingTile(
            theme: theme,
            icon: Icons.confirmation_number_outlined,
            title: l10n.myTickets,
            subtitle: "Manage your bookings",
          ),
          const SizedBox(height: 12),
          _buildSettingTile(
            theme: theme,
            icon: Icons.notifications_none_rounded,
            title: l10n.notifications,
            subtitle: l10n.manageNotifications,
          ),
          const SizedBox(height: 12),
          _buildSettingTile(
            theme: theme,
            icon: Icons.verified_user_outlined,
            title: l10n.privacySecurity,
            subtitle: l10n.privacyPolicy,
          ),
          
          const SizedBox(height: 48),
          _buildSignOutButton(theme, l10n),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme, AppLocalizations l10n) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.warmOrange.withOpacity(0.2), width: 1),
          ),
          child: const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage("https://api.dicebear.com/7.x/avataaars/svg?seed=Felix"),
            backgroundColor: Colors.transparent,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Mohamed Ahmed",
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatsRow(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: SizedBox(
        width: 160,
        child: _buildStatCard(theme, "12", l10n.totalTickets, Icons.local_activity_outlined),
      ),
    );
  }

  Widget _buildLanguageDropdownTile(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    final currentLocale = Localizations.localeOf(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.translate_rounded, color: theme.colorScheme.primary, size: 20),
        ),
        title: Text(l10n.language, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(l10n.changeLanguage, style: theme.textTheme.bodySmall?.copyWith(fontSize: 11)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentLocale.languageCode,
              icon: Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: theme.colorScheme.primary),
              elevation: 16,
              style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
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
        ),
      ),
    );
  }

  Widget _buildStatCard(ThemeData theme, String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: theme.colorScheme.primary.withOpacity(0.5), size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.textTheme.labelSmall?.color?.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required ThemeData theme,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      tileColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: theme.colorScheme.primary, size: 20),
      ),
      title: Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(fontSize: 11)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 12),
    );
  }

  Widget _buildSignOutButton(ThemeData theme, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
        label: Text(
          l10n.signOut,
          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}