import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_play/src/presentation/bloc/video_player_bloc/video_player_bloc.dart';
import 'package:video_play/src/presentation/widgets/play_pause_overlay_button.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
      builder: (context, state) {
        if (state is VideoInitializedState) {
          void startControlTimer() {
            Future.delayed(
              const Duration(seconds: 2),
              () {
                if (state.controller.value.isPlaying) {
                  setState(
                    () {
                      context.read<VideoPlayerBloc>().showControls = false;
                    },
                  );
                }
              },
            );
          }

          void togglePlayPause() {
            setState(
              () {
                if (state.controller.value.isPlaying) {
                  state.controller.pause();
                  context.read<VideoPlayerBloc>().showControls = true;
                } else {
                  state.controller.play();
                  startControlTimer();
                }
              },
            );
          }

          return mediaPlayer(
            state.controller,
            () {
              togglePlayPause();
            },
            state.isPlayed,
          );
        } else if (state is VideoUninitialized) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is VideoDownloadError) {
          return Center(
            child: Text(state.error),
          );
        } else {
          return const AspectRatio(
            aspectRatio: 1.77777777,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  //Widget for MediaPlayer
  Widget mediaPlayer(
    VideoPlayerController controller,
    void Function() togglePlayPause,
    bool isPlayed,
  ) {
    return AspectRatio(
      aspectRatio: 1.77777777777,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GestureDetector(
                onTap: togglePlayPause,
                child: VideoPlayer(
                  controller,
                ),
              ),
              VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Colors.blue,
                ),
              ),
            ],
          ),
          PlayPauseOverlay(
            controller: controller,
            showControl: context.read<VideoPlayerBloc>().showControls,
            onTap: () {
              return togglePlayPause();
            },
          )
        ],
      ),
    );
  }
}
