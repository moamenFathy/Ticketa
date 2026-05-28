import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/features/home/data/models/movie.dart';

class MovieDateSelector extends StatefulWidget {
  final List<ShowtimeInfo> showtimes;
  final ValueChanged<ShowtimeInfo>? onShowtimeSelected;

  const MovieDateSelector({
    super.key,
    required this.showtimes,
    this.onShowtimeSelected,
  });

  @override
  State<MovieDateSelector> createState() => _MovieDateSelectorState();
}

class _MovieDateSelectorState extends State<MovieDateSelector> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.showtimes.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onShowtimeSelected?.call(widget.showtimes[0]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: widget.showtimes.length,
        itemBuilder: (context, index) {
          final st = widget.showtimes[index];
          final date = st.startTime;
          final isSelected = _selectedIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);
              widget.onShowtimeSelected?.call(st);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 70,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.warmOrange : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(25),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.warmOrange.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : [],
                border: Border.all(
                  color: isSelected ? AppColors.warmOrange : theme.dividerColor.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat.MMM(locale).format(date),
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
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
