import 'package:dio/dio.dart';
import 'package:kite/global/session_pool.dart';

/// 检查网络连接情况
Future<bool> checkConnectivity() async {
  try {
    await SessionPool.ssoSession.get(
      'http://jwxt.sit.edu.cn/',
      options: Options(
        followRedirects: false,
        sendTimeout: 3,
        receiveTimeout: 3,
        validateStatus: (code) => true,
      ),
    );
    return true;
  } catch (e) {
    return false;
  }
}
