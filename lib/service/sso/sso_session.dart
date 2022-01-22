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
  static const String _loginSuccessUrl = 'https://authserver.sit.edu.cn/authserver/index.do';

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

    // 使用全局 cookieJar
    _jar = jar ?? SessionPool.cookieJar;
    if (jar != null) {
      _dio.interceptors.add(CookieManager(jar));
    }
  }

  /// 判断该请求是否为登录页
  bool _isLoginPage(Response response) {
    return response.realUri.toString().contains(_loginUrl);
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
    /// 正常地请求
    Future<Response> requestNormally() async {
      final response = await _dio.request(
        url,
        queryParameters: queryParameters,
        options: DioUtils.NON_REDIRECT_OPTION_WITH_FORM_TYPE.copyWith(
          method: method,
          contentType: contentType,
          responseType: responseType,
        ),
        data: data,
      );
      // 处理重定向
      return await DioUtils.processRedirect(_dio, response);
    }

    // 第一次先正常请求
    final firstResponse = await requestNormally();

    // 如果跳转登录页，那就先登录
    if (_isLoginPage(firstResponse)) {
      isOnline = false;
      // 只有用户名与密码均不为空时，才尝试重新登录，否则就抛异常
      if (username != null && password != null) {
        await login(_username!, _password!);
        return await requestNormally();
      } else {
        throw NeedLoginException(url: url);
      }
    } else {
      return firstResponse;
    }
  }

  String? get username => _username;
  String? get password => _password;

  /// 带异常的登录
  Future<Response> login(String username, String password) async {
    // 在 OA 登录时, 服务端会记录同一 cookie 用户登录次数和输入错误次数,
    // 所以需要在登录前清除所有 cookie, 避免用户重试时出错.
    _jar.deleteAll();
    final response = await _postLoginProcess(username, password);
    final page = BeautifulSoup(response.data);

    final emptyPage = BeautifulSoup('');
    // 桌面端报错提示
    final authError = (page.find('span', id: 'msg', class_: 'auth_error') ?? emptyPage).text.trim();
    // TODO: 支持移动端报错提示
    final mobileError = (page.find('span', id: 'errorMsg') ?? emptyPage).text.trim();
    if (authError.isNotEmpty || mobileError.isNotEmpty) {
      throw CredentialsInvalidException(msg: authError + mobileError);
    }

    if (response.realUri.toString() != _loginSuccessUrl) {
      throw const UnknownAuthException();
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
      var response =
          await _dio.get(_needCaptchaUrl, queryParameters: {'username': username, 'pwdEncrypt2': 'pwdEncryptSalt'});
      return response.data == 'true';
    }

    /// 获取验证码
    Future<String> _getCaptcha() async {
      var response = await _dio.get(
        _captchaUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      Uint8List captchaData = response.data;
      return base64Encode(captchaData);
    }

    // 首先获取AuthServer首页
    final html = await _getAuthServerHtml();

    // 获取首页验证码
    var captcha = '';
    if (await _needCaptcha(username)) {
      // 识别验证码
      // 一定要让识别到的字符串长度为4
      // 如果不是4，那就再试一次
      do {
        final captchaImage = await _getCaptcha();
        captcha = await OcrServer.recognize(captchaImage);
      } while (captcha.length != 4);
    }
    // 获取casTicket
    final casTicket = _getCasTicketFromAuthHtml(html);
    // 获取salt
    final salt = _getSaltFromAuthHtml(html);
    // 加密密码
    final hashedPwd = hashPassword(salt, password);
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

/// 认证失败
class CredentialsInvalidException implements Exception {
  final String msg;

  const CredentialsInvalidException({this.msg = ''});

  @override
  String toString() {
    return msg;
  }
}

/// 操作之前需要先登录
class NeedLoginException implements Exception {
  final String msg;
  final String url;
  const NeedLoginException({this.msg = '目标操作需要登录', this.url = ''});

  @override
  String toString() {
    return msg;
  }
}

/// 未知的验证错误
class UnknownAuthException implements Exception {
  final String msg;

  const UnknownAuthException({this.msg = '未知验证错误'});

  @override
  String toString() {
    return msg;
  }
}
