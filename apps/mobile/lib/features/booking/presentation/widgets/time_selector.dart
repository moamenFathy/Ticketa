import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticketa/features/home/data/models/movie.dart';

class TimeSelector extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTimeSelected;
  final List<ShowtimeInfo> showtimes;
  final DateTime? showtimeTime;
  final List<String> hardcodedTimes = const ["8:00 AM", "10:30 AM", "2:00 PM", "6:45 PM"];

  const TimeSelector({
    super.key,
    required this.selectedIndex,
    required this.onTimeSelected,
    this.showtimes = const [],
    this.showtimeTime,
  });

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  final ScrollController _controller = ScrollController();
  final Map<int, GlobalKey> _itemKeys = {};

  GlobalKey _keyFor(int index) => _itemKeys.putIfAbsent(index, () => GlobalKey());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void didUpdateWidget(covariant TimeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> get _times {
    final showtimes = widget.showtimes;
    if (showtimes.isNotEmpty) {
      return showtimes.map((s) => DateFormat('h:mm a').format(s.startTime)).toList();
    }
    if (widget.showtimeTime != null) {
      return [DateFormat('h:mm a').format(widget.showtimeTime!)];
    }
    return widget.hardcodedTimes;
  }

  void _scrollToSelected() {
    final index = widget.selectedIndex;
    if (index <= 0 || !_controller.hasClients) return;

    _controller.jumpTo(
      (index * 95.0 - 30).clamp(0.0, _controller.position.maxScrollExtent),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _keyFor(index).currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          alignment: 0.5,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final times = _times;

    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: times.asMap().entries.map((entry) {
          int index = entry.key;
          bool isSelected = index == widget.selectedIndex;
          return GestureDetector(
            key: _keyFor(index),
            onTap: () => widget.onTimeSelected(index),
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