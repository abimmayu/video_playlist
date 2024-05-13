import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:video_play/core/error/failure.dart';
import 'package:video_play/core/utils/video_download.dart';
import 'package:video_play/src/data/data_source/lesson_data_source.dart';
import 'package:video_play/src/domain/entities/curriculum_models.dart';
import 'package:video_play/src/domain/repositories/video_player_repositories.dart';

class LessonRepositoriesImpl implements LessonRepositories {
  final LessonDataSource lessonDataSource = LessonDataSourceImpl();

  @override
  Future<Either<LessonFailure, List<Curriculum>>> getCurriculum() async {
    try {
      final response = await lessonDataSource.getDataCourse();
      return Right(
        response.curriculum,
      );
    } on DioException catch (error) {
      return Left(
        LessonFailure(
          message: error.message,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, String>> downloadVideo(String url) async {
    try {
      final response = await VideoDownloadUtil.downloadVideo(url);
      return Right(response);
    } on DioException catch (error) {
      return Left(
        LessonFailure(message: error.message),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> checkDownloadStatus(String url) async {
    try {
      final isDownloaded = await VideoDownloadUtil.isVideoDownloaded(url);
      return Right(isDownloaded);
    } catch (e) {
      return Left(
        LessonFailure(
          message: e.toString(),
        ),
      );
    }
  }
}
