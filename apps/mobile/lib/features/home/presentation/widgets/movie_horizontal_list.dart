import 'package:flutter/material.dart';
import 'package:ticketa/features/home/data/models/movie.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/features/home/presentation/widgets/small_movie_card.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class MovieHorizontalList extends StatelessWidget {
  final String title;
  final List<Movie> movies;
  final bool showRating;
  final bool isComingSoon;
  final VoidCallback? onSeeAll;

  const MovieHorizontalList({
    super.key,
    required this.title,
    required this.movies,
    this.showRating = true,
    this.isComingSoon = false,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (movies.length >= 3)
                TextButton(
                  onPressed: onSeeAll,
                  child: Text(
                    l10n.seeAll,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.warmOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 260,
          child: ListView.builder(
            padding: const EdgeInsetsDirectional.only(start: 20),
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) => SmallMovieCard(
              movie: movies[index],
              showRating: showRating,
              isComingSoon: isComingSoon,
            ),
          ),
        ),
      ],
    );
  }
}
