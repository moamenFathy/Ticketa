import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketa/core/di/injection.dart';
import 'package:ticketa/core/services/message_service.dart';
import 'package:ticketa/core/utils/localization_helper.dart';
import 'package:ticketa/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:ticketa/features/booking/presentation/cubit/booking_state.dart';
import 'package:ticketa/features/booking/presentation/widgets/cinema_screen_painter.dart';
import 'package:ticketa/features/booking/presentation/widgets/cinema_seat_grid.dart';
import 'package:ticketa/features/booking/presentation/widgets/seat_date_selector.dart';
import 'package:ticketa/features/booking/presentation/widgets/seat_legend.dart';
import 'package:ticketa/features/booking/presentation/widgets/seat_selection_app_bar.dart';
import 'package:ticketa/features/booking/presentation/widgets/seat_selection_bottom_bar.dart';
import 'package:ticketa/features/booking/presentation/widgets/seat_selection_dialogs.dart';
import 'package:ticketa/features/booking/presentation/widgets/time_selector.dart';
import 'package:ticketa/features/home/data/models/movie.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class SeatSelectionPage extends StatefulWidget {
  final String movieTitle;
  final int showtimeId;
  final List<ShowtimeInfo> showtimeInfos;
  final double basePrice;
  final String hallName;
  final String? moviePoster;

  const SeatSelectionPage({
    super.key,
    required this.movieTitle,
    required this.showtimeId,
    this.showtimeInfos = const [],
    required this.basePrice,
    this.hallName = '',
    this.moviePoster,
  });

  @override
  State<SeatSelectionPage> createState() => _SeatSelectionPageState();
}

class _SeatSelectionPageState extends State<SeatSelectionPage> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = 0;

  List<DateTime> get _availableDays {
    if (widget.showtimeInfos.isEmpty) {
      return List.generate(14, (i) => DateTime.now().add(Duration(days: i)));
    }
    final days = <DateTime>{};
    for (final s in widget.showtimeInfos) {
      days.add(DateTime(s.startTime.year, s.startTime.month, s.startTime.day));
    }
    final sorted = days.toList()..sort();
    return sorted;
  }

  List<ShowtimeInfo> get _dayTimes {
    final days = _availableDays;
    if (days.isEmpty) return const [];
    final day = days[_selectedDateIndex.clamp(0, days.length - 1)];
    return widget.showtimeInfos
        .where(
          (s) =>
              s.startTime.year == day.year &&
              s.startTime.month == day.month &&
              s.startTime.day == day.day,
        )
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  ShowtimeInfo? get _activeShowtime {
    final times = _dayTimes;
    if (times.isEmpty) return null;
    return times[_selectedTimeIndex.clamp(0, times.length - 1)];
  }

  void _onDateSelected(BuildContext ctx, int index) {
    setState(() {
      _selectedDateIndex = index;
      _selectedTimeIndex = 0;
    });
    final showtime = _activeShowtime;
    if (showtime != null) {
      ctx.read<BookingCubit>().loadSeatMap(showtime.id);
    }
  }

  void _onTimeSelected(BuildContext ctx, int index) {
    setState(() => _selectedTimeIndex = index);
    final showtime = _activeShowtime;
    if (showtime != null) {
      ctx.read<BookingCubit>().loadSeatMap(showtime.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => getIt<BookingCubit>()..loadSeatMap(widget.showtimeId),
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<BookingCubit, BookingState>(
            listener: (context, state) {
              if (state is BookingSeatConflict) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.seatConflicting(
                        state.conflictingSeatIds.length.toString(),
                      ),
                    ),
                  ),
                );
                context.read<BookingCubit>().loadSeatMap(widget.showtimeId);
              } else if (state is BookingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is BookingLoading) {
                final prev = context.read<BookingCubit>().lastLoaded;
                if (prev != null) {
                  return Stack(
                    children: [
                      IgnorePointer(
                        child: Opacity(
                          opacity: 0.35,
                          child: _buildContent(
                            context,
                            l10n,
                            theme,
                            isDark,
                            prev,
                          ),
                        ),
                      ),
                      const Positioned.fill(
                        child: Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return const Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                );
              }

              if (state is SeatMapLoaded) {
                return _buildContent(context, l10n, theme, isDark, state);
              }

              if (state is BookingError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context
                            .read<BookingCubit>()
                            .loadSeatMap(widget.showtimeId),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                );
              }

              return const Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
    bool isDark,
    SeatMapLoaded state,
  ) {
    final seatMap = state.seatMap;
    final mq = MediaQuery.of(context);
    final painterHeight = mq.size.height * 0.10;
    final screenTextTop = painterHeight * 0.4;

    double totalPrice = 0;
    for (final seatId in state.selectedSeats) {
      final parts = seatId.split('_');
      if (parts.length == 2) {
        final row = int.tryParse(parts[0]) ?? 0;
        final category = seatMap.rowCategoryMap[row] ?? 'Regular';
        totalPrice += seatMap.categoryPrices[category] ?? seatMap.basePrice;
      }
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: PopScope(
        key: ValueKey(seatMap.showtimeId),
        canPop: state.selectedSeats.isEmpty,
        onPopInvokedWithResult: (didPop, _) async {
          if (!didPop) {
            final exit = await SeatSelectionDialogs.showExitConfirmation(
              context,
              l10n,
            );
            if (exit && context.mounted) {
              Navigator.of(context).pop();
            }
          }
        },
        child: Column(
          children: [
            SeatSelectionAppBar(
              onBack: () async {
                if (state.selectedSeats.isNotEmpty) {
                  final exit = await SeatSelectionDialogs.showExitConfirmation(
                    context,
                    l10n,
                  );
                  if (exit && context.mounted) {
                    Navigator.pop(context);
                  }
                } else {
                  Navigator.pop(context);
                }
              },
            ),

            const SizedBox(height: 10),

            // Dates Section
            SeatDateSelector(
              selectedIndex: _selectedDateIndex,
              onDateSelected: (index) => _onDateSelected(context, index),
              dates: _availableDays,
            ),

            const SizedBox(height: 20),

            // Times Section
            TimeSelector(
              selectedIndex: _selectedTimeIndex,
              onTimeSelected: (index) => _onTimeSelected(context, index),
              showtimes: _dayTimes,
              showtimeTime: _activeShowtime?.startTime,
            ),

            const SizedBox(height: 8),

            // Screen & Seats Area
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: painterHeight,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: CinemaScreenPainter(
                              color: theme.colorScheme.primary,
                              isDark: isDark,
                              hallType: seatMap.hallType,
                            ),
                          ),
                        ),
                        Positioned(
                          top: screenTextTop,
                          left: 0,
                          right: 0,
                          child: IgnorePointer(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_up_rounded,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.4),
                                  size: 20,
                                ),
                                Text(
                                  l10n.screen.toUpperCase(),
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                    fontSize: 9,
                                    letterSpacing: 6,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: CinemaSeatGrid(
                        rows: seatMap.rows,
                        seatsPerRow: seatMap.seatsPerRow,
                        rowCategoryMap: seatMap.rowCategoryMap,
                        bookedSeats: seatMap.bookedSeats,
                        selectedSeats: state.selectedSeats,
                        hallType: seatMap.hallType,
                        onSeatToggled: (seatId) {
                          final ok = context
                              .read<BookingCubit>()
                              .toggleSeat(seatId);
                          if (!ok) {
                            MessageService.showWarning(
                              context: context,
                              message: localeCopy(
                                context,
                                'You can select up to 10 seats',
                                'يمكنك اختيار حتى 10 مقاعد فقط',
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SeatLegend(),
                ],
              ),
            ),

            SeatSelectionBottomBar(
              state: state,
              totalPrice: totalPrice,
              movieTitle: widget.movieTitle,
              showtimeId: widget.showtimeId,
              activeShowtime: _activeShowtime,
              moviePoster: widget.moviePoster,
              hallName: widget.hallName,
            ),
          ],
        ),
      ),
    );
  }
}
