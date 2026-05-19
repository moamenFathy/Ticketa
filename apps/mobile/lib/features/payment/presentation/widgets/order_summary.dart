import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/widgets/glass_card.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class OrderSummary extends StatelessWidget {
  final String movieTitle;
  final String date;
  final String time;
  final List<String> selectedSeats;
  final double totalAmount;

  const OrderSummary({
    super.key,
    required this.movieTitle,
    required this.date,
    required this.time,
    required this.selectedSeats,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.orderSummary,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.warmOrange,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const Icon(Icons.receipt_long_rounded, color: AppColors.warmOrange, size: 18),
            ],
          ),
          Divider(height: 30, color: theme.colorScheme.onSurface.withOpacity(0.1)),
          _summaryRow(l10n.movie, movieTitle, theme),
          const SizedBox(height: 12),
          _summaryRow(l10n.date, "$date | $time", theme),
          const SizedBox(height: 12),
          _summaryRow(l10n.seats, selectedSeats.join(", "), theme),
          Divider(height: 30, color: theme.colorScheme.onSurface.withOpacity(0.1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.total, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              Text(
                "${totalAmount.toStringAsFixed(0)} EGP",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.warmOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5), fontWeight: FontWeight.w600)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface),
          ),
        ),
      ],
    );
  }
}
