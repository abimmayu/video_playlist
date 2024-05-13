import 'package:dio/dio.dart';
import 'package:logger/web.dart';

Future<Response> getIt(
  String url,
) async {
  Logger().i(url);
  final response = await Dio().get(
    url,
  );
  Logger().d(response.data);
  return response;
}

Future<Response> downloadIt(
  String url,
  String savePath,
) async {
  Logger().i(url);
  Logger().i(savePath);
  final response = await Dio().download(
    url,
    savePath,
  );
  Logger().d(response.data);
  return response;
}
