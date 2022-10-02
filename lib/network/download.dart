import 'package:kite/network/session.dart';

abstract class Downloader {
  Future<void> download(
    String url, {
    String? savePath,
    MyProgressCallback? onReceiveProgress,
    Map<String, String>? queryParameters,
    dynamic data,
    SessionOptions? options,
  });
}
