import 'package:flutter/material.dart';
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

class _HomeHeroSectionState extends State<HomeHeroSection> {
  final PageController _heroController =
      PageController(viewportFraction: 0.7, initialPage: 1);
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _heroController.addListener(_onScroll);
  }

  @override
  void dispose() {
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

    return Column(
      children: [
        const SizedBox(height: 10),
        SizedBox(
          height: 420,
          child: PageView.builder(
            controller: _heroController,
            itemCount: widget.movies.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              widget.onPageChanged(index);
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _heroController,
                builder: (context, child) {
                  final double livePage =
                      _heroController.hasClients &&
                              _heroController.position.haveDimensions
                          ? _heroController.page!
                          : _currentPage.toDouble();
                  final double page = livePage.isFinite &&
                          livePage >= 0 &&
                          livePage < widget.movies.length
                      ? livePage
                      : _currentPage.toDouble();
                  double value = (1 - ((page - index).abs() * 0.2))
                      .clamp(0.45, 1.0);
                  return Center(
                    child: Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value.clamp(0.5, 1.0),
                        child: child,
                      ),
                    ),
                  );
                },
                child: HeroCard(movie: widget.movies[index]),
              );
            },
          ),
        ),

        // Movie Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.movies.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: _currentPage == index ? 20 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index ? AppColors.warmOrange : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),

        // Dynamic Movie Info
        const SizedBox(height: 20),
        HeroMovieInfo(movie: widget.movies[_currentPage]),
      ],
    );
  }
}
