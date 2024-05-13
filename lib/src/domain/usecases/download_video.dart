import 'package:dartz/dartz.dart';
import 'package:video_play/core/error/failure.dart';
import 'package:video_play/src/domain/repositories/video_player_repositories.dart';

class DownloadVideoUseCase {
  final LessonRepositories repositories;

  DownloadVideoUseCase(this.repositories);

  Future<Either<Failure, String>> download(String url) async {
    return await repositories.downloadVideo(url);
  }
}
