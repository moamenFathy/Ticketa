import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticketa/core/widgets/glass_card.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class TicketCard extends StatelessWidget {
  final String movieTitle;
  final String date;
  final String time;
  final List<String> seats;
  final double totalAmount;
  final String? bookingReference;

  const TicketCard({
    super.key,
    required this.movieTitle,
    required this.date,
    required this.time,
    required this.seats,
    required this.totalAmount,
    this.bookingReference,
  });

  String get _ticketId {
    final ref = bookingReference;
    if (ref != null && ref.isNotEmpty) return ref;
    return 'TICKETA-${DateTime.now().millisecondsSinceEpoch}';
  }

  String get _ticketUrl =>
      'https://ticketa-client.vercel.app/bookings/$_ticketId';

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
                  width: 150,
                  height: 150,
                  padding: const EdgeInsets.all(10),
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
                  child: QrImageView(
                    data: _ticketUrl,
                    version: QrVersions.auto,
                    size: 130,
                    backgroundColor: Colors.white,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: Colors.black,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${l10n.ticketId}: #$_ticketId',
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