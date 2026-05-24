import 'package:flutter/material.dart';
import 'package:ticketa/features/payment/presentation/screens/payment_page.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../widgets/seat_legend.dart';
import '../widgets/cinema_seat_grid.dart';
import '../widgets/time_selector.dart';
import '../widgets/seat_date_selector.dart';
import '../widgets/cinema_screen_painter.dart';

class SeatSelectionPage extends StatefulWidget {
  final String movieTitle;
  const SeatSelectionPage({super.key, required this.movieTitle});

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 1;

  final List<String> _selectedSeats = [];
  final double _regularPrice = 120.0;
  final double _vipPrice = 180.0;

  double get _totalPrice {
    double total = 0;
    for (final seat in _selectedSeats) {
      total += seat.startsWith("VIP") ? _vipPrice : _regularPrice;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final mq = MediaQuery.of(context);
    final painterHeight = mq.size.height * 0.12;
    final screenTextTop = painterHeight * 0.35;

    return Scaffold(
      body: SafeArea(
        child: PopScope(
          canPop: _selectedSeats.isEmpty,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) {
              _showExitDialog(context, l10n);
            }
          },
          child: Column(
            children: [
            // Header
            _buildAppBar(l10n, theme),

            const SizedBox(height: 10),

            // Dates Section
            SeatDateSelector(
              selectedIndex: _selectedDateIndex,
              onDateSelected: (index) {
                setState(() => _selectedDateIndex = index);
              },
            ),

            const SizedBox(height: 20),

            // Times Section
            TimeSelector(
              selectedIndex: _selectedTimeIndex,
              onTimeSelected: (index) {
                setState(() => _selectedTimeIndex = index);
              },
            ),

            const SizedBox(height: 8),

            // Screen & Seats Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: painterHeight,
                      child: CustomPaint(
                        painter: CinemaScreenPainter(color: theme.colorScheme.primary, isDark: isDark),
                      ),
                    ),
                    Positioned(
                      top: screenTextTop,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.keyboard_arrow_up_rounded, color: theme.colorScheme.onSurface.withValues(alpha: 0.4), size: 20),
                            Text(
                              l10n.screen.toUpperCase(),
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                fontSize: 9,
                                letterSpacing: 6,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: painterHeight,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: CinemaSeatGrid(
                        selectedSeats: _selectedSeats,
                        onSeatToggled: (seatId) {
                          setState(() {
                            if (_selectedSeats.contains(seatId)) {
                              _selectedSeats.remove(seatId);
                            } else {
                              _selectedSeats.add(seatId);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Legend
            const SeatLegend(),

            // Bottom Action Bar
            _buildBottomAction(l10n, theme),
          ],
        ),
      ),
      ),
    );
  }

  Future<void> _showExitDialog(BuildContext context, AppLocalizations l10n) async {
    final theme = Theme.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.exit_to_app_rounded,
                color: theme.colorScheme.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.confirmExitTitle,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.confirmExitMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
        actions: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                l10n.confirmExitNo,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                backgroundColor: theme.colorScheme.primary,
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(
                l10n.confirmExitYes,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
    if (result == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildAppBar(AppLocalizations l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: () {
                if (_selectedSeats.isNotEmpty) {
                  _showExitDialog(context, l10n);
                } else {
                  Navigator.pop(context);
                }
              },
              child: _buildCircleBtn(Icons.arrow_back_ios_new, theme)),
          Text(l10n.selectSeats, style: theme.textTheme.titleLarge),
          _buildCircleBtn(Icons.more_vert, theme),
        ],
      ),
    );
  }

  Widget _buildBottomAction(AppLocalizations l10n, ThemeData theme) {
    double total = _totalPrice;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(30)),
            child: Text(
              "${_selectedSeats.length}",
              style: theme.textTheme.titleLarge,
            ),
          ),
          GestureDetector(
            onTap: _selectedSeats.isEmpty ? null : () {
              final now = DateTime.now();
              final selectedDate = now.add(Duration(days: _selectedDateIndex));
              final dateStr = DateFormat('dd MMM yyyy').format(selectedDate);
              final timeStr = const ["08:00", "10:30", "14:00", "18:45"][_selectedTimeIndex];

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    totalAmount: total,
                    movieTitle: widget.movieTitle,
                    selectedSeats: _selectedSeats,
                    date: dateStr,
                    time: timeStr,
                  ),
                ),
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              decoration: BoxDecoration(
                color: _selectedSeats.isEmpty ? theme.dividerColor.withValues(alpha: 0.1) : theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                l10n.buyFor(total.toStringAsFixed(0)),
                style: TextStyle(
                  color: _selectedSeats.isEmpty ? theme.colorScheme.onSurface.withValues(alpha: 0.2) : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleBtn(IconData icon, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: theme.colorScheme.surface, shape: BoxShape.circle),
      child: Icon(icon, color: theme.colorScheme.onSurface, size: 20),
    );
  }
}