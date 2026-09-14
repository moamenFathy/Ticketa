import 'package:flutter/material.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class SeatSelectionAppBar extends StatelessWidget {
  final VoidCallback onBack;

  const SeatSelectionAppBar({super.key, required this.onBack});

  Widget _buildCircleBtn(IconData icon, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: theme.colorScheme.onSurface, size: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onBack,
            child: _buildCircleBtn(
              isRtl
                  ? Icons.arrow_forward_ios_rounded
                  : Icons.arrow_back_ios_new_rounded,
              theme,
            ),
          ),
          Text(l10n.selectSeats, style: theme.textTheme.titleLarge),
          _buildCircleBtn(Icons.more_vert, theme),
        ],
      ),
    );
  }
}
