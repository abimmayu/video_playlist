part of 'video_player_bloc.dart';

abstract class VideoPlayerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class VideoPlayerPlay extends VideoPlayerEvent {}

class VideoPlayerPause extends VideoPlayerEvent {}

class VideoIntialize extends VideoPlayerEvent {
  final String onlineUrl;
  final String offlineUrl;
  final int index;

  VideoIntialize(
    this.onlineUrl,
    this.offlineUrl,
    this.index,
  );

  @override
  List<Object> get props => [onlineUrl, offlineUrl, index];
}

class VideoDownload extends VideoPlayerEvent {
  final String url;

  VideoDownload(this.url);

  @override
  List<Object> get props => [url];
}

class DeleteVideo extends VideoPlayerEvent {
  final String onlineUrl;
  final String offlineUrl;

  DeleteVideo(this.onlineUrl, this.offlineUrl);

  @override
  List<Object> get props => [onlineUrl, offlineUrl];
}

class CheckExistVideoFile extends VideoPlayerEvent {
  final String url;

  CheckExistVideoFile(this.url);

  @override
  List<Object> get props => [];
}
