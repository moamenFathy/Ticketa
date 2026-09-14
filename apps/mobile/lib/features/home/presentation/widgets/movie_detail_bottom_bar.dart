import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticketa/core/constants/app_constants.dart';
import 'package:ticketa/core/services/message_service.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/utils/app_responsive.dart';
import 'package:ticketa/core/utils/localization_helper.dart';
import 'package:ticketa/features/booking/presentation/screens/seat_selection_page.dart';
import 'package:ticketa/features/home/data/models/movie.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class MovieDetailBottomBar extends StatelessWidget {
  final Movie movie;
  final ShowtimeInfo? selectedShowtime;

  const MovieDetailBottomBar({
    super.key,
    required this.movie,
    this.selectedShowtime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final showtime = selectedShowtime ??
        (movie.showtimeInfos.isNotEmpty ? movie.showtimeInfos.first : null);

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(
          AppResponsive.screenPadding(context).left,
          20,
          AppResponsive.screenPadding(context).right,
          30,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.scaffoldBackgroundColor.withValues(alpha: 0),
              theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.price,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  showtime != null
                      ? "${l10n.currencySuffix} ${showtime.price.toStringAsFixed(2)}"
                      : '--',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.warmOrange,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.warmOrange.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (showtime == null) {
                      MessageService.showWarning(
                        context: context,
                        message: localeCopy(
                          context,
                          'No showtimes available for this movie yet',
                          'لا توجد عروض متاحة لهذا الفيلم حالياً',
                        ),
                      );
                      return;
                    }
                    final prefs = await SharedPreferences.getInstance();
                    final isGuest =
                        prefs.getBool(AppConstants.isGuestKey) ?? true;
                    if (isGuest) {
                      if (!context.mounted) return;
                      MessageService.showWarning(
                        context: context,
                        message: localeCopy(
                          context,
                          'Please sign in to book tickets',
                          'سجل دخولك أولاً لحجز التذاكر',
                        ),
                      );
                      return;
                    }
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SeatSelectionPage(
                          movieTitle: movie.title,
                          showtimeId: showtime.id,
                          showtimeInfos: movie.showtimeInfos,
                          basePrice: showtime.price,
                          hallName: showtime.hallName,
                          moviePoster: movie.posterUrl,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: AppColors.warmOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.bookTickets,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
