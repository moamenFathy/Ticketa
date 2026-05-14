import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/widgets/glass_card.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class BookingSuccessPage extends StatelessWidget {
  final String movieTitle;
  final String date;
  final String time;
  final List<String> seats;
  final double totalAmount;

  const BookingSuccessPage({
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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Success Animation/Icon
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 80),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.bookingSuccess,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Enjoy your movie!",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Ticket Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: _buildTicketCard(l10n, theme, isDark),
              ),
              
              const SizedBox(height: 40),
              
              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    _buildButton(
                      l10n.downloadTicket,
                      Icons.file_download_outlined,
                      AppColors.warmOrange,
                      Colors.white,
                      () {},
                    ),
                    const SizedBox(height: 16),
                    _buildButton(
                      l10n.backToHome,
                      null,
                      theme.colorScheme.surface,
                      theme.colorScheme.onSurface.withOpacity(0.6),
                      () => Navigator.of(context).popUntil((route) => route.isFirst),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketCard(AppLocalizations l10n, ThemeData theme, bool isDark) {
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
                    Expanded(child: _ticketRow("Time", time, theme)),
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
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
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
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Image.network(
                    "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=TICKETA-${DateTime.now().millisecondsSinceEpoch}",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "TICKET ID: #${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.2), 
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
        Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5), fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w900, color: theme.colorScheme.onSurface)),
      ],
    );
  }

  Widget _buildButton(String label, IconData? icon, Color bgColor, Color textColor, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 10),
            ],
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
