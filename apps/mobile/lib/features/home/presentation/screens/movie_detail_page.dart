import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ticketa/features/home/data/models/movie.dart';
import 'package:ticketa/core/theme/app_colors.dart';
import 'package:ticketa/features/booking/presentation/screens/seat_selection_page.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:ticketa/core/utils/youtube_utils.dart';
import 'package:ticketa/features/home/presentation/widgets/movie_date_selector.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import 'package:ticketa/core/utils/app_responsive.dart';
import 'package:ticketa/features/home/presentation/widgets/movie_detail_skeleton.dart' as ticketa_movie_skeleton;
import '../widgets/movie_detail_header.dart';
import '../widgets/movie_info_tag.dart';
import '../widgets/movie_cast_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticketa/core/di/injection.dart';
import 'package:ticketa/features/home/presentation/cubit/movie_detail_cubit.dart';
import 'package:ticketa/features/home/presentation/cubit/movie_detail_state.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;
  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool _isPlayingTrailer = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final movie = widget.movie;

    return BlocProvider(
      create: (context) => getIt<MovieDetailCubit>()..fetchMovieDetails(widget.movie.id),
      child: BlocBuilder<MovieDetailCubit, MovieDetailState>(
        builder: (context, state) {
          final isLoaded = state is MovieDetailLoaded;
          final displayMovie = isLoaded ? state.movie : widget.movie;
          final isLoading = state is MovieDetailInitial || state is MovieDetailLoading;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: isLoading
                ? _buildLoadingSkeleton(theme)
                : _buildContent(theme, l10n, movie, displayMovie),
          );
        },
      ),
    );
  }

  Widget _buildLoadingSkeleton(ThemeData theme) {
    return Scaffold(
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
    );
  }

  Widget _buildContent(ThemeData theme, AppLocalizations l10n, Movie movie, Movie displayMovie) {
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
              _buildMovieInfoSection(theme, l10n, displayMovie),
            ],
          ),
          _buildBottomBar(theme, l10n, movie),
          _buildTrailerOverlay(displayMovie),
        ],
      ),
    );
  }

  Widget _buildMovieInfoSection(ThemeData theme, AppLocalizations l10n, Movie displayMovie) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: AppResponsive.screenPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              displayMovie.title,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoTags(theme, displayMovie),
            const SizedBox(height: 32),
            _SectionHeader(title: l10n.storyLine),
            const SizedBox(height: 12),
            Text(
              displayMovie.overview.isNotEmpty
                  ? displayMovie.overview
                  : l10n.storyLine,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 32),
            _SectionHeader(title: l10n.cast),
            const SizedBox(height: 16),
            MovieCastList(cast: displayMovie.cast),
            const SizedBox(height: 32),
            _SectionHeader(title: l10n.selectDate),
            const SizedBox(height: 16),
            if (displayMovie.showTimes.isNotEmpty)
              MovieDateSelector(showTimes: displayMovie.showTimes)
            else
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("No showtimes available yet."),
              ),
            const SizedBox(height: 140),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTags(ThemeData theme, Movie displayMovie) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          MovieInfoTag(
              label: displayMovie.rating.toStringAsFixed(1),
              icon: Icons.star_rounded,
              color: Colors.amber),
          const SizedBox(width: 10),
          MovieInfoTag(
              label: displayMovie.genre.isNotEmpty ? displayMovie.genre.split(', ')[0] : 'Action',
              icon: Icons.movie_filter_outlined,
              color: AppColors.warmOrange),
          const SizedBox(width: 10),
          MovieInfoTag(
              label: displayMovie.duration > 60
                  ? "${displayMovie.duration ~/ 60}h ${displayMovie.duration % 60}m"
                  : "${displayMovie.duration}m",
              icon: Icons.timer_outlined,
              color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme, AppLocalizations l10n, Movie movie) {
    return Positioned(
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
              theme.scaffoldBackgroundColor.withValues(alpha: 0),
              theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
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
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
                      color: AppColors.warmOrange.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SeatSelectionPage(movieTitle: movie.title),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: AppColors.warmOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
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
              ? _FullScreenInlinePlayer(
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

class _FullScreenInlinePlayer extends StatefulWidget {
  final String trailerKey;
  final String posterUrl;
  final VoidCallback onClose;

  const _FullScreenInlinePlayer({
    super.key, 
    required this.trailerKey, 
    required this.posterUrl,
    required this.onClose,
  });

  @override
  State<_FullScreenInlinePlayer> createState() => _FullScreenInlinePlayerState();
}

class _FullScreenInlinePlayerState extends State<_FullScreenInlinePlayer> {
  late final YoutubePlayerController _controller;
  bool _showVideo = true;

  @override
  void initState() {
    super.initState();
    final videoId = extractYoutubeVideoId(widget.trailerKey) ?? '';
    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        playsInline: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void _handleClose() {
    setState(() {
      _showVideo = false;
    });
    widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Blurred Poster Background
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: widget.posterUrl,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(color: Colors.black),
              errorWidget: (_, _, _) => Container(color: Colors.black),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: Colors.black.withValues(alpha: 0.6),
              ),
            ),
          ),
          
          SafeArea(
            child: Stack(
              children: [
                if (_showVideo)
                  Center(
                    child: YoutubePlayer(
                      controller: _controller,
                      aspectRatio: 16 / 9,
                    ),
                  ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white, size: 32),
                    onPressed: _handleClose,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}