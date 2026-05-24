import 'package:flutter/material.dart';
import 'package:ticketa/features/home/data/models/movie.dart';
import 'package:ticketa/features/now_showing/presentation/widgets/now_showing_card.dart';

class SeeAllMoviesPage extends StatelessWidget {
  final String title;
  final List<Movie> movies;

  const SeeAllMoviesPage({
    super.key,
    required this.title,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 40),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: Duration(milliseconds: 400 + (index * 60)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: NowShowingCard(movie: movie),
          );
        },
      ),
    );
  }
}
