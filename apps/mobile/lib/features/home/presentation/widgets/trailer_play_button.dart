import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ticketa/features/home/models/movie.dart';
import 'package:ticketa/features/home/presentation/widgets/trailer_video_modal.dart';
import 'package:ticketa/core/theme/app_colors.dart';

class TrailerPlayButton extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onPlay;

  const TrailerPlayButton({super.key, required this.movie, this.onPlay});

  void _openTrailer(BuildContext context) {
    if (!movie.hasTrailer) return;
    if (onPlay != null) {
      onPlay!();
    } else {
      showTrailerVideoModal(context, movie.trailerKey!);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!movie.hasTrailer) return const SizedBox.shrink();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openTrailer(context),
        customBorder: const CircleBorder(),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white30),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
