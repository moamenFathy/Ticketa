import 'package:flutter/material.dart';
import 'package:ticketa/features/booking/data/models/seat_dto.dart';

class CinemaSeatGrid extends StatelessWidget {
  final int rows;
  final int seatsPerRow;
  final Map<int, String> rowCategoryMap;
  final List<SeatDto> bookedSeats;
  final List<String> selectedSeats;
  final Function(String) onSeatToggled;
  final String hallType;

  const CinemaSeatGrid({
    super.key,
    required this.rows,
    required this.seatsPerRow,
    required this.rowCategoryMap,
    required this.bookedSeats,
    required this.selectedSeats,
    required this.onSeatToggled,
    this.hallType = 'Standard',
  });

  int _leftSeats(int rowNumber) {
    if (hallType == 'Gold') {
      if (rowNumber == 1) return 1;
      if (rowNumber == 6) return 2;
      return 4;
    }
    if (hallType == 'IMAX' && rowNumber == 14) return 6;
    if (rowNumber == 1) return 5;
    if (hallType != 'IMAX' && rowNumber == 12) return 6;
    return 8;
  }

  int _rightSeats(int rowNumber) {
    if (hallType == 'Gold') {
      if (rowNumber == 1) return 1;
      if (rowNumber == 6) return 2;
      return 4;
    }
    if (hallType == 'IMAX' && rowNumber == 14) return 6;
    if (rowNumber == 1) return 5;
    if (hallType != 'IMAX' && rowNumber == 12) return 6;
    return 8;
  }

  bool _isVipRow(int rowNumber) {
    return hallType == 'IMAX' && rowNumber == 14;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bookedSet = bookedSeats.map((s) => s.id).toSet();
    final selectedSet = selectedSeats.toSet();

    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth - 28;
          final maxHeight = constraints.maxHeight;
          final aislesTotal = maxWidth * 0.08;
          final aisleWidth = aislesTotal / 2;

          final availableForSeats = maxWidth - aislesTotal;
          final refCount = hallType == 'Gold' ? 8 : 16;
          final seatUnitWidth = availableForSeats / refCount;
          final rawSeatWidth = seatUnitWidth - 3;
          final maxByHeight = (maxHeight - (rows - 1) * 3) / rows;
          final seatSize = rawSeatWidth.clamp(12.0, maxByHeight.clamp(12.0, 28.0));

          return SingleChildScrollView(
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(rows, (rowIndex) {
              final rowNumber = rowIndex + 1;
              final category = rowCategoryMap[rowNumber] ?? 'Regular';
              final isVip = category == 'VIP' || category == 'Premium' || _isVipRow(rowNumber);
              final leftCount = _leftSeats(rowNumber);
              final rightCount = _rightSeats(rowNumber);

              final rowLetter = String.fromCharCode(65 + rowIndex);

              return Padding(
                padding: EdgeInsets.only(bottom: rowIndex == rows - 1 ? 0 : 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 14,
                      child: Text(
                        rowLetter,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ...List.generate(leftCount, (col) {
                      final seatNumber = col + 1;
                      final id = SeatDto(row: rowNumber, seatNumber: seatNumber).id;
                      return _buildSeat(
                        seatId: id,
                        isBooked: bookedSet.contains(id),
                        selectedSet: selectedSet,
                        theme: theme,
                        isDark: isDark,
                        isVip: isVip,
                        seatSize: seatSize,
                      );
                    }),
                    SizedBox(width: aisleWidth),
                    ...List.generate(rightCount, (col) {
                      final seatNumber = leftCount + col + 1;
                      final id = SeatDto(row: rowNumber, seatNumber: seatNumber).id;
                      return _buildSeat(
                        seatId: id,
                        isBooked: bookedSet.contains(id),
                        selectedSet: selectedSet,
                        theme: theme,
                        isDark: isDark,
                        isVip: isVip,
                        seatSize: seatSize,
                      );
                    }),
                    SizedBox(
                      width: 14,
                      child: Text(
                        rowLetter,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
    ));
  }

  Widget _buildSeat({
    required String seatId,
    required bool isBooked,
    required Set<String> selectedSet,
    required ThemeData theme,
    required bool isDark,
    required bool isVip,
    required double seatSize,
  }) {
    final isSelected = selectedSet.contains(seatId);

    Color seatColor;
    Color borderColor = Colors.transparent;

    if (isBooked) {
      seatColor = Colors.amber.withValues(alpha: 0.7);
      borderColor = Colors.amber.withValues(alpha: 0.35);
    } else if (isSelected) {
      seatColor = const Color(0xFF4CAF50);
      borderColor = const Color(0xFF4CAF50).withValues(alpha: 0.5);
    } else if (isVip) {
      seatColor = const Color(0xFFE67E22).withValues(alpha: isDark ? 0.5 : 0.4);
      borderColor = const Color(0xFFE67E22).withValues(alpha: isDark ? 0.25 : 0.2);
    } else {
      seatColor = isDark
          ? Colors.white.withValues(alpha: 0.15)
          : Colors.black.withValues(alpha: 0.1);
      borderColor = isDark
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.black.withValues(alpha: 0.04);
    }

    return GestureDetector(
      onTap: isBooked ? null : () => onSeatToggled(seatId),
      child: Container(
        width: seatSize,
        height: seatSize,
        margin: const EdgeInsets.symmetric(horizontal: 1.5),
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(seatSize * 0.25),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 0.5,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.chair_outlined,
            size: (seatSize * 0.55).clamp(9.0, 16.0),
            color: isSelected
                ? Colors.white
                : isBooked
                    ? Colors.white.withValues(alpha: 0.6)
                    : isVip
                        ? Colors.white.withValues(alpha: 0.4)
                        : isDark
                            ? Colors.white.withValues(alpha: 0.4)
                            : Colors.black.withValues(alpha: 0.25),
          ),
        ),
      ),
    );
  }
}
