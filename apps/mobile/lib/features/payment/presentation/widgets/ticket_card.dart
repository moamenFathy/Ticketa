import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ticketa/core/widgets/glass_card.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class TicketCard extends StatelessWidget {
  final String movieTitle;
  final String date;
  final String time;
  final List<String> seats;
  final double totalAmount;

  const TicketCard({
    super.key,
    required this.movieTitle,
    required this.date,
    required this.time,
    required this.seats,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _ticketRow(l10n.movie, movieTitle, theme),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _ticketRow(l10n.date, date, theme)),
                    Expanded(child: _ticketRow(l10n.time, time, theme)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _ticketRow(l10n.seats, seats.join(", "), theme)),
                    Expanded(child: _ticketRow(l10n.total, "${totalAmount.toStringAsFixed(0)} EGP", theme)),
                  ],
                ),
              ],
            ),
          ),
          
          // Dash Divider
          Row(
            children: List.generate(
              15,
              (index) => Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 1,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                ),
              ),
            ),
          ),
          
          // QR Code Area
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 140,
                  height: 140,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: CachedNetworkImage(
                    imageUrl: "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=TICKETA-${DateTime.now().millisecondsSinceEpoch}",
                    fit: BoxFit.contain,
                    memCacheWidth: 150,
                    memCacheHeight: 150,
                    placeholder: (_, _) => Icon(Icons.qr_code, size: 60, color: Colors.grey),
                    errorWidget: (_, _, _) => Icon(Icons.qr_code, size: 60, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "${l10n.ticketId}: #${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2), 
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ticketRow(String label, String value, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface)),
      ],
    );
  }
}
