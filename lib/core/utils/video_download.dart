import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:video_play/core/client/dio.dart';

class VideoDownloadUtil {
  static Future<bool> isVideoDownloaded(String url) async {
    try {
      Directory? appDirectory = await getApplicationDocumentsDirectory();
      String fileName = url.split('/').last;
      String videoPath = '${appDirectory.path}/videos/$fileName';
      return await File(videoPath).exists();
    } catch (e) {
      throw Exception("Failed to check video status: $e");
    }
  }

  static Future<String> downloadVideo(String url) async {
    try {
      Directory? appDirectory = await getApplicationDocumentsDirectory();
      String videoDirectory = '${appDirectory.path}/videos';
      Directory(videoDirectory).create(recursive: true);
      String fileName = url.split('/').last;
      String savePath = '$videoDirectory/$fileName';

      await downloadIt(url, savePath);

      return savePath;
    } catch (e) {
      throw Exception("Failed to download video: $e");
    }
  }

  static deleteVideo(String url) async {
    try {
      Directory? appDirectory = await getApplicationDocumentsDirectory();
      String fileName = url.split('/').last;
      String videoPath = '${appDirectory.path}/videos/$fileName';
      File file = File(videoPath);
      if (file.existsSync()) {
        var delete = await file.delete();
        return delete;
      }
    } catch (e) {
      throw Exception("Failed to delete video: $e");
    }
  }
}
