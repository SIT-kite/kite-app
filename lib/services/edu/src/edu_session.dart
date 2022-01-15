import 'package:dio/dio.dart';
import 'package:kite/services/abstract_session.dart';

class EduSession extends ASession {
  final ASession _session;
  EduSession(this._session);

  Future<void> _getCookie(Response response) async {
    await _session.get('http://jwxt.sit.edu.cn/sso/jziotlogin');
  }

  bool _isEduLoginPage(Response response) {
    return response.data.runtimeType == String &&
        (response.data as String).contains('用户登录');
  }

  @override
  Future<Response> request(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    data,
    ResponseType? responseType,
  }) async {
    Future<Response> fetch() async {
      return await _session.request(
        url,
        method,
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
}
