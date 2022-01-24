import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:kite/service/abstract_session.dart';

import '../../global/session_pool.dart';

class ReportSession extends ASession {
  late final Dio _dio;
  final String userId;

  ReportSession(this.userId, {Dio? dio}) {
    _dio = dio ?? SessionPool.dio;
  }

  /// 获取当前以毫秒为单位的时间戳.
  static String _getTimestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  /// 为时间戳生成签名. 此方案是联鹏习惯的反爬方式.
  _md5(s) => md5.convert(const Utf8Encoder().convert(s)).toString();

  _sign(u, t) {
    final hash = _md5('${u}Unifrinew$t').toString().toUpperCase();
    return hash.substring(16, 32) + hash.substring(0, 16);
  }

  @override
  Future<Response<T>> request<T>(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    dynamic data,
    String? contentType,
    ResponseType? responseType,
    Options? options,
  }) async {
    Options newOptions = options ?? Options();

    // Make default options.
    final String ts = _getTimestamp();
    final String sign = _sign(userId, ts);
    final Map<String, dynamic> newHeaders = {'ts': ts, 'decodes': sign};

    newOptions.headers == null ? newOptions.headers = newHeaders : newOptions.headers?.addAll(newHeaders);
    newOptions.method = method;
    newOptions.contentType = contentType;
    newOptions.responseType = responseType;

    return await _dio.request<T>(
      url,
      queryParameters: queryParameters,
      data: data,
      options: newOptions,
    );
  }
}

class ReportException implements Exception {
  String msg;

  ReportException([this.msg = '']);

  @override
  String toString() {
    return msg;
  }
}
