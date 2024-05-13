part of 'video_player_bloc.dart';

abstract class VideoPlayerState extends Equatable {
  @override
  List<Object> get props => [];
}

class VideoUninitialized extends VideoPlayerState {}

class VideoInitializedState extends VideoPlayerState {
  final VideoPlayerController controller;

  VideoInitializedState(this.controller);

  @override
  List<Object> get props => [controller];
}

class VideoDownloading extends VideoPlayerState {}

class VideoDownloadError extends VideoPlayerState {
  final String error;

  VideoDownloadError(this.error);

  @override
  List<Object> get props => [error];
}

class VideoDownloaded extends VideoPlayerState {
  final String filePath;
  final VideoPlayerController videoPlayerController;

  VideoDownloaded(this.filePath, this.videoPlayerController);

  @override
  List<Object> get props => [
        filePath,
        videoPlayerController,
      ];
}

class VideoNotDownloaded extends VideoPlayerState {}
