abstract class Failure implements Exception {
  String? title;
  String? message;
  Failure({
    this.title,
    this.message,
  });
}

class LessonFailure extends Failure {
  LessonFailure({super.message})
      : super(
          title: 'Get Data Lesson Failure',
        );
}
