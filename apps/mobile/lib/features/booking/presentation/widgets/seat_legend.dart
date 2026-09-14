import 'package:flutter/material.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class SeatLegend extends StatelessWidget {
  const SeatLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendItem(l10n.available, theme.colorScheme.onSurface.withValues(alpha: 0.12), theme),
          _legendItem(l10n.selected, const Color(0xFF4CAF50), theme),
          _legendItem(l10n.occupied, Colors.yellow, theme),
          _legendItem(l10n.vip, const Color(0xFFE67E22), theme),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 4),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}
