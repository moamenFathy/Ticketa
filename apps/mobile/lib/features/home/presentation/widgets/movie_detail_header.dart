import 'package:flutter/material.dart';
import 'package:ticketa/features/home/models/movie.dart';
import 'package:ticketa/features/home/presentation/widgets/trailer_play_button.dart';

class MovieDetailHeader extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onPlay;

  const MovieDetailHeader({super.key, required this.movie, this.onPlay});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDark = theme.brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: size.height * 0.6,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      pinned: true,
      stretch: true,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (isDark ? Colors.black : Colors.white).withOpacity(0.3),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: isDark ? Colors.white : Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'poster_${movie.id}',
              child: Image.network(
                movie.posterUrl,
                fit: BoxFit.cover,
              ),
            ),
            // Bottom Gradient
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.5, 1.0],
                      colors: [
                        Colors.transparent,
                        theme.scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Play Button centered on the poster
            if (movie.hasTrailer && onPlay != null)
              Center(
                child: TrailerPlayButton(
                  movie: movie,
                  onPlay: onPlay,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
