import 'package:dio/dio.dart';
import 'package:kite/services/sso/sso.dart';

class EduSession implements ISession {
  final Session _session;
  const EduSession(this._session);

  @override
  Future<Response> get(
    String url, {
    Map<String, String>? queryParameters,
    ResponseType? responseType,
  }) async {
    // TODO: 应当在此处判断教务是否需要cookie
    return await _session.get(
      url,
      queryParameters: queryParameters,
      responseType: responseType,
    );
  }

  @override
  Future<Response> post(
    String url, {
    Map<String, String>? queryParameters,
    data,
    ResponseType? responseType,
  }) async {
    // TODO: 应当在此处判断教务是否需要cookie
    return await _session.post(
      url,
      queryParameters: queryParameters,
      data: data,
      responseType: responseType,
    );
  }
}
