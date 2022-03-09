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

/// 应网办登录地址, POST 请求
const String _officeLoginUrl = 'https://xgfy.sit.edu.cn/unifri-flow/login';

Future<OfficeSession> officeLogin(String username, String password) async {
  final dio = SessionPool.dio;
  final Map<String, String> credential = {'account': username, 'userPassword': password, 'remember': 'true'};

  final response =
      await dio.post(_officeLoginUrl, data: credential, options: Options(contentType: Headers.jsonContentType));
  final int code = (response.data as Map)['code'];

  if (code != 0) {
    final String errMessage = (response.data as Map)['msg'];
    throw OfficeLoginException('($code) $errMessage');
  }
  final String jwt = ((response.data as Map)['data'])['authorization'];
  return OfficeSession(username, jwt);
}

class OfficeSession extends ASession {
  final String _userName;
  final String _jwtToken;
  late final Dio _dio;

  OfficeSession(this._userName, this._jwtToken, {Dio? dio}) {
    _dio = dio ?? SessionPool.dio;
  }

  String get userName => _userName;

  /// 获取当前以毫秒为单位的时间戳.
  static String _getTimestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  /// 为时间戳生成签名. 此方案是联鹏习惯的反爬方式.
  static String _sign(String ts) {
    final content = const Utf8Encoder().convert('unifri.com' + ts);
    return md5.convert(content).toString();
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
    final String sign = _sign(ts);
    final Map<String, dynamic> newHeaders = {'timestamp': ts, 'signature': sign, 'Authorization': _jwtToken};

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

class OfficeLoginException implements Exception {
  String msg;

  OfficeLoginException([this.msg = '']);

  @override
  String toString() {
    return msg;
  }
}
