/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:kite/abstract/abstract_session.dart';

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
  Future<Response> request(
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

    return await _dio.request(
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
