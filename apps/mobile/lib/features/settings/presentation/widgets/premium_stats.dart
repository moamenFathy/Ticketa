import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class PremiumStats extends StatelessWidget {
  const PremiumStats({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

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
}
