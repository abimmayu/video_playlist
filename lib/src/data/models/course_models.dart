import 'package:video_play/src/domain/entities/curriculum_models.dart';

class Course {
  String courseName;
  String progress;
  List<Curriculum> curriculum;

  Course({
    required this.courseName,
    required this.progress,
    required this.curriculum,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        courseName: json["course_name"],
        progress: json["progress"],
        curriculum: List<Curriculum>.from(
          (json["curriculum"] as List).map(
            (e) => Curriculum.fromJson(e),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "course_name": courseName,
        "progress": progress,
        "curriculum": List<dynamic>.from(
          curriculum.map(
            (e) => e.toJson(),
          ),
        )
      };
}
