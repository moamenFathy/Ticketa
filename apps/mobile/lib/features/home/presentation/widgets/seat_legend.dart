import 'package:flutter/material.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class SeatLegend extends StatelessWidget {
  const SeatLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendItem(l10n.available, theme.colorScheme.onSurface.withOpacity(0.1), theme),
          _legendItem(l10n.selected, const Color(0xFF4CAF50), theme),
          _legendItem(l10n.occupied, Colors.amber, theme),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          CircleAvatar(radius: 5, backgroundColor: color),
          const SizedBox(width: 5),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
