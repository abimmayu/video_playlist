import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_play/src/domain/usecases/check_download_status.dart';
import 'package:video_play/src/domain/usecases/delete_video.dart';
import 'package:video_play/src/domain/usecases/download_video.dart';
import 'package:video_player/video_player.dart';

part 'video_player_event.dart';
part 'video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  late VideoPlayerController controller;
  final DownloadVideoUseCase downloadVideoUseCase;
  final CheckDownloadStatusUseCase checkDownloadStatusUseCase;
  final DeleteVideoUseCases deleteVideoUseCases;

  int selected = 1;
  bool showControls = true;
  bool downloadStatus = false;
  bool isWatched = false;
  bool isDownloading = false;

  VideoPlayerBloc(
    this.downloadVideoUseCase,
    this.checkDownloadStatusUseCase,
    this.deleteVideoUseCases,
  ) : super(
          VideoUninitialized(),
        ) {
    on<VideoIntialize>(
      (event, emit) async {
        await initializeVideo(
          event.onlineUrl,
          event.offlineUrl,
          selected,
          emit,
        );
      },
    );
    on<VideoDownload>(
      (event, emit) async {
        await downloadVideo(
          event.url,
          emit,
        );
      },
    );
    on<VideoPlayerPlay>(
      (event, emit) {
        controller.play();
        emit(
          VideoInitializedState(controller, true, selected),
        );
      },
    );
    on<VideoPlayerPause>(
      (event, emit) {
        controller.pause();
        emit(
          VideoInitializedState(controller, false, selected),
        );
      },
    );
    on<DeleteVideo>(
      (event, emit) async {
        controller.dispose();
        await deleteVideo(
          event.onlineUrl,
          event.offlineUrl,
          emit,
        );
      },
    );
    // on<VideoPlayerLoad>(
    //   (event, emit) async {
    //     emit(
    //       VideoUninitialized(),
    //     );
    //     await initializeVideo(
    //       event.url,
    //       emit,
    //     );
    //   },
    // );
    // on<VideoSelected>(
    //   (event, emit) async {
    //     await changeVideo(
    //       event.urlNew,
    //       emit,
    //     );
    //   },
    // );

    // on<CheckExistVideoFile>(
    //   (event, emit) async {
    //     await checkDownloadedStatus(
    //       event.url,
    //       emit,
    //     );
    //   },
    // );
  }

  Future<void> initializeVideo(
    String onlineUrl,
    String offlineUrl,
    int index,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(
      VideoUninitialized(),
    );

    // log("controller saat ini: ${controller.value.isInitialized}");
    // if (controller.value.isInitialized) {
    //   controller.dispose();
    // }

    final filePath = await getApplicationDocumentsDirectory();
    final fileName = offlineUrl.split('/').last;
    final fileLocation = '${filePath.path}/videos/$fileName';

    final isVideoExist =
        await checkDownloadStatusUseCase.checkDownloadStatus(offlineUrl);

    isVideoExist.fold(
      (l) => emit(
        VideoDownloadError(l.message!),
      ),
      (r) async {
        if (!r) {
          controller = VideoPlayerController.networkUrl(
            Uri.parse(onlineUrl),
          )..initialize();
          return emit(
            VideoInitializedState(controller, false, selected),
          );
        } else {
          controller = VideoPlayerController.file(
            File(fileLocation),
          )..initialize();
          return emit(
            VideoInitializedState(controller, false, selected),
          );
        }
      },
    );
  }

  Future<void> downloadVideo(
    String offlineUrl,
    Emitter<VideoPlayerState> emit,
  ) async {
    controller.pause();

    final isVideoExist =
        await checkDownloadStatusUseCase.checkDownloadStatus(offlineUrl);

    isVideoExist.fold(
      (l) => emit(
        VideoDownloadError(l.message!),
      ),
      (r) async {
        if (!r) {
          emit(
            VideoDownloadProgress(),
          );
          final result = await downloadVideoUseCase.download(
            offlineUrl,
          );

          result.fold(
            (l) => emit(
              VideoDownloadError(l.message!),
            ),
            (r) async {
              add(
                VideoIntialize('onlineUrl', offlineUrl, 0),
              );
            },
          );
        } else {
          log("disini yang berjalan");
        }
      },
    );
  }

  Future<void> deleteVideo(
    String onlineUrl,
    String offlineUrl,
    Emitter<VideoPlayerState> emit,
  ) async {
    controller.pause();

    final delete = await deleteVideoUseCases.execute(offlineUrl);
    delete.fold(
      (l) => emit(
        VideoDownloadError(l.message!),
      ),
      (r) {
        log("Berhasil menghapus data!");
        controller.dispose();
        add(
          VideoIntialize(onlineUrl, offlineUrl, 0),
        );
      },
    );
  }

  // Future<void> checkDownloadedStatus(
  //   String url,
  //   Emitter<VideoPlayerState> emit,
  // ) async {
  //   emit(
  //     VideoUninitialized(),
  //   );

  //   final filePath = await getApplicationDocumentsDirectory();
  //   final fileName = url.split('/').last;
  //   final fileLocation = '${filePath.path}/videos/$fileName';

  //   final result = await checkDownloadStatusUseCase.checkDownloadStatus(url);
  //   result.fold(
  //     (l) => emit(
  //       VideoDownloadError(l.message!),
  //     ),
  //     (r) async {
  //       if (!r) {
  //         downloadStatus = r;
  //         log(
  //           "Download Status: $downloadStatus",
  //         );
  //       } else {
  //         downloadStatus = r;
  //         log(
  //           "Download Status: $downloadStatus",
  //         );
  //       }
  //     },
  //   );
  // }
}
