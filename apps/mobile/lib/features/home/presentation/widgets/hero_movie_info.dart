import 'package:flutter/material.dart';
import 'package:ticketa/features/home/data/models/movie.dart';
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
                  color: Colors.black.withValues(alpha: 0.5),
                  offset: const Offset(0, 2),
                  blurRadius: 10,
                ),
              ] : null,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag(label: movie.firstGenre, theme: theme),
              _buildTag(
                label: movie.duration > 60
                    ? "${movie.duration ~/ 60}h ${movie.duration % 60}m"
                    : "${movie.duration}m",
                theme: theme,
              ),
              _buildTag(
                label: movie.rating.toStringAsFixed(1),
                theme: theme,
                icon: Icons.star_rounded,
                iconColor: AppColors.warmOrange,
                backgroundColor: AppColors.warmOrange.withValues(alpha: 0.15),
                textColor: AppColors.warmOrange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag({
    required String label,
    required ThemeData theme,
    IconData? icon,
    Color? iconColor,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: backgroundColor != null
              ? AppColors.warmOrange.withValues(alpha: 0.3)
              : theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: iconColor ?? AppColors.warmOrange,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.8),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
