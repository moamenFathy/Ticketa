import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SeatDateSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDateSelected;

  const SeatDateSelector({
    super.key,
    required this.selectedIndex,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
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
              bool isSelected = index == selectedIndex;
              return GestureDetector(
                onTap: () => onDateSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 75,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
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
                                color: isSelected ? Colors.white70 : theme.colorScheme.onSurface.withValues(alpha: 0.3),
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
}
