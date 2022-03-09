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
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kite/domain/kite/entity/account.dart';
import 'package:kite/session/abstract_session.dart';
import 'package:kite/setting/dao/jwt.dart';
import 'package:kite/util/logger.dart';

const String _baseUrl = 'https://kite.sunnysab.cn/api/v2';

class KiteSession extends ASession {
  final Dio dio;
  final JwtDao jwtDao;
  KiteUser? profile;

  KiteSession(this.dio, this.jwtDao);

  @override
  Future<Response> request(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    data,
    Options? options,
    String? contentType,
    ResponseType? responseType,
  }) async {
    String? token = jwtDao.jwtToken;
    final response = await dio.request(
      _baseUrl + url,
      data: data,
      queryParameters: queryParameters,
      options: (options ?? Options()).copyWith(
        method: method,
        contentType: contentType ?? ContentType.json.value,
        responseType: responseType ?? ResponseType.json,
        headers: token == null ? null : {'Authorization': 'Bearer ' + token},
      ),
    );
    try {
      final Map<String, dynamic> responseData = response.data;
      final responseDataCode = responseData['code'];
      // 请求正常
      if (responseDataCode == 0) {
        // 直接取数据然后返回
        response.data = responseData['data'];
        return response;
      }
      // 请求异常

      // 存在code,但是不为0
      if (responseDataCode != null) {
        final errorMsg = responseData['msg'];
        Log.info('请求出错: $errorMsg');
        throw KiteApiError(responseDataCode, errorMsg);
      }
    } on KiteApiError catch (e) {
      // api请求有误
      Log.info('请求出错: ${e.msg}');
      rethrow;
    }
    throw KiteApiFormatError(response.data);
  }

  /// 用户登录
  /// 用户不存在时，将自动创建用户
  Future<KiteUser> login(String username, String password) async {
    final response = await post('/session', data: {
      'account': username,
      'password': password,
    });
    jwtDao.jwtToken = response.data['token'];
    profile = KiteUser.fromJson(response.data['profile']);
    return profile!;
  }
}

class KiteApiError implements Exception {
  final int code;
  final String? msg;

  const KiteApiError(this.code, this.msg);

  @override
  String toString() {
    return 'KiteApiError{code: $code, msg: $msg}';
  }
}

/// 服务器数据返回格式有误
class KiteApiFormatError implements Exception {
  final dynamic responseData;

  const KiteApiFormatError(this.responseData);

  @override
  String toString() {
    return 'KiteApiFormatError{responseData: $responseData}';
  }
}
