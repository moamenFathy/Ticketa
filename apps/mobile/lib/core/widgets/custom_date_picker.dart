import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';

Future<DateTime?> showCustomDatePicker(BuildContext context) {
  final now = DateTime.now();
  return showModalBottomSheet<DateTime>(
    context: context,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (ctx) => _CustomDatePicker(now: now),
  );
}

class _CustomDatePicker extends StatefulWidget {
  final DateTime now;
  const _CustomDatePicker({required this.now});

  @override
  State<_CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<_CustomDatePicker> {
  late DateTime selectedDate;
  late FixedExtentScrollController dayCtrl;
  late FixedExtentScrollController monthCtrl;
  late FixedExtentScrollController yearCtrl;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime(widget.now.year - 18, widget.now.month, widget.now.day.clamp(1, 28));
    dayCtrl = FixedExtentScrollController(initialItem: selectedDate.day - 1);
    monthCtrl = FixedExtentScrollController(initialItem: selectedDate.month - 1);
    yearCtrl = FixedExtentScrollController(initialItem: selectedDate.year - 1950);
  }

  @override
  void dispose() {
    dayCtrl.dispose();
    monthCtrl.dispose();
    yearCtrl.dispose();
    super.dispose();
  }

  int _daysInMonth(int y, int m) => DateTime(y, m + 1, 0).day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(width: 40, height: 4, decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(2),
            )),
          ),

          // Title + Done
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 60),
                Text('Date of Birth', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                GestureDetector(
                  onTap: () {
                    final d = dayCtrl.selectedItem + 1;
                    final m = monthCtrl.selectedItem + 1;
                    final y = yearCtrl.selectedItem + 1950;
                    Navigator.pop(context, DateTime(y, m, d));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.warmOrange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                  ),
                ),
              ],
            ),
          ),

          // Selected date preview
          AnimatedBuilder(
            animation: Listenable.merge([dayCtrl, monthCtrl, yearCtrl]),
            builder: (context, _) {
              final d = dayCtrl.hasClients ? dayCtrl.selectedItem + 1 : selectedDate.day;
              final m = monthCtrl.hasClients ? monthCtrl.selectedItem + 1 : selectedDate.month;
              final y = yearCtrl.hasClients ? yearCtrl.selectedItem + 1950 : selectedDate.year;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  '${d.toString().padLeft(2, '0')} / ${m.toString().padLeft(2, '0')} / $y',
                  style: TextStyle(color: AppColors.warmOrange, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 2),
                ),
              );
            },
          ),

          // Wheel picker
          Container(
            height: 220,
            color: isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF8F8F8),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoPicker(
                    scrollController: dayCtrl,
                    itemExtent: 44,
                    diameterRatio: 1.2,
                    offAxisFraction: -0.3,
                    onSelectedItemChanged: (i) {
                      final y = monthCtrl.hasClients ? monthCtrl.selectedItem + 1 : selectedDate.month;
                      final m = yearCtrl.hasClients ? yearCtrl.selectedItem + 1950 : selectedDate.year;
                      final days = _daysInMonth(m, y);
                      if (i + 1 > days) dayCtrl.jumpToItem(days - 1);
                    },
                    selectionOverlay: null,
                    children: List.generate(31, (i) => Center(
                      child: Text('${i + 1}'.padLeft(2, '0'),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
                    )),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: monthCtrl,
                    itemExtent: 44,
                    diameterRatio: 1.2,
                    onSelectedItemChanged: (i) {
                      final y = yearCtrl.hasClients ? yearCtrl.selectedItem + 1950 : selectedDate.year;
                      final m = i + 1;
                      final days = _daysInMonth(y, m);
                      if (dayCtrl.hasClients && dayCtrl.selectedItem + 1 > days) {
                        dayCtrl.jumpToItem(days - 1);
                      }
                    },
                    selectionOverlay: null,
                    children: List.generate(12, (i) {
                      const names = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                      return Center(child: Text(names[i],
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)));
                    }),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: yearCtrl,
                    itemExtent: 44,
                    diameterRatio: 1.2,
                    offAxisFraction: 0.3,
                    onSelectedItemChanged: (i) {
                      final y = i + 1950;
                      final m = monthCtrl.hasClients ? monthCtrl.selectedItem + 1 : selectedDate.month;
                      final days = _daysInMonth(y, m);
                      if (dayCtrl.hasClients && dayCtrl.selectedItem + 1 > days) {
                        dayCtrl.jumpToItem(days - 1);
                      }
                    },
                    selectionOverlay: null,
                    children: List.generate(83, (i) => Center(
                      child: Text('${1950 + i}',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
                    )),
                  ),
                ),
              ],
            ),
          ),

          // Cancel
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  foregroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
