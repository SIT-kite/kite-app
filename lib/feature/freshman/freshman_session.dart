import 'package:dio/dio.dart';
import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/setting/dao/auth.dart';
import 'package:kite/util/logger.dart';

class FreshmanSession extends ASession {
  final ASession _session;
  final AuthSettingDao _authSettingDao;

  FreshmanSession(this._session, this._authSettingDao) {
    Log.info('初始化 FreshmanSession');
  }
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
    Future<Response> myRequest(
      dynamic data1,
      String url1,
      Map<String, String>? queryParameters1,
    ) async {
      return await _session.request(
        url1,
        method,
        queryParameters: queryParameters1,
        data: data1,
        options: options,
        contentType: contentType,
        responseType: responseType,
      );
    }

    // 如果不存在新生信息，那就不管了
    if (_authSettingDao.freshmanAccount == null || _authSettingDao.freshmanSecret == null) {
      return await myRequest(data, url, queryParameters);
    }

    // 新生信息
    String account = _authSettingDao.freshmanAccount!;
    String secret = _authSettingDao.freshmanSecret!;

    final String myUrl = '/freshman/$account$url';

    // 如果是GET请求，登录态直接注入到 queryParameters 中
    if (method == 'GET') {
      final myQuery = queryParameters ?? {};
      myQuery['secret'] = secret;
      return await myRequest(data, myUrl, myQuery);
    }

    // 其他请求的话，如果data是Map那么注入登录态
    if (data is Map<String, dynamic>) {
      final Map<String, dynamic> myData = data;
      myData['account'] = account;
      myData['secret'] = secret;

      // 修改url
      return await myRequest(myData, myUrl, queryParameters);
    }

    // 其他情况不动data,但是url还是得边
    return await myRequest(data, myUrl, queryParameters);
  }
}
