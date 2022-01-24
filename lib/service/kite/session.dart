import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:kite/dao/kite/jwt.dart';
import 'package:kite/service/abstract_session.dart';

const String _baseUrl = 'https://kite.sunnysab.cn/api/v2';

class KiteSession extends ASession {
  final Dio dio;
  final JwtDao jwtDao;
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
        responseType: responseType,
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
        throw KiteApiError(responseDataCode, responseData['msg']);
      }
    } catch (_) {
      // api请求格式有误
      throw KiteApiFormatError(response.data);
    }
    // api请求格式有误
    throw KiteApiFormatError(response.data);
  }

  /// 用户登录
  Future<void> login(String username, String password) async {
    final response = await post('/session', data: {
      'account': username,
      'secret': password,
    });
    jwtDao.jwtToken = response.data['token'];
  }

  /// 用户不存在时，创建用户
  Future<void> createUser(String username, String password) async {
    final response = await post('/user', data: {
      'account': username,
      'secret': password,
    });
    jwtDao.jwtToken = response.data['token'];
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

class KiteApiFormatError implements Exception {
  final dynamic responseData;
  const KiteApiFormatError(this.responseData);

  @override
  String toString() {
    return 'KiteApiFormatError{responseData: $responseData}';
  }
}
