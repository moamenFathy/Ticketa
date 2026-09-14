import 'package:flutter/material.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/core/utils/app_responsive.dart';
import 'package:ticketa/core/utils/localization_helper.dart';
import 'package:ticketa/features/home/data/models/movie.dart';
import 'package:ticketa/features/home/presentation/screens/see_all_cast_page.dart';
import 'package:ticketa/features/home/presentation/widgets/movie_cast_list.dart';
import 'package:ticketa/features/home/presentation/widgets/movie_date_selector.dart';
import 'package:ticketa/features/home/presentation/widgets/movie_info_tag.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class MovieInfoSection extends StatelessWidget {
  final Movie movie;
  final bool isComingSoon;
  final ValueChanged<ShowtimeInfo?> onShowtimeSelected;

  const MovieInfoSection({
    super.key,
    required this.movie,
    this.isComingSoon = false,
    required this.onShowtimeSelected,
  });

  Widget _staggeredSection(double delay, Widget child) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Interval(delay, 1.0, curve: Curves.easeOutCubic),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildInfoTags(
    ThemeData theme,
    AppLocalizations l10n,
    Movie displayMovie,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          MovieInfoTag(
            label: displayMovie.rating.toStringAsFixed(1),
            icon: Icons.star_rounded,
            color: Colors.amber,
          ),
          const SizedBox(width: 10),
          MovieInfoTag(
            label: displayMovie.genre.isNotEmpty
                ? displayMovie.genre.split(', ')[0]
                : l10n.genreFallback,
            icon: Icons.movie_filter_outlined,
            color: AppColors.warmOrange,
          ),
          const SizedBox(width: 10),
          MovieInfoTag(
            label: displayMovie.duration > 60
                ? l10n.durationHours(
                    (displayMovie.duration ~/ 60).toString(),
                    (displayMovie.duration % 60).toString(),
                  )
                : l10n.durationMinutes(displayMovie.duration.toString()),
            icon: Icons.timer_outlined,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SliverToBoxAdapter(
      child: Padding(
        padding: AppResponsive.screenPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _staggeredSection(
              0.00,
              Text(
                movie.title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _staggeredSection(0.08, _buildInfoTags(theme, l10n, movie)),
            const SizedBox(height: 32),
            _staggeredSection(0.16, SectionHeader(title: l10n.storyLine)),
            const SizedBox(height: 12),
            _staggeredSection(
              0.16,
              Text(
                movie.overview.isNotEmpty ? movie.overview : l10n.storyLine,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _staggeredSection(
              0.24,
              SectionHeader(
                title: l10n.cast,
                onSeeAll: movie.cast.length >= 3
                    ? () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SeeAllCastPage(cast: movie.cast),
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            _staggeredSection(0.24, MovieCastList(cast: movie.cast)),
            if (!isComingSoon) ...[
              const SizedBox(height: 32),
              _staggeredSection(0.32, SectionHeader(title: l10n.showTime)),
              const SizedBox(height: 16),
              _staggeredSection(
                0.32,
                movie.showtimeInfos.isNotEmpty
                    ? MovieDateSelector(
                        showtimes: movie.showtimeInfos,
                        onShowtimeSelected: onShowtimeSelected,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(l10n.noShowtimes),
                      ),
              ),
              const SizedBox(height: 140),
            ] else ...[
              const SizedBox(height: 32),
              _staggeredSection(
                0.32,
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 22,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warmOrange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: AppColors.warmOrange.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.upcoming_rounded,
                        color: AppColors.warmOrange,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            localeCopy(
                              context,
                              'Coming Soon to Theaters',
                              'قريباً في صالات السينما',
                            ),
                            style: const TextStyle(
                              color: AppColors.warmOrange,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            localeCopy(
                              context,
                              'Tickets will be available soon',
                              'سيتم فتح حجز التذاكر قريباً',
                            ),
                            style: TextStyle(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const SectionHeader({super.key, required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              l10n.seeAll,
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.warmOrange,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
      ],
    );
  }
}
