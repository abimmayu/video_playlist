import 'package:flutter/material.dart';
import 'package:video_play/src/presentation/widgets/play_pause_overlay_button.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({
    super.key,
    required this.urlVideo,
  });

  final String urlVideo;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.urlVideo,
      ),
    );

    _controller.setLooping(true);
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
    });
    _startControlTimer();
  }

  void _startControlTimer() {
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (_controller.value.isPlaying) {
          setState(
            () {
              _showControls = false;
            },
          );
        }
      },
    );
  }

  void _togglePlayPause() {
    setState(
      () {
        if (_controller.value.isPlaying) {
          _controller.pause();
          _showControls = true;
        } else {
          _controller.play();
          _startControlTimer();
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      GestureDetector(
                        onTap: _togglePlayPause,
                        child: VideoPlayer(
                          _controller,
                        ),
                      ),
                      VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                          playedColor: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  PlayPauseOverlay(
                    controller: _controller,
                    showControl: _showControls,
                    onTap: () {
                      return _togglePlayPause();
                    },
                  )
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
