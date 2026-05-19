import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketa/core/theme/app_colors.dart';

class MovieDateSelector extends StatefulWidget {
  final List<DateTime> showTimes;
  
  const MovieDateSelector({super.key, required this.showTimes});

  @override
  State<MovieDateSelector> createState() => _MovieDateSelectorState();
}

class _MovieDateSelectorState extends State<MovieDateSelector> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.showTimes.length,
        itemBuilder: (context, index) {
          final date = widget.showTimes[index];
          final isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 70,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.warmOrange : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(25),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.warmOrange.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ] : [],
                border: Border.all(
                  color: isSelected ? AppColors.warmOrange : theme.dividerColor.withOpacity(0.1),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.MMM(locale).format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : theme.textTheme.titleMedium?.color,
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
