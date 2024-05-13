import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_play/src/domain/usecases/check_download_status.dart';
import 'package:video_play/src/domain/usecases/download_video.dart';
import 'package:video_player/video_player.dart';

part 'video_player_event.dart';
part 'video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  late VideoPlayerController controller;
  final DownloadVideoUseCase downloadVideoUseCase;
  final CheckDownloadStatusUseCase checkDownloadStatusUseCase;
  int selected = 1;
  bool showControls = true;
  bool downloadStatus = true;

  VideoPlayerBloc(
    this.downloadVideoUseCase,
    this.checkDownloadStatusUseCase,
  ) : super(
          VideoUninitialized(),
        ) {
    on<VideoPlayerLoad>(
      (event, emit) async {
        return await initializeVideo(
          event.url,
          emit,
        );
      },
    );
    on<VideoSelected>(
      (event, emit) async {
        return await changeVideo(
          event.urlNew,
          emit,
          event.index,
        );
      },
    );
    on<DownloadVideoEvent>(
      (event, emit) async {
        return await downloadVideo(
          event.url,
          emit,
        );
      },
    );
    on<CheckVideoDownloadStatus>(
      (event, emit) async {
        return await checkDownloadedStatus(
          event.videoUrl,
          emit,
        );
      },
    );
    on<GetVideoPlayerInternal>(
      (event, emit) async {
        return await changeVideoInternal(
          event.videoUrl,
          emit,
        );
      },
    );
  }

  Future<void> initializeVideo(
    String url,
    Emitter<VideoPlayerState> emit,
  ) async {
    controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
    )..initialize();
    controller.setLooping(true);

    emit(
      VideoInitializedState(controller),
    );
  }

  Future<void> changeVideo(
    String newUrl,
    Emitter<VideoPlayerState> emit,
    int index,
  ) async {
    controller.dispose();

    emit(
      VideoUninitialized(),
    );

    selected = index;
    controller = VideoPlayerController.networkUrl(
      Uri.parse(newUrl),
    )..initialize();
    controller.setLooping(true);
    showControls = true;

    emit(
      VideoInitializedState(controller),
    );
  }

  Future<void> changeVideoInternal(
    String url,
    Emitter<VideoPlayerState> emit,
  ) async {
    controller.dispose();

    emit(
      VideoUninitialized(),
    );

    final fileName = url.split('/').last;
    log(fileName);
    final path =
        '/data/user/0/com.example.video_play/app_flutter/videos/$fileName';

    controller = VideoPlayerController.file(
      File(path),
    )..initialize();
    controller.setLooping(true);
    showControls = true;

    emit(
      VideoInitializedState(controller),
    );
  }

  Future<void> checkDownloadedStatus(
    String url,
    Emitter<VideoPlayerState> emit,
  ) async {
    controller.dispose();

    emit(
      VideoUninitialized(),
    );

    final result = await checkDownloadStatusUseCase.checkDownloadStatus(url);
    result.fold(
      (l) => emit(
        VideoDownloadError(l.message!),
      ),
      (r) async {
        if (!r) {
          add(
            DownloadVideoEvent(url),
          );
          downloadStatus = r;
          log(
            "Download Status: $downloadStatus",
          );
        } else {
          add(
            GetVideoPlayerInternal(url),
          );
          downloadStatus = r;
          log(
            "Download Status: $downloadStatus",
          );

          return null;
        }
      },
    );
  }

  Future<void> downloadVideo(
    String url,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(
      VideoDownloading(),
    );
    controller.dispose();

    final result = await downloadVideoUseCase.download(url);
    result.fold(
      (l) => emit(
        VideoDownloadError(
          l.message!,
        ),
      ),
      (r) {
        controller = VideoPlayerController.file(
          File(r),
        )..initialize();
        controller.setLooping(true);
        showControls = true;

        emit(
          VideoDownloaded(r, controller),
        );
      },
    );
  }
}
