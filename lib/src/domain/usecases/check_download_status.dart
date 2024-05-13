import 'package:dartz/dartz.dart';
import 'package:video_play/core/error/failure.dart';
import 'package:video_play/src/domain/repositories/video_player_repositories.dart';

class CheckDownloadStatusUseCase {
  final LessonRepositories lessonRepositories;

  CheckDownloadStatusUseCase(this.lessonRepositories);

  Future<Either<Failure, bool>> checkDownloadStatus(String url) async {
    return await lessonRepositories.checkDownloadStatus(url);
  }
}
