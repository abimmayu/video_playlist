part of 'lesson_bloc.dart';

abstract class LessonState extends Equatable {}

class LessonLoading extends LessonState {
  @override
  List<Object> get props => [];
}

class LessonError extends LessonState {
  final String error;

  LessonError(
    this.error,
  );
  @override
  List<Object> get props => [error];
}

class LessonLoaded extends LessonState {
  final List<Curriculum> curriculum;
  LessonLoaded(
    this.curriculum,
  );

  @override
  List<Object> get props => [
        curriculum,
      ];
}

class LessonEmpty extends LessonState {
  @override
  List<Object> get props => [];
}
