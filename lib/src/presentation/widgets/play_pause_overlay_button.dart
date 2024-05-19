import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_play/src/presentation/bloc/video_player_bloc/video_player_bloc.dart';
import 'package:video_player/video_player.dart';

class PlayPauseOverlay extends StatefulWidget {
  const PlayPauseOverlay({
    super.key,
    required this.controller,
    required this.showControl,
    required this.onTap,
  });

  final VideoPlayerController controller;
  final bool showControl;
  final void Function() onTap;

  @override
  State<PlayPauseOverlay> createState() => _PlayPauseOverlayState();
}

class _PlayPauseOverlayState extends State<PlayPauseOverlay> {
  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
      builder: (context, state) {
        if (widget.showControl) {
          if (state is VideoInitializedState) {
            return button(state.controller);
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }

  Widget button(VideoPlayerController controller) {
    if (controller.value.isPlaying) {
      return IconButton(
        onPressed: widget.onTap,
        icon: const Icon(
          Icons.pause,
          color: Colors.white,
          size: 50,
        ),
      );
    } else {
      return IconButton(
        onPressed: widget.onTap,
        icon: Container(
          padding: const EdgeInsets.all(
            10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              100,
            ),
            color: Colors.white,
          ),
          child: const Icon(
            Icons.play_arrow,
            color: Colors.blue,
            size: 25,
          ),
        ),
      );
    }
  }
}
