part of 'lesson_bloc.dart';

abstract class LessonEvent extends Equatable {}

class GetLessonEvent extends LessonEvent {
  GetLessonEvent();

  @override
  List<Object> get props => [];
}
