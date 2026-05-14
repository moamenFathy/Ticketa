import 'package:flutter/material.dart';
import 'package:ticketa/features/home/models/movie.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/features/home/presentation/screens/movie_detail_page.dart';

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
  final PageController _heroController = PageController(viewportFraction: 0.7, initialPage: 1);
  int _currentPage = 1;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                  double value = 1.0;
                  if (_heroController.position.haveDimensions) {
                    value = _heroController.page! - index;
                    value = (1 - (value.abs() * 0.2)).clamp(0.0, 1.0);
                  }
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
                child: _HeroCard(movie: widget.movies[index]),
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
                color: _currentPage == index ? AppColors.warmOrange : theme.colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),

        // Dynamic Movie Info
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Text(
                widget.movies[_currentPage].title.toUpperCase(),
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: 1.5,
                  shadows: isDark ? [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(0, 2),
                      blurRadius: 10,
                    ),
                  ] : null,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTag(widget.movies[_currentPage].genre.split('|')[0], theme),
                  _buildTag("${widget.movies[_currentPage].duration}m", theme),
                  _buildTag("⭐ ${widget.movies[_currentPage].rating}", theme, color: AppColors.warmOrange.withOpacity(0.2)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _HeroCard({required Movie movie}) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => MovieDetailPage(movie: movie)),
      ),
      child: Hero(
        tag: 'poster_${movie.id}',
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Stack(
              children: [
                Image.network(
                  movie.posterUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(String label, ThemeData theme, {Color? color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color ?? theme.colorScheme.onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color != null ? AppColors.warmOrange : theme.colorScheme.onSurface.withOpacity(0.8),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
