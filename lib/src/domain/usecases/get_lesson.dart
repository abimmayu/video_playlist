import 'package:dartz/dartz.dart';
import 'package:video_play/core/error/failure.dart';
import 'package:video_play/src/domain/entities/curriculum.dart';
import 'package:video_play/src/domain/repositories/video_player_repositories.dart';

class GetLesson {
  GetLesson(
    this.lessonRepositories,
  );

  final LessonRepositories lessonRepositories;

  Future<Either<Failure, List<Curriculum>>> execute() {
    return lessonRepositories.getCurriculum();
  }
}
