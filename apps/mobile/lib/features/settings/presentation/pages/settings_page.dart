import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/main.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: 40),
          _buildSectionTitle("App Settings"),
          const SizedBox(height: 16),
          _buildSettingTile(
            icon: Icons.language_rounded,
            title: "Language",
            subtitle: "Change app language (Arabic/English)",
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            onTap: () {
              final currentLocale = Localizations.localeOf(context);
              final newLocale = currentLocale.languageCode == 'en'
                  ? const Locale('ar')
                  : const Locale('en');
              MyApp.of(context)?.setLocale(newLocale);
            },
          ),
          const SizedBox(height: 16),
          _buildSettingTile(
            icon: isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
            title: "Dark Mode",
            subtitle: "Toggle between dark and light themes",
            trailing: Switch(
              value: isDark,
              onChanged: (val) {
                // Future implementation for theme toggle
              },
              activeColor: AppColors.warmOrange,
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionTitle("Account"),
          const SizedBox(height: 16),
          _buildSettingTile(
            icon: Icons.notifications_none_rounded,
            title: "Notifications",
            subtitle: "Manage your alerts and reminders",
          ),
          const SizedBox(height: 16),
          _buildSettingTile(
            icon: Icons.security_rounded,
            title: "Privacy & Security",
            subtitle: "Security settings and privacy policy",
          ),
          const SizedBox(height: 40),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Sign Out", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.warmOrange.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.warmOrange, width: 2),
          ),
          child: const Center(
            child: Text(
              "M",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.warmOrange,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mohamed Ahmed",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Text(
              "mohamed@example.com",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppColors.warmOrange,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      tileColor: AppColors.warmOrange.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      leading: Icon(icon, color: AppColors.warmOrange),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: trailing,
    );
  }
}