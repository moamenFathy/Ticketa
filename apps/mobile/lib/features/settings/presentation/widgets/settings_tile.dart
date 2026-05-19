import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
}
