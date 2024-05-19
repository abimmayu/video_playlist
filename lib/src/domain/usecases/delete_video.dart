import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:video_play/core/error/failure.dart';
import 'package:video_play/src/data/repositories/video_player_repositories_impl.dart';
import 'package:video_play/src/domain/repositories/video_player_repositories.dart';

class DeleteVideoUseCases {
  LessonRepositories lessonRepositories = LessonRepositoriesImpl();

  Future<Either<Failure, FileSystemEntity>> execute(String url) async {
    return await lessonRepositories.deleteVideo(url);
  }
}
