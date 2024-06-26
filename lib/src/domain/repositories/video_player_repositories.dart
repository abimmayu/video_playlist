import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:video_play/core/error/failure.dart';
import 'package:video_play/src/domain/entities/curriculum.dart';

abstract class LessonRepositories {
  Future<Either<Failure, List<Curriculum>>> getCurriculum();
  Future<Either<Failure, String>> downloadVideo(String url);
  Future<Either<Failure, bool>> checkDownloadStatus(String url);
  Future<Either<Failure, FileSystemEntity>> deleteVideo(String url);
}
