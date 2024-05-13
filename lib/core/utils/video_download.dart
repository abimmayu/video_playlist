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
      log(videoPath);
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
      log(videoDirectory);
      String fileName = url.split('/').last;
      String savePath = '$videoDirectory/$fileName';

      await downloadIt(url, savePath);

      return savePath;
    } catch (e) {
      throw Exception("Failed to download video: $e");
    }
  }
}
