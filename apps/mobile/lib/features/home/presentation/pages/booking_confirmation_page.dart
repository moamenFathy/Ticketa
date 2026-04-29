import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/widgets/glass_card.dart';

class BookingConfirmationPage extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingConfirmationPage({super.key, required this.bookingData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final movieTitle = bookingData['movie'] ?? 'Unknown Movie';
    final seats = (bookingData['seats'] as List<String>).join(', ');
    final total = bookingData['total'] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Ticket"),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.check_circle_outline_rounded,
                color: Colors.green, size: 80),
            const SizedBox(height: 16),
            Text(
              "Booking Confirmed!",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Enjoy your movie!",
              style: TextStyle(color: theme.colorScheme.onBackground.withOpacity(0.5)),
            ),
            const SizedBox(height: 40),
            // Digital Ticket
            _buildDigitalTicket(context, movieTitle, seats, total),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitalTicket(BuildContext context, String movie, String seats, double total) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                      const Text(
                        "Movie",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Text(
                        movie,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
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
                _buildTicketRow("Seats", seats),
                const SizedBox(height: 20),
                _buildTicketRow("Date", "Oct 24, 2023"),
                const SizedBox(height: 20),
                _buildTicketRow("Time", "08:30 PM"),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Payment",
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "EGP ${total.toStringAsFixed(2)}",
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.warmOrange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Dummy QR Code
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Image.network(
                    "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=TICKETA-$movie-$seats",
                    height: 150,
                    width: 150,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}