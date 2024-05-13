part of 'video_player_bloc.dart';

abstract class VideoPlayerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class VideoPlayerInitialized extends VideoPlayerEvent {}

class VideoPlayerLoad extends VideoPlayerEvent {
  final String url;

  VideoPlayerLoad(
    this.url,
  );

  @override
  List<Object> get props => [url];
}

class VideoSelected extends VideoPlayerEvent {
  final String urlNew;
  final int index;

  VideoSelected(
    this.urlNew,
    this.index,
  );

  @override
  List<Object> get props => [urlNew, index];
}

class DownloadVideoEvent extends VideoPlayerEvent {
  final String url;

  DownloadVideoEvent(this.url);

  @override
  List<Object> get props => [url];
}

class CheckVideoDownloadStatus extends VideoPlayerEvent {
  final String videoUrl;

  CheckVideoDownloadStatus(this.videoUrl);

  @override
  List<Object> get props => [videoUrl];
}

class GetVideoPlayerInternal extends VideoPlayerEvent {
  final String videoUrl;

  GetVideoPlayerInternal(this.videoUrl);

  @override
  List<Object> get props => [videoUrl];
}
