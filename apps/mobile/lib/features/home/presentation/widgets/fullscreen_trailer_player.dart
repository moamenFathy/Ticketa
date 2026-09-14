import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ticketa/core/utils/youtube_utils.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class FullScreenInlinePlayer extends StatefulWidget {
  final String trailerKey;
  final String posterUrl;
  final VoidCallback onClose;

  const FullScreenInlinePlayer({
    super.key,
    required this.trailerKey,
    required this.posterUrl,
    required this.onClose,
  });

  @override
  State<FullScreenInlinePlayer> createState() => _FullScreenInlinePlayerState();
}

class _FullScreenInlinePlayerState extends State<FullScreenInlinePlayer> {
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
        mute: true,
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
              memCacheWidth: 1080,
              placeholder: (_, _) => Container(color: Colors.black),
              errorWidget: (_, _, _) => Container(color: Colors.black),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.black.withValues(alpha: 0.6)),
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
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
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
