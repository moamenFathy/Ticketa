import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketa/core/constants/app_constants.dart';
import 'package:ticketa/features/booking/data/models/seat_dto.dart';
import 'package:ticketa/features/booking/presentation/cubit/booking_state.dart';
import 'package:ticketa/features/booking/presentation/widgets/seat_selection_dialogs.dart';
import 'package:ticketa/features/home/data/models/movie.dart';
import 'package:ticketa/features/payment/presentation/screens/payment_page.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class SeatSelectionBottomBar extends StatelessWidget {
  final SeatMapLoaded state;
  final double totalPrice;
  final String movieTitle;
  final int showtimeId;
  final ShowtimeInfo? activeShowtime;
  final String? moviePoster;
  final String hallName;

  const SeatSelectionBottomBar({
    super.key,
    required this.state,
    required this.totalPrice,
    required this.movieTitle,
    required this.showtimeId,
    this.activeShowtime,
    this.moviePoster,
    this.hallName = '',
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final hasSeats = state.selectedSeats.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              '${state.selectedSeats.length}',
              style: theme.textTheme.titleLarge,
            ),
          ),
          Builder(
            builder: (ctx) => GestureDetector(
              onTap: hasSeats
                  ? () async {
                      final prefs = await SharedPreferences.getInstance();
                      final isLoggedIn =
                          prefs.getBool(AppConstants.isLoggedInKey) ?? false;
                      final token = prefs.getString(AppConstants.tokenKey);
                      if (!isLoggedIn || token == null || token.isEmpty) {
                        if (ctx.mounted) {
                          await SeatSelectionDialogs.showSignInRequired(ctx);
                        }
                        return;
                      }
                      if (!ctx.mounted) return;
                      final pendingSeats = state.selectedSeats.map((id) {
                        final parts = id.split('_');
                        return SeatDto(
                          row: int.tryParse(parts[0]) ?? 0,
                          seatNumber: int.tryParse(parts[1]) ?? 0,
                        );
                      }).toList();

                      final active = activeShowtime;
                      Navigator.push(
                        ctx,
                        MaterialPageRoute(
                          builder: (_) => PaymentPage(
                            totalAmount: totalPrice,
                            movieTitle: movieTitle,
                            seats: pendingSeats,
                            date: active != null
                                ? DateFormat('dd MMM yyyy').format(active.startTime)
                                : '',
                            time: active != null
                                ? DateFormat('h:mm a').format(active.startTime)
                                : '',
                            showtimeId: active?.id ?? showtimeId,
                            moviePoster: moviePoster,
                            hallName: hallName,
                          ),
                        ),
                      );
                    }
                  : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                decoration: BoxDecoration(
                  color: hasSeats
                      ? theme.colorScheme.primary
                      : theme.dividerColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  l10n.buyFor(totalPrice.toStringAsFixed(0)),
                  style: TextStyle(
                    color: hasSeats
                        ? Colors.white
                        : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
