import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SeatDateSelector extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onDateSelected;
  final List<DateTime> dates;

  const SeatDateSelector({
    super.key,
    required this.selectedIndex,
    required this.onDateSelected,
    required this.dates,
  });

  @override
  State<SeatDateSelector> createState() => _SeatDateSelectorState();
}

class _SeatDateSelectorState extends State<SeatDateSelector> {
  final ScrollController _monthsController = ScrollController();
  final ScrollController _daysController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void didUpdateWidget(covariant SeatDateSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    }
  }

  @override
  void dispose() {
    _monthsController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  void _scrollToSelected() {
    final dates = widget.dates;
    if (dates.isEmpty) return;

    final selected = dates[widget.selectedIndex.clamp(0, dates.length - 1)];

    if (_daysController.hasClients) {
      final target = widget.selectedIndex * 90.0 - 20;
      _daysController.animateTo(
        target.clamp(0.0, _daysController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }

    if (_monthsController.hasClients) {
      final months = <DateTime>[];
      for (final d in dates) {
        final m = DateTime(d.year, d.month);
        if (months.isEmpty || months.last != m) months.add(m);
      }
      final active = DateTime(selected.year, selected.month);
      final monthIndex = months.indexOf(active);
      if (monthIndex >= 0) {
        _monthsController.animateTo(
          (monthIndex * 64.0)
              .clamp(0.0, _monthsController.position.maxScrollExtent),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    final dates = widget.dates;
    if (dates.isEmpty) return const SizedBox.shrink();

    final months = <DateTime>[];
    for (final d in dates) {
      final m = DateTime(d.year, d.month);
      if (months.isEmpty || months.last != m) months.add(m);
    }

    final activeMonth = DateTime(
      dates[widget.selectedIndex.clamp(0, dates.length - 1)].year,
      dates[widget.selectedIndex.clamp(0, dates.length - 1)].month,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 34,
          child: ListView.builder(
            controller: _monthsController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: months.length,
            itemBuilder: (context, index) {
              final month = months[index];
              final isActive = month == activeMonth;
              return GestureDetector(
                onTap: () {
                  final firstIndex = dates.indexWhere(
                      (d) => d.year == month.year && d.month == month.month);
                  if (firstIndex >= 0) widget.onDateSelected(firstIndex);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsetsDirectional.only(end: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isActive
                          ? theme.colorScheme.primary
                          : theme.dividerColor.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Text(
                    DateFormat.MMM(locale).format(month).toUpperCase(),
                    style: TextStyle(
                      color: isActive
                          ? Colors.white
                          : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 110,
          child: ListView.builder(
            controller: _daysController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final date = dates[index];
              final isSelected = index == widget.selectedIndex;
              return GestureDetector(
                onTap: () => widget.onDateSelected(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 75,
                  margin: const EdgeInsetsDirectional.only(end: 15),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            )
                          ]
                        : [],
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
                                color: isSelected
                                    ? Colors.white70
                                    : theme.colorScheme.onSurface
                                        .withValues(alpha: 0.3),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              date.day.toString(),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : theme.colorScheme.onSurface,
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
    final holeColor =
        theme.brightness == Brightness.dark ? Colors.black26 : Colors.white24;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (i) => Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: holeColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (i) => Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: holeColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}