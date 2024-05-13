import 'package:video_play/core/client/dio.dart';
import 'package:video_play/core/utils/constant.dart';
import 'package:video_play/src/data/models/course_models.dart';

abstract class LessonDataSource {
  Future<Course> getDataCourse();
}

class LessonDataSourceImpl implements LessonDataSource {
  @override
  Future<Course> getDataCourse() async {
    const url = AppConstant.baseUrl;
    final response = await getIt(
      url,
    );
    return Course.fromJson(
      response.data,
    );
  }
}
