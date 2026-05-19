import 'package:flutter/material.dart';

class CinemaSeatGrid extends StatelessWidget {
  final List<String> selectedSeats;
  final Function(String) onSeatToggled;

  const CinemaSeatGrid({
    super.key,
    required this.selectedSeats,
    required this.onSeatToggled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: List.generate(7, (row) {
        int seatsInRow = 8 + (row % 2);
        return Padding(
          padding: EdgeInsets.only(bottom: 15, left: row * 5.0, right: row * 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(seatsInRow, (col) {
              String seatId = "$row-$col";
              bool isSelected = selectedSeats.contains(seatId);
              bool isReserved = (row == 2 && col == 3) || (row == 4 && col == 4);

              Color seatColor = theme.colorScheme.onSurface.withOpacity(0.1);
              if (isReserved) seatColor = Colors.amber; // Yellow/Amber for reserved
              if (isSelected) seatColor = const Color(0xFF4CAF50); // Green for selected

              return GestureDetector(
                onTap: isReserved ? null : () => onSeatToggled(seatId),
                child: _CinemaSeat(color: seatColor),
              );
            }),
          ),
        );
      }),
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
