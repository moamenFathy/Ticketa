import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketa/core/di/injection.dart';
import 'package:ticketa/features/home/data/models/movie.dart';
import 'package:ticketa/features/home/presentation/cubit/movie_detail_cubit.dart';
import 'package:ticketa/features/home/presentation/cubit/movie_detail_state.dart';
import 'package:ticketa/features/home/presentation/widgets/fullscreen_trailer_player.dart';
import 'package:ticketa/features/home/presentation/widgets/movie_detail_bottom_bar.dart';
import 'package:ticketa/features/home/presentation/widgets/movie_detail_header.dart';
import 'package:ticketa/features/home/presentation/widgets/movie_detail_skeleton.dart'
    as ticketa_movie_skeleton;
import 'package:ticketa/features/home/presentation/widgets/movie_info_section.dart';
import 'package:ticketa/l10n/app_localizations.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;
  final bool isComingSoon;

  const MovieDetailPage({
    super.key,
    required this.movie,
    this.isComingSoon = false,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool _isPlayingTrailer = false;
  ShowtimeInfo? _selectedShowtime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final movie = widget.movie;

    final passedHasShowtimes =
        movie.showtimeInfos.isNotEmpty &&
        movie.showtimeInfos.any((s) => s.id > 0);

    return BlocProvider(
      create: (context) =>
          getIt<MovieDetailCubit>()..fetchMovieDetails(widget.movie.id),
      child: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        builder: (context, state) {
          final isLoaded = state is MovieDetailLoaded;
          final raw = isLoaded ? state.movie : widget.movie;
          final hasValidShowtimes =
              raw.showtimeInfos.isNotEmpty &&
              raw.showtimeInfos.any((s) => s.id > 0);
          final displayMovie = (isLoaded && !hasValidShowtimes)
              ? Movie(
                  id: raw.id,
                  title: raw.title,
                  posterUrl: raw.posterUrl,
                  backdropUrl: raw.backdropUrl,
                  genre: raw.genre,
                  rating: raw.rating,
                  duration: raw.duration,
                  showTimes: widget.movie.showTimes,
                  showtimeInfos: widget.movie.showtimeInfos,
                  hallType: raw.hallType,
                  overview: raw.overview,
                  trailerKey: raw.trailerKey,
                  cast: raw.cast,
                )
              : raw;
          final isLoading =
              (state is MovieDetailInitial || state is MovieDetailLoading);

          final needsSkeleton = isLoading && !passedHasShowtimes;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: needsSkeleton
                ? _buildLoadingSkeleton(theme)
                : _buildContent(theme, l10n, displayMovie),
          );
        },
      ),
    );
  }

  Widget _buildLoadingSkeleton(ThemeData theme) {
    final isRtl = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      key: const ValueKey('skeleton'),
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            isRtl
                ? Icons.arrow_forward_ios_rounded
                : Icons.arrow_back_ios_new_rounded,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: const ticketa_movie_skeleton.MovieDetailSkeleton(),
    );
  }

  Widget _buildContent(
    ThemeData theme,
    AppLocalizations l10n,
    Movie displayMovie,
  ) {
    return Scaffold(
      key: const ValueKey('content'),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              MovieDetailHeader(
                movie: displayMovie,
                onPlay: displayMovie.hasTrailer
                    ? () => setState(() => _isPlayingTrailer = true)
                    : null,
              ),
              MovieInfoSection(
                movie: displayMovie,
                isComingSoon: widget.isComingSoon,
                onShowtimeSelected: (st) =>
                    setState(() => _selectedShowtime = st),
              ),
            ],
          ),
          if (!widget.isComingSoon)
            MovieDetailBottomBar(
              movie: displayMovie,
              selectedShowtime: _selectedShowtime,
            ),
          _buildTrailerOverlay(displayMovie),
        ],
      ),
    );
  }

  Widget _buildTrailerOverlay(Movie displayMovie) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: !_isPlayingTrailer,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          reverseDuration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _isPlayingTrailer && displayMovie.trailerKey != null
              ? FullScreenInlinePlayer(
                  key: const ValueKey('full_screen_player'),
                  trailerKey: displayMovie.trailerKey!,
                  posterUrl: displayMovie.posterUrl,
                  onClose: () => setState(() => _isPlayingTrailer = false),
                )
              : const SizedBox.shrink(key: ValueKey('empty_player')),
        ),
      ),
    );
  }
}
