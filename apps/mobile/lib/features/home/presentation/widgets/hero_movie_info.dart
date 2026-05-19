import 'package:flutter/material.dart';
import 'package:ticketa/features/home/models/movie.dart';
import 'package:ticketa/core/theme/app_colors.dart';

class HeroMovieInfo extends StatelessWidget {
  final Movie movie;
  const HeroMovieInfo({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Text(
            movie.title.toUpperCase(),
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
              _buildTag(movie.genre.split('|')[0], theme),
              _buildTag("${movie.duration}m", theme),
              _buildTag("⭐ ${movie.rating}", theme, color: AppColors.warmOrange.withOpacity(0.2)),
            ],
          ),
        ],
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
