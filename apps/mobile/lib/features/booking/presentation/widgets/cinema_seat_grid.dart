import 'package:flutter/material.dart';
import 'package:ticketa/features/booking/data/models/seat_dto.dart';

class CinemaSeatGrid extends StatelessWidget {
  final int rows;
  final int seatsPerRow;
  final Map<int, String> rowCategoryMap;
  final List<SeatDto> bookedSeats;
  final List<String> selectedSeats;
  final Function(String) onSeatToggled;

  const CinemaSeatGrid({
    super.key,
    required this.rows,
    required this.seatsPerRow,
    required this.rowCategoryMap,
    required this.bookedSeats,
    required this.selectedSeats,
    required this.onSeatToggled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bookedSet = bookedSeats.map((s) => s.id).toSet();
    final selectedSet = selectedSeats.toSet();

    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final aislesTotal = maxWidth * 0.08;
          final availableForSeats = maxWidth - aislesTotal;
          final seatUnitWidth = availableForSeats / seatsPerRow;
          final rawSeatWidth = seatUnitWidth - 1;
          final seatWidth = rawSeatWidth.clamp(14.0, 24.0);
          final seatHeight = (seatWidth * 11 / 18).clamp(8.0, 16.0);
          final aisleWidth = aislesTotal / 2;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(rows, (rowIndex) {
              final rowNumber = rowIndex + 1;
              final category = rowCategoryMap[rowNumber] ?? 'Regular';
              final isVip = category == 'VIP';
              final isPremium = category == 'Premium';

              final leftCount = seatsPerRow ~/ 4;
              final centerCount = seatsPerRow ~/ 2;
              final rightCount = seatsPerRow - leftCount - centerCount;

              return Padding(
                padding: EdgeInsets.only(bottom: rowIndex == rows - 1 ? 0 : 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        isPremium: isPremium,
                        seatWidth: seatWidth,
                        seatHeight: seatHeight,
                      );
                    }),
                    SizedBox(width: aisleWidth),
                    ...List.generate(centerCount, (col) {
                      final seatNumber = leftCount + col + 1;
                      final id = SeatDto(row: rowNumber, seatNumber: seatNumber).id;
                      return _buildSeat(
                        seatId: id,
                        isBooked: bookedSet.contains(id),
                        selectedSet: selectedSet,
                        theme: theme,
                        isDark: isDark,
                        isVip: isVip,
                        isPremium: isPremium,
                        seatWidth: seatWidth,
                        seatHeight: seatHeight,
                      );
                    }),
                    SizedBox(width: aisleWidth),
                    ...List.generate(rightCount, (col) {
                      final seatNumber = leftCount + centerCount + col + 1;
                      final id = SeatDto(row: rowNumber, seatNumber: seatNumber).id;
                      return _buildSeat(
                        seatId: id,
                        isBooked: bookedSet.contains(id),
                        selectedSet: selectedSet,
                        theme: theme,
                        isDark: isDark,
                        isVip: isVip,
                        isPremium: isPremium,
                        seatWidth: seatWidth,
                        seatHeight: seatHeight,
                      );
                    }),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildSeat({
    required String seatId,
    required bool isBooked,
    required Set<String> selectedSet,
    required ThemeData theme,
    required bool isDark,
    required bool isVip,
    required bool isPremium,
    required double seatWidth,
    required double seatHeight,
  }) {
    final isSelected = selectedSet.contains(seatId);

    Color seatColor;
    Color borderColor = Colors.transparent;

    if (isBooked) {
      seatColor = Colors.yellow.withValues(alpha: 0.55);
      borderColor = Colors.yellow.withValues(alpha: 0.35);
    } else if (isSelected) {
      seatColor = const Color(0xFF4CAF50);
      borderColor = const Color(0xFF4CAF50).withValues(alpha: 0.5);
    } else if (isVip) {
      seatColor = const Color(0xFFE67E22).withValues(alpha: isDark ? 0.4 : 0.3);
      borderColor = const Color(0xFFE67E22).withValues(alpha: isDark ? 0.25 : 0.2);
    } else if (isPremium) {
      seatColor = Colors.purple.withValues(alpha: isDark ? 0.4 : 0.3);
      borderColor = Colors.purple.withValues(alpha: isDark ? 0.25 : 0.2);
    } else {
      seatColor = isDark
          ? Colors.white.withValues(alpha: 0.12)
          : Colors.black.withValues(alpha: 0.1);
      borderColor = isDark
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.black.withValues(alpha: 0.04);
    }

    return GestureDetector(
      onTap: isBooked ? null : () => onSeatToggled(seatId),
      child: Container(
        width: seatWidth,
        height: seatHeight,
        margin: const EdgeInsets.symmetric(horizontal: 0.5),
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 0.5,
          ),
        ),
      ),
    );
  }
}
