import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketa/core/constants/app_constants.dart';
import 'package:ticketa/core/di/injection.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/features/booking/data/models/seat_dto.dart';
import 'package:ticketa/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:ticketa/features/booking/presentation/cubit/booking_state.dart';
import 'package:ticketa/features/payment/presentation/screens/payment_page.dart';
import 'package:ticketa/features/home/data/models/movie.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import '../widgets/seat_legend.dart';
import '../widgets/cinema_seat_grid.dart';
import '../widgets/cinema_screen_painter.dart';
import '../widgets/seat_date_selector.dart';
import '../widgets/time_selector.dart';

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
  List<SeatDto> _pendingSeats = [];
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
        .where((s) =>
            s.startTime.year == day.year &&
            s.startTime.month == day.month &&
            s.startTime.day == day.day)
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

  Future<void> _requireAuth(BuildContext actionContext) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(AppConstants.isLoggedInKey) ?? false;
    final token = prefs.getString(AppConstants.tokenKey);
    if (isLoggedIn && token != null && token.isNotEmpty) return;
    if (!mounted || !actionContext.mounted) return;
    final theme = Theme.of(actionContext);
    await showDialog(
      context: actionContext,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warmOrange.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.login_rounded, color: AppColors.warmOrange, size: 32),
            ),
            const SizedBox(height: 20),
            Text(
              'Sign in required',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Text(
              'You need to sign in to book tickets.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
        actions: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                backgroundColor: AppColors.warmOrange,
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(actionContext).pop();
                Navigator.of(actionContext).pushNamed('/login');
              },
              child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
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
                  SnackBar(content: Text('${state.conflictingSeatIds.length} seat(s) already booked.')),
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
                          child: _buildContent(context, l10n, theme, isDark, prev),
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
                    width: 28, height: 28,
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
                        onPressed: () => context.read<BookingCubit>().loadSeatMap(widget.showtimeId),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return const Center(
                child: SizedBox(
                  width: 28, height: 28,
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

    // Calculate total price based on category
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
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) {
            _showExitDialog(context, l10n);
          }
        },
        child: Column(
        children: [
          _buildAppBar(l10n, theme, state),

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
                // Screen painter
                SizedBox(
                  height: painterHeight,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: CinemaScreenPainter(color: theme.colorScheme.primary, isDark: isDark, hallType: seatMap.hallType),
                        ),
                      ),
                      Positioned(
                        top: screenTextTop, left: 0, right: 0,
                        child: IgnorePointer(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.keyboard_arrow_up_rounded, color: theme.colorScheme.onSurface.withValues(alpha: 0.4), size: 20),
                              Text(
                                l10n.screen.toUpperCase(),
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                  fontSize: 9, letterSpacing: 6, fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Seat grid
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: CinemaSeatGrid(
                      rows: seatMap.rows,
                      seatsPerRow: seatMap.seatsPerRow,
                      rowCategoryMap: seatMap.rowCategoryMap,
                      bookedSeats: seatMap.bookedSeats,
                      selectedSeats: state.selectedSeats,
                      hallType: seatMap.hallType,
                      onSeatToggled: (seatId) {
                        context.read<BookingCubit>().toggleSeat(seatId);
                      },
                    ),
                  ),
                ),
                const SeatLegend(),
              ],
            ),
          ),

          _buildBottomAction(l10n, theme, state, totalPrice),
        ],
      ),
      ),
    );
  }

  Future<void> _showExitDialog(BuildContext context, AppLocalizations l10n) async {
    final theme = Theme.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.exit_to_app_rounded, color: theme.colorScheme.primary, size: 32),
            ),
            const SizedBox(height: 20),
            Text(l10n.confirmExitTitle, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            Text(l10n.confirmExitMessage, textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
        actions: [
          SizedBox(width: double.infinity, child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.confirmExitNo, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontWeight: FontWeight.w600)),
          )),
          const SizedBox(height: 8),
          SizedBox(width: double.infinity, child: FilledButton(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              backgroundColor: theme.colorScheme.primary,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.confirmExitYes, style: const TextStyle(fontWeight: FontWeight.w600)),
          )),
        ],
      ),
    );
    if (result == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildAppBar(AppLocalizations l10n, ThemeData theme, SeatMapLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              if (state.selectedSeats.isNotEmpty) {
                _showExitDialog(context, l10n);
              } else {
                Navigator.pop(context);
              }
            },
            child: _buildCircleBtn(Icons.arrow_back_ios_new, theme)),
          Text(l10n.selectSeats, style: theme.textTheme.titleLarge),
          _buildCircleBtn(Icons.more_vert, theme),
        ],
      ),
    );
  }

  Widget _buildBottomAction(AppLocalizations l10n, ThemeData theme, SeatMapLoaded state, double total) {
    final hasSeats = state.selectedSeats.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(30)),
            child: Text("${state.selectedSeats.length}", style: theme.textTheme.titleLarge),
          ),
          Builder(
            builder: (ctx) => GestureDetector(
            onTap: hasSeats
                ? () async {
                    final prefs = await SharedPreferences.getInstance();
                    final isLoggedIn = prefs.getBool(AppConstants.isLoggedInKey) ?? false;
                    final token = prefs.getString(AppConstants.tokenKey);
                    if (!isLoggedIn || token == null || token.isEmpty) {
                      if (ctx.mounted) await _requireAuth(ctx);
                      return;
                    }
                    if (!ctx.mounted) return;
                    _pendingSeats = state.selectedSeats.map((id) {
                      final parts = id.split('_');
                      return SeatDto(
                        row: int.tryParse(parts[0]) ?? 0,
                        seatNumber: int.tryParse(parts[1]) ?? 0,
                      );
                    }).toList();
                    final active = _activeShowtime;
                    Navigator.push(
                      ctx,
                      MaterialPageRoute(
                        builder: (_) => PaymentPage(
                          totalAmount: total,
                          movieTitle: widget.movieTitle,
                          seats: _pendingSeats,
                          date: active != null
                              ? DateFormat('dd MMM yyyy').format(active.startTime)
                              : '',
                          time: active != null
                              ? DateFormat('h:mm a').format(active.startTime)
                              : '',
                          showtimeId: active?.id ?? widget.showtimeId,
                          moviePoster: widget.moviePoster,
                          hallName: widget.hallName,
                        ),
                      ),
                    );
                  }
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              decoration: BoxDecoration(
                color: hasSeats ? theme.colorScheme.primary : theme.dividerColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                l10n.buyFor(total.toStringAsFixed(0)),
                style: TextStyle(
                  color: hasSeats ? Colors.white : theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  fontWeight: FontWeight.bold, fontSize: 16,
                ),
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleBtn(IconData icon, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: theme.colorScheme.surface, shape: BoxShape.circle),
      child: Icon(icon, color: theme.colorScheme.onSurface, size: 20),
    );
  }
}
