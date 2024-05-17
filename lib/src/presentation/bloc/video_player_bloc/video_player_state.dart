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

class VideoSelection extends VideoPlayerState {
  final int index;

  VideoSelection(this.index);

  @override
  List<Object> get props => [index];
}

class VideoDownloading extends VideoPlayerState {
  final double progress;

  VideoDownloading(this.progress);

  @override
  List<Object> get props => [progress];
}

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

class VideoDownloadProgress extends VideoPlayerState {}

class VideoDownloadSuccess extends VideoPlayerState {
  final bool isDownloaded;
  final String fileLocation;

  VideoDownloadSuccess(this.isDownloaded, this.fileLocation);

  @override
  List<Object> get props => [isDownloaded, fileLocation];
}
