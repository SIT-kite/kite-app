import 'dart:convert';

import 'package:dio/dio.dart';

import '../../session_pool.dart';

const String serviceLogin = 'https://xgfy.sit.edu.cn/unifri-flow/login';

class OfficeSession {
  final String jwtToken;
  String username;
  Dio dio;

  OfficeSession(this.username, this.jwtToken, this.dio);
}

Future<OfficeSession?> login(String username, String password) async {
  final dio = SessionPool.ssoSession.dio;
  final Map<String, String> credential = {'account': username, 'userPassword': password, 'remember': 'true'};

  print(credential);
  final response = await dio.post(serviceLogin,
      data: jsonEncode(credential), options: Options(headers: {'Content-Type': 'application/json'}));
  final int code = (response.data as Map)['code'];

  if (code != 0) {
    final String errMessage = (response.data as Map)['msg'];
    throw OfficeLoginException(errMessage);
  }
  final String jwt = ((response.data as Map)['data'])['authorization'];
  return OfficeSession(username, jwt, dio);
}

class OfficeLoginException implements Exception {
  String msg;
  OfficeLoginException([this.msg = '']);

  @override
  String toString() {
    return msg;
  }
}
