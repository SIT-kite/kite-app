import 'package:dio/dio.dart';

class Network {
  static const _indexUrl = 'http://172.16.8.70';
  static const _drcomUrl = _indexUrl + '/drcom';
  static const _loginUrl = _drcomUrl + '/login';
  static const _checkStatusUrl = _drcomUrl + '/chkstatus';
  static const _logoutUrl = _drcomUrl + '/logout';

  static Future<Response> _get(String url,
      {Map<String, dynamic>? queryParameters}) async {
    return await Dio().get(url, queryParameters: queryParameters);
  }

  static Future<Response> login(String username, String password) async {
    return await _get(
      _loginUrl,
      queryParameters: {
        'callback': 'dr1003',
        'DDDDD': username,
        'upass': password,
        '0MKKey': '123456',
        "R1'": '0',
        'R2': '',
        'R3': '0',
        'R6': '0',
        'para': '00',
        'terminal_type': '1',
        'lang': 'zh-cn',
        'jsVersion': '4.1',
      },
    );
  }

  static Future<Response> checkStatus() async {
    return await _get(
      _checkStatusUrl,
      queryParameters: {
        'callback': 'dr1002',
        'jsVersion': '4.X',
        'lang': 'zh',
      },
    );
  }

  static Future<Response> logout() async {
    return await _get(
      _logoutUrl,
      queryParameters: {
        'callback': 'dr1002',
        'jsVersion': '4.1.3',
        'lang': 'zh',
      },
    );
  }
}
