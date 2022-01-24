import 'dart:async';

import 'package:dio/dio.dart';
import 'package:kite/dao/kite/jwt.dart';
import 'package:kite/service/abstract_session.dart';

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
    final response = await dio.request(
      url,
      data: data,
      queryParameters: queryParameters,
      options: (options ?? Options()).copyWith(
        method: method,
        contentType: contentType,
        responseType: responseType,
      ),
    );
    return response;
  }

  Future<bool> login(String username, String password) async {
    return true;
  }

  Future<bool> createUser(String username, String password) async {
    return true;
  }
}
