import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ticketa/features/home/data/models/movie.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import '../widgets/hero_card.dart';
import '../widgets/hero_movie_info.dart';

class HomeHeroSection extends StatefulWidget {
  final List<Movie> movies;
  final Function(int) onPageChanged;
  const HomeHeroSection({
    super.key,
    required this.movies,
    required this.onPageChanged,
  });

  @override
  State<HomeHeroSection> createState() => _HomeHeroSectionState();
}

class _HomeHeroSectionState extends State<HomeHeroSection>
    with SingleTickerProviderStateMixin {
  static const int _virtualItemCount = 10000;
  late final PageController _heroController;
  int _virtualIndex = 0;
  int _realIndex = 0;
  late AnimationController _progressController;
  static const Duration _slideDuration = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    final count = widget.movies.length;
    final initialVirtual = count > 0 ? (_virtualItemCount ~/ (2 * count)) * count : 0;
    _virtualIndex = initialVirtual;
    _realIndex = count > 0 ? initialVirtual % count : 0;

    _heroController = PageController(
      viewportFraction: 0.7,
      initialPage: initialVirtual,
    );

    _progressController = AnimationController(
      vsync: this,
      duration: _slideDuration,
    );

    _heroController.addListener(_onScroll);

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!_heroController.hasClients || widget.movies.isEmpty) return;
        _heroController.nextPage(
          duration: const Duration(milliseconds: 750),
          curve: Curves.fastOutSlowIn,
        );
      }
    });

    _startProgress();
  }

  void _startProgress() {
    if (widget.movies.length <= 1) return;
    _progressController.forward(from: 0.0);
  }

  void _pauseProgress() {
    _progressController.stop();
  }

  void _resumeProgress() {
    if (widget.movies.length <= 1) return;
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _heroController.removeListener(_onScroll);
    _heroController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = widget.movies.length;

    if (count == 0) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 10),
        SizedBox(
          height: 420,
          child: NotificationListener<UserScrollNotification>(
            onNotification: (notification) {
              if (notification.direction != ScrollDirection.idle) {
                _pauseProgress();
              } else {
                _resumeProgress();
              }
              return false;
            },
            child: PageView.builder(
              controller: _heroController,
              itemCount: count > 1 ? _virtualItemCount : 1,
              onPageChanged: (vIndex) {
                final rIndex = vIndex % count;
                setState(() {
                  _virtualIndex = vIndex;
                  _realIndex = rIndex;
                });
                widget.onPageChanged(rIndex);
                _startProgress();
              },
              itemBuilder: (context, vIndex) {
                final movie = widget.movies[vIndex % count];
                return AnimatedBuilder(
                  animation: _heroController,
                  builder: (context, child) {
                    final double livePage =
                        _heroController.hasClients &&
                                _heroController.position.haveDimensions
                            ? _heroController.page!
                            : _virtualIndex.toDouble();
                    final double page = livePage.isFinite
                        ? livePage
                        : _virtualIndex.toDouble();
                    double value = (1 - ((page - vIndex).abs() * 0.15))
                        .clamp(0.65, 1.0);
                    return Center(
                      child: Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: (1 - ((page - vIndex).abs() * 0.25))
                              .clamp(0.75, 1.0),
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: HeroCard(movie: movie),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Cinema Story Progress Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            count,
            (index) {
              final isCurrent = _realIndex == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 5.5,
                width: isCurrent ? 48 : 12,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: isCurrent
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: AnimatedBuilder(
                          animation: _progressController,
                          builder: (context, child) {
                            return FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: _progressController.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.warmOrange,
                                      AppColors.lighterOrange,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.warmOrange
                                          .withValues(alpha: 0.7),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : null,
              );
            },
          ),
        ),

        // Dynamic Movie Info
        const SizedBox(height: 18),
        HeroMovieInfo(movie: widget.movies[_realIndex]),
      ],
    );
  }
}
