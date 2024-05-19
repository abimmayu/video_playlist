import 'package:get_it/get_it.dart';
import 'package:video_play/src/data/data_source/lesson_data_source.dart';
import 'package:video_play/src/data/repositories/video_player_repositories_impl.dart';
import 'package:video_play/src/domain/repositories/video_player_repositories.dart';
import 'package:video_play/src/domain/usecases/check_download_status.dart';
import 'package:video_play/src/domain/usecases/delete_video.dart';
import 'package:video_play/src/domain/usecases/download_video.dart';
import 'package:video_play/src/domain/usecases/get_lesson.dart';
import 'package:video_play/src/presentation/bloc/lesson_bloc/lesson_bloc.dart';
import 'package:video_play/src/presentation/bloc/video_player_bloc/video_player_bloc.dart';

final locator = GetIt.instance;

void init() {
  //bloc
  locator.registerFactory(
    () => LessonBloc(
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
    () => VideoPlayerBloc(
      locator(),
      locator(),
      locator(),
    ),
  );

  //usecases
  locator.registerLazySingleton(
    () => GetLesson(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => DownloadVideoUseCase(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => CheckDownloadStatusUseCase(
      locator(),
    ),
  );
  locator.registerLazySingleton(
    () => DeleteVideoUseCases(),
  );

  //repository
  locator.registerLazySingleton<LessonRepositories>(
    () => LessonRepositoriesImpl(),
  );

  //data source
  locator.registerLazySingleton<LessonDataSource>(
    () => LessonDataSourceImpl(),
  );

  //controller
  // locator.registerLazySingleton(
  //   () => Video(),
  // );
}
