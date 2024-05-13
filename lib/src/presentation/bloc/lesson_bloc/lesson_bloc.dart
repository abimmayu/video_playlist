import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_play/src/domain/entities/curriculum_models.dart';
import 'package:video_play/src/domain/usecases/get_lesson.dart';
import 'package:video_play/src/presentation/bloc/video_player_bloc/video_player_bloc.dart';

part 'lesson_event.dart';
part 'lesson_state.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  final GetLesson getLesson;
  final VideoPlayerBloc videoBloc;
  LessonBloc(
    this.getLesson,
    this.videoBloc,
  ) : super(
          LessonEmpty(),
        ) {
    on<GetLessonEvent>(
      (event, emit) {
        return onLoadLesson(
          event,
          emit,
        );
      },
    );
  }

  Future<void> onLoadLesson(
    GetLessonEvent event,
    Emitter<LessonState> emit,
  ) async {
    emit(
      LessonLoading(),
    );
    final result = await getLesson.execute();
    result.fold(
      (l) => emit(
        LessonError(l.message!),
      ),
      (r) {
        emit(
          LessonLoaded(r),
        );
        videoBloc.add(
          VideoPlayerLoad(r[1].onlineVideoLink!),
        );
      },
    );
  }
}
