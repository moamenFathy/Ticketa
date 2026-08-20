import 'package:flutter/material.dart';
import 'package:ticketa/core/utils/youtube_utils.dart';
import 'package:ticketa/l10n/app_localizations.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

Future<void> showTrailerVideoModal(
  BuildContext context,
  String trailerKey,
) async {
  final l10n = AppLocalizations.of(context)!;
  final videoId = extractYoutubeVideoId(trailerKey);
  if (videoId == null || videoId.isEmpty) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.trailerNotAvailable)));
    return;
  }

  await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => _TrailerFullScreenPage(videoId: videoId)),
  );
}

class _TrailerFullScreenPage extends StatefulWidget {
  final String videoId;

  const _TrailerFullScreenPage({required this.videoId});

  @override
  State<_TrailerFullScreenPage> createState() => _TrailerFullScreenPageState();
}

class _TrailerFullScreenPageState extends State<_TrailerFullScreenPage> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        playsInline: false, // false to indicate it's meant to be full screen
        mute: true,
        enableCaption: false,
        strictRelatedVideos: true,
        pointerEvents: PointerEvents.auto,
      ),
    );

    _controller.listen((value) {
      if (value.playerState == PlayerState.playing) _unmuteSoon();
    });
  }

  Future<void> _unmuteSoon() async {
    await Future.delayed(const Duration(milliseconds: 900));
    await _controller.unMute();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
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
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 32,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 10)],
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
