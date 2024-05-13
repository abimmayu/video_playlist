class Curriculum {
  int key;
  String id;
  String type;
  String title;
  int duration;
  String content;
  List meta;
  int? status;
  String? onlineVideoLink;
  String? offlineVideoLink;

  Curriculum({
    required this.key,
    required this.id,
    required this.type,
    required this.title,
    required this.duration,
    required this.content,
    required this.meta,
    this.status,
    this.onlineVideoLink,
    this.offlineVideoLink,
  });

  factory Curriculum.fromJson(Map<String, dynamic> json) => Curriculum(
        key: json["key"],
        id: json["id"].runtimeType == int ? json["id"].toString() : json["id"],
        type: json["type"],
        title: json["title"],
        duration: json["duration"],
        content: json["content"],
        meta: List.from(json["meta"].map((x) => x)),
        status: json["status"],
        onlineVideoLink: json["online_video_link"],
        offlineVideoLink: json["offline_video_link"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "id": id,
        "type": type,
        "title": title,
        "duration": duration,
        "content": content,
        "meta": List.from(
          meta.map((e) => e),
        ),
        "status": status,
        "online_video_link": onlineVideoLink,
        "offline_video_link": offlineVideoLink,
      };
}
