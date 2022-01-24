import 'package:dio/dio.dart';
import 'package:kite/service/abstract_session.dart';
import 'package:kite/util/logger.dart';

class EduSession extends ASession {
  final ASession _session;

  EduSession(this._session) {
    Log.info('初始化 EduSession');
  }

  Future<void> _refreshCookie() async {
    await _session.get('http://jwxt.sit.edu.cn/sso/jziotlogin');
  }

  bool _isRedirectedToLoginPage(Response response) {
    return response.realUri.path == '/jwglxt/xtgl/login_slogin.html';
  }

  @override
  Future<Response> request(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    data,
    String? contentType,
    ResponseType? responseType,
    Options? options,
  }) async {
    Future<Response> fetch() async {
      return await _session.request(
        url,
        method,
        queryParameters: queryParameters,
        data: data,
        contentType: contentType,
        responseType: responseType,
      );
    }

    Response response = await fetch();
    // 如果返回值是登录页面，那就从 SSO 跳转一次以登录.
    if (_isRedirectedToLoginPage(response)) {
      await _refreshCookie();
      response = await fetch();
    }
    return response;
  }
}
