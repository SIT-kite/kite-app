import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:kite/services/ocr.dart';
import './nonpersistentCookieJar.dart';
import './utils.dart';
import './constants.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_log/dio_log.dart';
import 'package:dio/adapter.dart';

import 'encrypt_util.dart';

class Session {
  // http客户端对象
  late Dio _dio;
  // cookie缓存
  late NonpersistentCookieJar _jar;
  // 用户名
  final String _username;
  // 密码
  final String _password;

  Session(
    this._username,
    this._password, {
    Dio? dio,
    NonpersistentCookieJar? jar,
  }) {
    if (dio == null) {
      _dio = Dio();
    } else {
      _dio = dio;
    }

    if (jar == null) {
      _jar = NonpersistentCookieJar();
    } else {
      _jar = jar;
    }

    // 添加拦截器
    _dio.interceptors.add(CookieManager(_jar));
    _dio.interceptors.add(DioLogInterceptor());
    // 若需要使用fiddler之类的抓包工具，则需要开启如下代码
    // _allowInsecure();
    _dio.options.headers = {
      'accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'accept-language': 'ja,en-US;q=0.9,en;q=0.8,zh-CN;q=0.7,zh;q=0.6',
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36',
      'content-type': 'application/x-www-form-urlencoded',
    };
  }

  /// 请求数据
  Future<Response> get(String url,
      {Map<String, String>? queryParameters}) async {
    var res = await _dio.get(
      url,
      queryParameters: queryParameters,
      options: DioUtils.NON_REDIRECT_OPTION_WITH_FORM_TYPE,
    );

    // // 处理重定向
    return await DioUtils.processRedirect(_dio, res);
  }

  /// 请求数据
  Future<Response> post(
    String url, {
    Map<String, String>? queryParameters,
    dynamic data,
  }) async {
    var res = await _dio.post(
      url,
      queryParameters: queryParameters,
      options: DioUtils.NON_REDIRECT_OPTION_WITH_FORM_TYPE,
      data: data,
    );

    // // 处理重定向
    return await DioUtils.processRedirect(_dio, res);
  }

  /// 登录流程
  Future<Response> login() async {
    // 首先获取AuthServer首页
    var html = await _getAuthServerHtml();
    // 获取首页验证码
    var captchaImage = await _getCaptcha();
    // 识别验证码
    var captcha = await OcrServer.recognize(captchaImage);
    // 获取casTicket
    var casTicket = _getCasTicketFromAuthHtml(html);
    // 获取salt
    var salt = _getSaltFromAuthHtml(html);
    // 加密密码
    var hashedPwd = hashPassword(salt, _password);
    // 登录系统，获得cookie
    return await _login(_username, hashedPwd, captcha, casTicket);
  }

  /// 允许不安全的https访问，这在使用fiddler等抓包工具时很有用
  void _allowInsecure() {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  /// 登录统一认证平台
  Future<Response> _login(String username, String hashedPassword,
      String captcha, String casTicket) async {
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
    var res = await _dio.post(Constant.LOGIN_URL,
        data: requestBody,
        options: DioUtils.NON_REDIRECT_OPTION_WITH_FORM_TYPE);
    // 处理重定向
    return await DioUtils.processRedirect(_dio, res);
  }

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
    var response = await _dio.get(Constant.LOGIN_URL);
    return response.data;
  }

  /// 判断是否需要验证码
  Future<bool> _needCaptcha() async {
    var response = await _dio.get(
      Constant.NEED_CAPTCHA_URL,
      queryParameters: {
        'username': _username,
        'pwdEncrypt2': 'pwdEncryptSalt',
      },
    );
    return response.data == 'true';
  }

  /// 获取验证码
  Future<String> _getCaptcha() async {
    var response = await _dio.get(
      Constant.CAPTCHA_URL,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    Uint8List captchaData = response.data;
    return base64Encode(captchaData);
  }
}
