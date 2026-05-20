import 'package:flutter/material.dart';
import 'package:ticketa/features/home/models/movie.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/features/home/presentation/screens/seat_selection_page.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import 'package:ticketa/core/utils/app_responsive.dart';
import 'package:ticketa/features/home/presentation/widgets/movie_detail_skeleton.dart' as ticketa_movie_skeleton;
import '../widgets/movie_detail_header.dart';
import '../widgets/movie_info_tag.dart';
import '../widgets/movie_cast_list.dart';
import '../widgets/movie_date_selector.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;
  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final movie = widget.movie;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: _isLoading
          ? Scaffold(
              key: const ValueKey('skeleton'),
              backgroundColor: theme.scaffoldBackgroundColor,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: theme.colorScheme.onSurface),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              extendBodyBehindAppBar: true,
              body: const ticketa_movie_skeleton.MovieDetailSkeleton(),
            )
          : Scaffold(
              key: const ValueKey('content'),
              backgroundColor: theme.scaffoldBackgroundColor,
              body: Stack(
                children: [
                  // Content
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      // Parallax Header
                      MovieDetailHeader(movie: movie),

                      // Movie Details
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: AppResponsive.screenPadding(context),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              // Title
                              Text(
                                movie.title,
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Info Tags
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    MovieInfoTag(
                                        label: "${movie.rating}",
                                        icon: Icons.star_rounded,
                                        color: Colors.amber),
                                    const SizedBox(width: 10),
                                    MovieInfoTag(
                                        label: movie.genre.split('|')[0],
                                        icon: Icons.movie_filter_outlined,
                                        color: AppColors.warmOrange),
                                    const SizedBox(width: 10),
                                    MovieInfoTag(
                                        label: "${movie.duration}m",
                                        icon: Icons.timer_outlined,
                                        color: Colors.grey),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Storyline Section
                              _SectionHeader(title: l10n.storyLine),
                              const SizedBox(height: 12),
                              Text(
                                "An immersive journey through time and space, where every decision shapes the future. Experience breathtaking visuals and a story that will keep you on the edge of your seat until the very last moment.",
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.7),
                                  height: 1.6,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Cast Section
                              _SectionHeader(title: l10n.cast),
                              const SizedBox(height: 16),
                              const MovieCastList(),
                              const SizedBox(height: 32),

                              // Date Selector
                              _SectionHeader(title: l10n.selectDate),
                              const SizedBox(height: 16),
                              MovieDateSelector(showTimes: movie.showTimes),
                              const SizedBox(height: 140),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Floating Bottom CTA
                  Positioned(
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
                            theme.scaffoldBackgroundColor.withOpacity(0),
                            theme.scaffoldBackgroundColor.withOpacity(0.9),
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
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.6),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "EGP 120.00",
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
                                    color:
                                        AppColors.warmOrange.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SeatSelectionPage(
                                        movieTitle: movie.title),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 18),
                                  backgroundColor: AppColors.warmOrange,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20)),
                                  elevation: 0,
                                ),
                                child: Text(
                                  l10n.bookTickets,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            "See All",
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