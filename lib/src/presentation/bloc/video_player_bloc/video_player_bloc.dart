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
  bool downloadStatus = false;
  bool isWatched = false;
  bool isDownloading = false;

  VideoPlayerBloc(
    this.downloadVideoUseCase,
    this.checkDownloadStatusUseCase,
  ) : super(
          VideoUninitialized(),
        ) {
    on<VideoPlayerLoad>(
      (event, emit) async {
        isDownloading = true;
        emit(
          VideoUninitialized(),
        );
        await initializeVideo(
          event.url,
          emit,
        );
        isDownloading = false;
      },
    );
    on<VideoSelected>(
      (event, emit) async {
        isDownloading = true;
        await changeVideo(
          event.urlNew,
          emit,
          event.index,
        );
        isDownloading = false;
      },
    );
    on<DownloadVideoEvent>(
      (event, emit) async {
        isDownloading = true;
        await downloadVideo(
          event.url,
          emit,
        );
        isDownloading = false;
      },
    );
    on<CheckVideoDownloadStatus>(
      (event, emit) async {
        isDownloading = true;
        await checkDownloadedStatus(
          event.videoUrl,
          emit,
        );
        isDownloading = false;
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
    showControls = true;

    emit(
      VideoSelection(index),
    );

    emit(
      VideoInitializedState(
        controller,
      ),
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

    final filePath = await getApplicationDocumentsDirectory();

    final fileName = url.split('/').last;
    final path = '${filePath.path}/videos/$fileName';

    controller = VideoPlayerController.file(
      File(path),
    )..initialize();
    // controller.addListener(
    //   () {
    //     if (controller.value.position == controller.value.duration) {
    //       showControls = true;
    //       isWatched = true;
    //     }
    //   },
    // );
    showControls = true;

    emit(
      VideoInitializedState(controller),
    );
  }

  Future<void> checkDownloadedStatus(
    String url,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(
      VideoUninitialized(),
    );
    final filePath = await getApplicationCacheDirectory();
    final fileName = url.split('/').last;
    final fileLocation = '${filePath.path}/videos/$fileName';

    final result = await checkDownloadStatusUseCase.checkDownloadStatus(url);
    result.fold(
      (l) => emit(
        VideoDownloadError(l.message!),
      ),
      (r) async {
        if (!r) {
          downloadStatus = r;
          emit(
            VideoDownloadSuccess(r, fileLocation),
          );
          add(
            DownloadVideoEvent(url),
          );
          log(
            "Download Status: $downloadStatus",
          );
        } else {
          emit(
            VideoDownloadSuccess(r, fileLocation),
          );
          add(
            GetVideoPlayerInternal(url),
          );
          downloadStatus = r;
          log(
            "Download Status: $downloadStatus",
          );
        }
      },
    );
  }

  Future<void> downloadVideo(
    String url,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(
      VideoDownloading(
        0.0,
      ),
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
          VideoDownloading(1),
        );

        emit(
          VideoDownloaded(r, controller),
        );
      },
    );
  }
}
