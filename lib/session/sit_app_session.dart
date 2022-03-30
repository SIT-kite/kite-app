import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/setting/dao/jwt.dart';
import 'package:kite/setting/init.dart';
import 'package:kite/util/logger.dart';

class SitAppSession extends ASession {
  final Dio dio;
  final JwtDao jwtDao;

  SitAppSession(this.dio, this.jwtDao);

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
    Future<Response> normallyRequest() async {
      return await _requestWithoutRetry(
        url,
        method,
        queryParameters: queryParameters,
        data: data,
        options: options,
        contentType: contentType,
        responseType: responseType,
      );
    }

    try {
      return await normallyRequest();
    } on SitAppApiError catch (e, _) {
      if (e.code == 500) {
        await login(
          SettingInitializer.auth.currentUsername!,
          SettingInitializer.auth.ssoPassword!,
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
    String? contentType,
    ResponseType? responseType,
  }) async {
    String? token = jwtDao.jwtToken;
    final response = await dio.request(
      url,
      data: data,
      queryParameters: queryParameters,
      options: (options ?? Options()).copyWith(
        method: method,
        contentType: contentType ?? ContentType.json.value,
        responseType: responseType ?? ResponseType.json,
        headers: () {
          final Map<String, String> headersMap = {};
          if (token != null) headersMap['Authorization'] = token;
          return headersMap;
        }(),
      ),
    );
    // 非 json 数据
    if (!(response.headers.value(Headers.contentTypeHeader) ?? '').contains('json')) {
      // 直接返回
      return response;
    }
    try {
      final Map<String, dynamic> responseData = response.data;
      final responseDataCode = responseData['code'];
      // 请求正常
      if (responseDataCode == 0) {
        // 直接取数据然后返回
        return response;
      }
      // 请求异常

      // 存在code,但是不为0
      if (responseDataCode != null) {
        final errorMsg = responseData['msg'];
        Log.info('请求出错: $errorMsg');
        throw SitAppApiError(responseDataCode, errorMsg);
      }
    } on SitAppApiError catch (e) {
      // api请求有误
      Log.info('请求出错: ${e.msg}');
      rethrow;
    }
    throw SitAppApiFormatError(response.data);
  }

  /// 用户登录
  /// 用户不存在时，将自动创建用户
  Future<Response> login(String username, String password) async {
    final response = await post('http://210.35.96.115:8099/login', data: {
      'userName': username,
      'userPassword': password,
    });
    jwtDao.jwtToken = response.data['data'];
    return response;
  }
}

class SitAppApiError implements Exception {
  final int code;
  final String? msg;

  const SitAppApiError(this.code, this.msg);

  @override
  String toString() {
    return 'SitAppApiError{code: $code, msg: $msg}';
  }
}

/// 服务器数据返回格式有误
class SitAppApiFormatError implements Exception {
  final dynamic responseData;

  const SitAppApiFormatError(this.responseData);

  @override
  String toString() {
    return 'SitAppApiFormatError{responseData: $responseData}';
  }
}
