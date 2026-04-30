import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:ticketa/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class SeatSelectionPage extends StatefulWidget {
  const SeatSelectionPage({super.key});

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage>{
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 1;
  
  final List<String> _selectedSeats = [];
  final double _pricePerSeat = 120.0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildAppBar(l10n, theme),
            
            const SizedBox(height: 10),
            
            // Dates Section
            _buildUniqueDateSelector(l10n, theme, locale),
            
            const SizedBox(height: 20),
            
            // Times Section
            _buildUniqueTimeSelector(theme),
            
            const SizedBox(height: 30),
            
            // Screen & Seats Area
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width * 0.9, 250),
                    painter: ScreenAndPerspectivePainter(color: theme.colorScheme.primary),
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
                    child: _buildSeatLayout(theme),
                  ),
                ],
              ),
            ),
            
            // Legend
            _buildLegend(l10n, theme),
            
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
            child: _buildCircleBtn(Icons.arrow_back_ios_new, theme)
          ),
          Text(l10n.selectSeats, style: theme.textTheme.titleLarge),
          _buildCircleBtn(Icons.more_vert, theme),
        ],
      ),
    );
  }

  Widget _buildUniqueDateSelector(AppLocalizations l10n, ThemeData theme, String locale) {
    final now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
          child: Text(
            DateFormat.MMMM(locale).format(now).toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 3, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: 14,
            itemBuilder: (context, index) {
              final date = now.add(Duration(days: index));
              bool isSelected = index == _selectedDateIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedDateIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 75,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ] : [],
                  ),
                  child: Stack(
                    children: [
                      _buildFilmHoles(theme),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat.E(locale).format(date).toUpperCase(),
                              style: TextStyle(
                                color: isSelected ? Colors.white70 : theme.colorScheme.onSurface.withOpacity(0.3),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              date.day.toString(),
                              style: TextStyle(
                                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -1,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilmHoles(ThemeData theme) {
    final holeColor = theme.brightness == Brightness.dark ? Colors.black26 : Colors.white24;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (i) => Container(width: 6, height: 6, decoration: BoxDecoration(color: holeColor, borderRadius: BorderRadius.circular(2)))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(3, (i) => Container(width: 6, height: 6, decoration: BoxDecoration(color: holeColor, borderRadius: BorderRadius.circular(2)))),
          ),
        ),
      ],
    );
  }

  Widget _buildUniqueTimeSelector(ThemeData theme) {
    List<String> times = ["08:00", "10:30", "14:00", "18:45"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: times.asMap().entries.map((entry) {
        int index = entry.key;
        bool isSelected = index == _selectedTimeIndex;
        return GestureDetector(
          onTap: () => setState(() => _selectedTimeIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? theme.colorScheme.primary : theme.dividerColor.withOpacity(0.1),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              entry.value,
              style: TextStyle(
                color: isSelected ? theme.colorScheme.onBackground : theme.colorScheme.onBackground.withOpacity(0.3),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeatLayout(ThemeData theme) {
    return Column(
      children: List.generate(7, (row) {
        int seatsInRow = 8 + (row % 2); 
        return Padding(
          padding: EdgeInsets.only(bottom: 15, left: row * 5.0, right: row * 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(seatsInRow, (col) {
              String seatId = "$row-$col";
              bool isSelected = _selectedSeats.contains(seatId);
              bool isReserved = (row == 2 && col == 3) || (row == 4 && col == 4);
              
              Color seatColor = theme.colorScheme.onSurface.withOpacity(0.1);
              if (isReserved) seatColor = Colors.amber; // Yellow/Amber for reserved
              if (isSelected) seatColor = const Color(0xFF4CAF50); // Green for selected
              
              return GestureDetector(
                onTap: isReserved ? null : () {
                  setState(() {
                    if (isSelected) {
                      _selectedSeats.remove(seatId);
                    } else {
                      _selectedSeats.add(seatId);
                    }
                  });
                },
                child: _CinemaSeat(color: seatColor),
              );
            }),
          ),
        );
      }),
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
              style: theme.textTheme.titleLarge
            ),
          ),
          GestureDetector(
            onTap: _selectedSeats.isEmpty ? null : () {},
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              decoration: BoxDecoration(
                color: _selectedSeats.isEmpty ? theme.dividerColor.withOpacity(0.1) : theme.colorScheme.primary, 
                borderRadius: BorderRadius.circular(30)
              ),
              child: Text(
                l10n.buyFor(total.toStringAsFixed(0)), 
                style: TextStyle(
                  color: _selectedSeats.isEmpty ? theme.colorScheme.onSurface.withOpacity(0.2) : Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 16
                )
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(AppLocalizations l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _legendItem(l10n.available, theme.colorScheme.onSurface.withOpacity(0.1), theme),
          _legendItem(l10n.selected, const Color(0xFF4CAF50), theme),
          _legendItem(l10n.occupied, Colors.amber, theme),
        ],
      ),
    );
  }

  Widget _legendItem(String label, Color color, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          CircleAvatar(radius: 5, backgroundColor: color),
          const SizedBox(width: 5),
          Text(label, style: theme.textTheme.bodySmall),
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

class _CinemaSeat extends StatelessWidget {
  final Color color;
  const _CinemaSeat({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 30,
      height: 28,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 22,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 30,
              height: 10,
              decoration: BoxDecoration(
                color: color.withOpacity(0.8),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Positioned(
            top: 4,
            child: Container(
              width: 20,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenAndPerspectivePainter extends CustomPainter {
  final Color color;
  ScreenAndPerspectivePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.moveTo(size.width * 0.05, 35);
    path.quadraticBezierTo(size.width * 0.5, -15, size.width * 0.95, 35);
    canvas.drawPath(path, paint);

    var shadowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.3), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 35, size.width, size.height));

    var shadowPath = Path();
    shadowPath.moveTo(size.width * 0.05, 35);
    shadowPath.quadraticBezierTo(size.width * 0.5, -15, size.width * 0.95, 35);
    shadowPath.lineTo(size.width * 1.1, size.height); 
    shadowPath.lineTo(size.width * -0.1, size.height);
    shadowPath.close();
    canvas.drawPath(shadowPath, shadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}