import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class BookingConfirmationPage extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingConfirmationPage({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final movieTitle = bookingData['movie'] ?? l10n.unknownMovie;
    final seats = (bookingData['seats'] as List<String>).join(', ');
    final total = bookingData['total'] ?? 0.0;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.yourTicket, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline_rounded,
                color: Colors.green, size: 80),
            const SizedBox(height: 16),
            Text(
              l10n.bookingConfirmed,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.enjoyYourMovie,
              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // Digital Ticket
            _buildDigitalTicket(context, l10n, movieTitle, seats, total),
            const SizedBox(height: 60),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warmOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(l10n.backToHome, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitalTicket(BuildContext context, AppLocalizations l10n, String movie, String seats, double total) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          // Movie Header
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.warmOrange,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Row(
              children: [
                const Icon(Icons.movie_creation_outlined, color: Colors.white, size: 40),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.movie,
                        style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        movie,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Ticket Details
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                _buildTicketRow(theme, l10n.seats, seats),
                const SizedBox(height: 20),
                _buildTicketRow(theme, l10n.date, "Oct 24, 2023"),
                const SizedBox(height: 20),
                _buildTicketRow(theme, l10n.time, "08:30 PM"),
                const SizedBox(height: 32),
                Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.totalPayment,
                      style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "E£ ${total.toStringAsFixed(2)}",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.warmOrange,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // QR Code
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: CachedNetworkImage(
                    imageUrl: "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=TICKETA-$movie-$seats",
                    height: 150,
                    width: 150,
                    memCacheWidth: 150,
                    memCacheHeight: 150,
                    placeholder: (_, _) => Icon(Icons.qr_code, size: 80, color: Colors.grey),
                    errorWidget: (_, _, _) => Icon(Icons.qr_code, size: 80, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketRow(ThemeData theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontWeight: FontWeight.bold)),
        Text(value, style: TextStyle(fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface)),
      ],
    );
  }
}