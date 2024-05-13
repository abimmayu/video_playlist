import 'package:video_play/core/client/dio.dart';

abstract class DownloadVideoDataSource {
  Future<String> downloadVideo(String url);
}

class DownloadVideoDataSourceImpl implements DownloadVideoDataSource {
  @override
  Future<String> downloadVideo(String url) async {
    final response = await getIt(
      url,
    );

    return response.data;
  }
}
