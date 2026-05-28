import 'package:flutter/material.dart';

class TimeSelector extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTimeSelected;
  final List<String> times = const ["8:00 AM", "10:30 AM", "2:00 PM", "6:45 PM"];

  const TimeSelector({
    super.key,
    required this.selectedIndex,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: times.asMap().entries.map((entry) {
        int index = entry.key;
        bool isSelected = index == selectedIndex;
        return GestureDetector(
          onTap: () => onTimeSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? theme.colorScheme.primary : theme.dividerColor.withValues(alpha: 0.1),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              entry.value,
              style: TextStyle(
                color: isSelected ? theme.colorScheme.onBackground : theme.colorScheme.onBackground.withValues(alpha: 0.3),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
      ),
    );
  }
}
