import 'package:dio/dio.dart';
import 'package:kite/services/sso/sso.dart';

class EduSession implements ISession {
  final ISession _session;
  const EduSession(this._session);

  @override
  Future<Response> get(
    String url, {
    Map<String, String>? queryParameters,
    ResponseType? responseType,
  }) async {
    Future<Response> fetch() async {
      return await _session.get(
        url,
        queryParameters: queryParameters,
        responseType: responseType,
      );
    }

    var response = await fetch();
    // 如果返回值是登陆页面，那就从sso跳转过来
    if (!_isEduLoginPage(response)) {
      return response;
    }
    await _getCookie(response);
    // 再一次发请求
    return await fetch();
  }

  @override
  Future<Response> post(
    String url, {
    Map<String, String>? queryParameters,
    data,
    ResponseType? responseType,
  }) async {
    Future<Response> fetch() async {
      return await _session.post(
        url,
        queryParameters: queryParameters,
        data: data,
        responseType: responseType,
      );
    }

    var response = await fetch();
    // 如果返回值是登陆页面，那就从sso跳转过来
    if (!_isEduLoginPage(response)) {
      return response;
    }
    await _getCookie(response);
    // 再一次发请求
    return await fetch();
  }

  Future<void> _getCookie(Response response) async {
    await _session.get('http://jwxt.sit.edu.cn/sso/jziotlogin');
  }

  bool _isEduLoginPage(Response response) {
    return response.data.runtimeType == String &&
        (response.data as String).contains('用户登录');
  }
}
