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
    final isDark = theme.brightness == Brightness.dark;
    final selectedSet = selectedSeats.toSet();

    return RepaintBoundary(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          final aislesTotal = maxWidth * 0.08;
          final availableForSeats = maxWidth - aislesTotal;
          final seatUnitWidth = availableForSeats / 16;
          final rawSeatWidth = seatUnitWidth - 1;
          final seatWidth = rawSeatWidth.clamp(14.0, 24.0);
          final seatHeight = (seatWidth * 11 / 18).clamp(8.0, 16.0);
          final aisleWidth = aislesTotal / 2;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(14, (row) {
              if (row < 3) {
                return _buildVipRow(row, theme, isDark, selectedSet, seatWidth, seatHeight);
              } else {
                return _buildMainRow(row, theme, isDark, selectedSet, seatWidth, seatHeight, aisleWidth);
              }
            }),
          );
        },
      ),
    );
  }

  Widget _buildVipRow(int row, ThemeData theme, bool isDark, Set<String> selectedSet, double seatWidth, double seatHeight) {
    int seats = 10;
    String section = "VIP";

    return Padding(
      padding: EdgeInsets.only(bottom: row == 2 ? 10 : 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(seats, (col) {
          String seatId = "${section}_${row}_$col";
          return _buildSeat(
            seatId: seatId,
            selectedSet: selectedSet,
            theme: theme,
            isDark: isDark,
            isVip: true,
            seatWidth: seatWidth,
            seatHeight: seatHeight,
          );
        }),
      ),
    );
  }

  Widget _buildMainRow(int row, ThemeData theme, bool isDark, Set<String> selectedSet, double seatWidth, double seatHeight, double aisleWidth) {
    int leftCount = 4;
    int centerCount = 8;
    int rightCount = 4;
    String section = "M";

    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(leftCount, (col) {
            String seatId = "${section}L_${row}_$col";
            return _buildSeat(
              seatId: seatId,
              selectedSet: selectedSet,
              theme: theme,
              isDark: isDark,
              isVip: false,
              seatWidth: seatWidth,
              seatHeight: seatHeight,
            );
          }),
          SizedBox(width: aisleWidth),
          ...List.generate(centerCount, (col) {
            String seatId = "${section}C_${row}_$col";
            return _buildSeat(
              seatId: seatId,
              selectedSet: selectedSet,
              theme: theme,
              isDark: isDark,
              isVip: false,
              seatWidth: seatWidth,
              seatHeight: seatHeight,
            );
          }),
          SizedBox(width: aisleWidth),
          ...List.generate(rightCount, (col) {
            String seatId = "${section}R_${row}_$col";
            return _buildSeat(
              seatId: seatId,
              selectedSet: selectedSet,
              theme: theme,
              isDark: isDark,
              isVip: false,
              seatWidth: seatWidth,
              seatHeight: seatHeight,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSeat({
    required String seatId,
    required Set<String> selectedSet,
    required ThemeData theme,
    required bool isDark,
    required bool isVip,
    required double seatWidth,
    required double seatHeight,
  }) {
    bool isSelected = selectedSet.contains(seatId);
    bool isReserved = (seatId == "VIP_0_1") ||
                      (seatId == "VIP_0_7") ||
                      (seatId == "VIP_1_4") ||
                      (seatId == "VIP_2_0") ||
                      (seatId == "VIP_2_9") ||
                      (seatId == "M_L_3_2") ||
                      (seatId == "M_L_6_0") ||
                      (seatId == "M_L_9_3") ||
                      (seatId == "M_L_12_1") ||
                      (seatId == "M_C_3_5") ||
                      (seatId == "M_C_6_2") ||
                      (seatId == "M_C_8_7") ||
                      (seatId == "M_C_11_3") ||
                      (seatId == "M_R_4_2") ||
                      (seatId == "M_R_7_0") ||
                      (seatId == "M_R_10_3") ||
                      (seatId == "M_R_12_0");

    Color seatColor;
    Color borderColor = Colors.transparent;

    if (isReserved) {
      seatColor = Colors.yellow.withValues(alpha: 0.55);
      borderColor = Colors.yellow.withValues(alpha: 0.35);
    } else if (isSelected) {
      seatColor = const Color(0xFF4CAF50);
      borderColor = const Color(0xFF4CAF50).withValues(alpha: 0.5);
    } else if (isVip) {
      seatColor = const Color(0xFFE67E22).withValues(alpha: isDark ? 0.4 : 0.3);
      borderColor = const Color(0xFFE67E22).withValues(alpha: isDark ? 0.25 : 0.2);
    } else {
      seatColor = isDark
          ? Colors.white.withValues(alpha: 0.12)
          : Colors.black.withValues(alpha: 0.1);
      borderColor = isDark
          ? Colors.white.withValues(alpha: 0.05)
          : Colors.black.withValues(alpha: 0.04);
    }

    return GestureDetector(
      onTap: isReserved ? null : () => onSeatToggled(seatId),
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
