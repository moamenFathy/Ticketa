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

    if (widget.showtimes.isEmpty) return const SizedBox.shrink();

    final first = widget.showtimes.first.startTime;
    final last = widget.showtimes.last.startTime;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.warmOrange.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.warmOrange.withValues(alpha: 0.15)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.date_range_rounded, size: 16, color: AppColors.warmOrange),
              const SizedBox(width: 8),
              Text(
                '${DateFormat.MMMd(locale).format(first)} - ${DateFormat.MMMd(locale).format(last)}',
                style: TextStyle(
                  color: AppColors.warmOrange,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 44,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.showtimes.length,
            itemBuilder: (context, index) {
              final st = widget.showtimes[index];
              final date = st.startTime;
              final isSelected = _selectedIndex == index;
              final timeStr = DateFormat('h:mm a').format(date);

              return GestureDetector(
                onTap: () {
                  setState(() => _selectedIndex = index);
                  widget.onShowtimeSelected?.call(st);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.warmOrange : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isSelected ? AppColors.warmOrange : theme.dividerColor.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Text(
                    timeStr,
                    style: TextStyle(
                      color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
