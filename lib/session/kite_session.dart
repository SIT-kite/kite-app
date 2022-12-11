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

import 'package:dio/dio.dart';
import 'package:kite/common/entity/kite_user.dart';
import 'package:kite/credential/symbol.dart';
import 'package:kite/storage/dao/kite.dart';
import 'package:kite/util/logger.dart';

import '../module/activity/using.dart';
import 'dio_common.dart';

const String _baseUrl = '${Backend.kite}/api/v2';

class KiteSession implements ISession {
  final Dio dio;
  final JwtDao jwtDao;
  final KiteStorageDao kiteDao;

  KiteSession(
    this.dio,
    this.jwtDao,
    this.kiteDao,
  );

  Future<Response> _dioRequest(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    Future<Response> normallyRequest() async {
      return await _requestWithoutRetry(
        url,
        method,
        queryParameters: queryParameters,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }

    try {
      return await normallyRequest();
    } on KiteApiError catch (e) {
      if (e.code == 100) {
        final oaCredential = Auth.oaCredential!;
        await login(
          oaCredential.account,
          oaCredential.password,
        );
      }
      return await normallyRequest();
    }
  }

  Future<Response> _requestWithoutRetry(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    String? token = jwtDao.jwtToken;
    final response = await dio.request(
      url.startsWith('http') ? url : _baseUrl + url,
      data: data,
      queryParameters: queryParameters,
      options: (options ?? Options()).copyWith(
        method: method,
        headers: token == null ? null : {'Authorization': 'Bearer $token'},
      ),
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    // 非 json 数据
    if (!(response.headers.value(Headers.contentTypeHeader) ?? '').contains('json')) {
      // 直接返回
      return response;
    }
    try {
      final Map<String, dynamic> responseData = response.data;
      if (!responseData.containsKey('code')) return response;
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
        Log.info('请求出错: $responseDataCode $errorMsg');
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
  Future<KiteUser> loginWith({required OACredential oa}) async {
    return await login(oa.account, oa.password);
  }

  Future<KiteUser> login(String username, String password) async {
    final response = await _dioRequest('/session', 'POST', data: {
      'account': username,
      'password': password,
    });
    jwtDao.jwtToken = response.data['token'];
    final profile = KiteUser.fromJson(response.data['profile']);
    kiteDao.userProfile = profile;
    return profile;
  }

  @override
  Future<SessionRes> request(
    String url,
    ReqMethod method, {
    Map<String, String>? para,
    data,
    SessionOptions? options,
    SessionProgressCallback? onSendProgress,
    SessionProgressCallback? onReceiveProgress,
  }) async {
    Response response = await _dioRequest(
      url,
      method.uppercaseName,
      queryParameters: para,
      data: data,
      options: options?.toDioOptions(),
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response.toMyResponse();
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
