part of 'video_player_bloc.dart';

abstract class VideoPlayerState extends Equatable {
  @override
  List<Object> get props => [];
}

class VideoUninitialized extends VideoPlayerState {}

class VideoInitializedState extends VideoPlayerState {
  final VideoPlayerController controller;
  final bool isPlayed;
  final int index;

  VideoInitializedState(this.controller, this.isPlayed, this.index);

  @override
  List<Object> get props => [controller, isPlayed, index];
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
  final bool isExist;

  VideoDownloaded(this.filePath, this.isExist);

  @override
  List<Object> get props => [filePath];
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
