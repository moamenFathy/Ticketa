import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class PremiumStats extends StatelessWidget {
  const PremiumStats({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmOrange,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.warmOrange.withValues(alpha: 0.24),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStat(
              icon: Icons.confirmation_number_rounded,
              value: "12",
              label: l10n.totalTickets,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _buildStat(
              icon: Icons.stars_rounded,
              value: "850",
              label: l10n.points,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _buildStat(
              icon: Icons.rate_review_rounded,
              value: "4",
              label: l10n.reviews,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.72),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 58,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white.withValues(alpha: 0.18),
    );
  }
}
