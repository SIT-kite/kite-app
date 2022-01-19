import 'dart:convert';
import 'dart:typed_data';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:kite/global/session_pool.dart';
import 'package:kite/service/abstract_session.dart';
import 'package:kite/service/ocr.dart';
import 'package:kite/util/logger.dart';

import 'encryption.dart';
import 'utils.dart';

class SsoSession extends ASession {
  static const String _authServerUrl = 'https://authserver.sit.edu.cn/authserver';
  static const String _loginUrl = '$_authServerUrl/login';
  static const String _needCaptchaUrl = '$_authServerUrl/needCaptcha.html';
  static const String _captchaUrl = '$_authServerUrl/captcha.html';

  // http客户端对象和缓存
  late Dio _dio;
  late CookieJar _jar;

  /// 登录状态
  bool isOnline = false;

  // 如果登录成功，那么 username 与 password 将不为 null
  String? _username;
  String? _password;

  SsoSession({
    Dio? dio,
    CookieJar? jar,
  }) {
    Log.info('初始化 SsoSession');
    _dio = dio ?? SessionPool.dio;

    if (jar == null) {
      // 使用全局 cookieJar
      _jar = jar ?? SessionPool.cookieJar;
      _dio.interceptors.add(CookieManager(_jar));
    }
  }

  @override
  Future<Response> request(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    dynamic data,
    String? contentType,
    ResponseType? responseType,
    Options? options,
  }) async {
    var res = await _dio.request(
      url,
      queryParameters: queryParameters,
      options: DioUtils.NON_REDIRECT_OPTION_WITH_FORM_TYPE.copyWith(
        method: method,
        contentType: contentType,
        responseType: responseType,
      ),
      data: data,
    );
    // // 处理重定向
    return await DioUtils.processRedirect(_dio, res);
  }

  String? get username => _username;
  String? get password => _password;

  /// 带异常的登录
  Future<Response> login(String username, String password) async {
    final response = await _postLoginProcess(username, password);
    final page = BeautifulSoup(response.data);

    // 桌面端报错
    final authError = page.find('span', class_: 'auth_error');
    // 手机版报错
    final mobileError = page.find('span', id: 'msgError');
    if (authError != null) {
      throw CredentialsInvalidException(authError.text.trim());
    }
    if (mobileError != null) {
      throw CredentialsInvalidException(mobileError.text.trim());
    }

    isOnline = true;
    _username = username;
    _password = password;
    return response;
  }

  Dio get dio => _dio;

  CookieJar get cookie => _jar;

  /// 登录流程
  Future<Response> _postLoginProcess(String username, String password) async {
    /// 提取认证页面中的加密盐
    String _getSaltFromAuthHtml(String htmlText) {
      var a = RegExp(r'var pwdDefaultEncryptSalt = "(.*?)";');
      var matchResult = a.firstMatch(htmlText)!.group(0)!;
      var salt = matchResult.substring(29, matchResult.length - 2);
      return salt;
    }

    /// 提取认证页面中的Cas Ticket
    String _getCasTicketFromAuthHtml(String htmlText) {
      var a = RegExp(r'<input type="hidden" name="lt" value="(.*?)"');
      var matchResult = a.firstMatch(htmlText)!.group(0)!;
      var casTicket = matchResult.substring(38, matchResult.length - 1);
      return casTicket;
    }

    /// 获取认证页面内容
    Future<String> _getAuthServerHtml() async {
      var response = await _dio.get(_loginUrl);
      return response.data;
    }

    /// 判断是否需要验证码
    Future<bool> _needCaptcha(String username) async {
      var response = await _dio.get(
        _needCaptchaUrl,
        queryParameters: {
          'username': username,
          'pwdEncrypt2': 'pwdEncryptSalt',
        },
      );
      return response.data == 'true';
    }

    /// 获取验证码
    Future<String> _getCaptcha() async {
      var response = await _dio.get(
        _captchaUrl,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );
      Uint8List captchaData = response.data;
      return base64Encode(captchaData);
    }

    // 首先获取AuthServer首页
    var html = await _getAuthServerHtml();
    // 获取首页验证码

    var captcha = '';
    if (await _needCaptcha(username)) {
      // 识别验证码
      // 一定要让识别到的字符串长度为4
      // 如果不是4，那就再试一次
      do {
        var captchaImage = await _getCaptcha();
        captcha = await OcrServer.recognize(captchaImage);
      } while (captcha.length != 4);
    }
    // 获取casTicket
    var casTicket = _getCasTicketFromAuthHtml(html);
    // 获取salt
    var salt = _getSaltFromAuthHtml(html);
    // 加密密码
    var hashedPwd = hashPassword(salt, password);
    // 登录系统，获得cookie
    return await _postLoginRequest(username, hashedPwd, captcha, casTicket);
  }

  /// 登录统一认证平台
  Future<Response> _postLoginRequest(String username, String hashedPassword, String captcha, String casTicket) async {
    var requestBody = {
      'username': username,
      'password': hashedPassword,
      'captchaResponse': captcha,
      'lt': casTicket,
      'dllt': 'userNamePasswordLogin',
      'execution': 'e1s1',
      '_eventId': 'submit',
      'rmShown': '1',
    };
    // 登录系统
    var res = await _dio.post(_loginUrl, data: requestBody, options: DioUtils.NON_REDIRECT_OPTION_WITH_FORM_TYPE);
    // 处理重定向
    return await DioUtils.processRedirect(_dio, res);
  }
}

class CredentialsInvalidException implements Exception {
  String msg;
  CredentialsInvalidException([this.msg = '']);

  @override
  String toString() {
    return msg;
  }
}
