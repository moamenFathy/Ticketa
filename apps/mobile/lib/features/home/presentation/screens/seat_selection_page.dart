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
  final double _pricePerSeat = 120.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
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

            const SizedBox(height: 30),

            // Screen & Seats Area
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width * 0.9, 250),
                    painter: CinemaScreenPainter(color: theme.colorScheme.primary),
                  ),
                  Positioned(
                    top: 35,
                    child: Column(
                      children: [
                        Icon(Icons.keyboard_arrow_up_rounded, color: theme.colorScheme.onBackground.withOpacity(0.5), size: 24),
                        Text(
                          l10n.screen.toUpperCase(),
                          style: TextStyle(
                            color: theme.colorScheme.onBackground.withOpacity(0.5),
                            fontSize: 9,
                            letterSpacing: 6,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 90,
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

            // Legend
            const SeatLegend(),

            // Bottom Action Bar
            _buildBottomAction(l10n, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(AppLocalizations l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: () => Navigator.pop(context),
              child: _buildCircleBtn(Icons.arrow_back_ios_new, theme)),
          Text(l10n.selectSeats, style: theme.textTheme.titleLarge),
          _buildCircleBtn(Icons.more_vert, theme),
        ],
      ),
    );
  }

  Widget _buildBottomAction(AppLocalizations l10n, ThemeData theme) {
    double total = _selectedSeats.length * _pricePerSeat;
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
                color: _selectedSeats.isEmpty ? theme.dividerColor.withOpacity(0.1) : theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                l10n.buyFor(total.toStringAsFixed(0)),
                style: TextStyle(
                  color: _selectedSeats.isEmpty ? theme.colorScheme.onSurface.withOpacity(0.2) : Colors.white,
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