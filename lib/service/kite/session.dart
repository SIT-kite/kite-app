import 'dart:async';

import 'package:dio/dio.dart';
import 'package:kite/service/abstract_session.dart';

class KiteSession extends ASession {
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
    // TODO: implement request
    throw UnimplementedError();
  }
}
