/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart' hide Lock;
import 'package:kite/exception/session.dart';
import 'package:kite/module/flea_market/service/ocr.dart';
import 'package:kite/network/session.dart';
import 'package:kite/session/dio_common.dart';
import 'package:kite/storage/init.dart';
import 'package:kite/util/logger.dart';
import 'package:synchronized/synchronized.dart';

import '../../util/dio_utils.dart';
import 'encryption.dart';

typedef SsoSessionErrorCallback = void Function(Object e, StackTrace t);

class SsoSession with DioDownloaderMixin implements ISession {
  static const int _maxRetryCount = 5;
  static const String _authServerUrl = 'https://authserver.sit.edu.cn/authserver';
  static const String _loginUrl = '$_authServerUrl/login';
  static const String _needCaptchaUrl = '$_authServerUrl/needCaptcha.html';
  static const String _captchaUrl = '$_authServerUrl/captcha.html';
  static const String _loginSuccessUrl = 'https://authserver.sit.edu.cn/authserver/index.do';

  // http客户端对象和缓存
  @override
  final Dio dio;

  CookieJar cookieJar;

  /// 登录状态
  bool isOnline = false;

  // 如果登录成功，那么 username 与 password 将不为 null
  String? _username;
  String? _password;

  /// Session错误拦截器
  SsoSessionErrorCallback? onError;

  bool enableSsoErrorCallback = true;

  /// 惰性登录锁
  final loginLock = Lock();

  SsoSession({
    required this.dio,
    required this.cookieJar,
    this.onError,
  });

  Future<void> runWithNoErrorCallback(Future<void> Function() callback) async {
    enableSsoErrorCallback = false;
    try {
      await callback();
    } finally {
      enableSsoErrorCallback = true;
    }
  }

  Future<bool> checkConnectivity({
    String url = 'http://jwxt.sit.edu.cn/',
  }) async {
    try {
      await runWithNoErrorCallback(() async {
        await _dioRequest(
          url,
          'GET',
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            followRedirects: false,
            validateStatus: (status) => status! < 400,
          ),
        );
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  /// 判断该请求是否为登录页
  bool isLoginPage(Response response) {
    return response.realUri.toString().contains(_loginUrl);
  }

  /// 进行登录操作
  Future<void> makeSureLogin(String url) async {
    isOnline = false;
    await loginLock.synchronized(() async {
      if (isOnline) return;
      // 只有用户名与密码均不为空时，才尝试重新登录，否则就抛异常
      if (username != null && password != null) {
        await _login(_username!, _password!);
      } else {
        throw NeedLoginException(url: url);
      }
    });
  }

  Future<Response> login(String username, String password) async {
    return await loginLock.synchronized(() async {
      return await _login(username, password);
    });
  }

  Future<Response> _dioRequest(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _request(
        url,
        method,
        queryParameters: queryParameters,
        data: data,
        options: options,
      );
    } catch (e, t) {
      if (onError != null && enableSsoErrorCallback) {
        onError!(e, t);
      }
      rethrow;
    }
  }

  Future<Response> _request(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    options ??= Options();

    /// 正常地请求
    Future<Response> requestNormally() async {
      final response = await dio.request(
        url,
        queryParameters: queryParameters,
        options: options!.copyWith(
          headers: options.headers,
          method: method,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 400;
          },
        ),
        data: data,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      // 处理重定向
      return await DioUtils.processRedirect(dio, response, headers: neededHeaders);
    }

    // 第一次先正常请求
    final firstResponse = await requestNormally();

    // 如果跳转登录页，那就先登录
    if (isLoginPage(firstResponse)) {
      await makeSureLogin(url);
      return await requestNormally();
    } else {
      return firstResponse;
    }
  }

  String? get username => _username;

  String? get password => _password;

  /// 惰性登录，只有在第一次请求跳转到登录页时才开始尝试真正的登录
  void lazyLogin(String username, String password) {
    _username = username;
    _password = password;
  }

  /// 带异常的登录, 但不处理验证码识别错误问题.
  Future<Response> loginWithoutRetry(String username, String password) async {
    Log.info('尝试登录：$username');
    Log.debug('当前登录UA: ${dio.options.headers['User-Agent']}');
    // 在 OA 登录时, 服务端会记录同一 cookie 用户登录次数和输入错误次数,
    // 所以需要在登录前清除所有 cookie, 避免用户重试时出错.
    cookieJar.deleteAll();
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
      Log.error('未知验证错误,此时url为: ${response.realUri}');
      throw const UnknownAuthException();
    }
    Log.info('登录成功：$username');
    isOnline = true;
    _username = username;
    _password = password;
    Kv.loginTime.sso = DateTime.now();
    return response;
  }

  Future<Response> _login(String username, String password) async {
    int count = 0;
    while (count < _maxRetryCount) {
      try {
        return await loginWithoutRetry(username, password);
      } catch (e) {
        // 只要是异常，就再重试
        count++;
        if (count == _maxRetryCount) {
          rethrow;
        }
      }
    }
    throw const MaxRetryExceedException(msg: '登录超过最大重试次数 ($_maxRetryCount 次)');
  }

  /// 登录流程
  Future<Response> _postLoginProcess(String username, String password) async {
    debug(m) => Log.debug(m);

    /// 提取认证页面中的加密盐
    String getSaltFromAuthHtml(String htmlText) {
      final a = RegExp(r'var pwdDefaultEncryptSalt = "(.*?)";');
      final matchResult = a.firstMatch(htmlText)!.group(0)!;
      final salt = matchResult.substring(29, matchResult.length - 2);
      debug('当前页面加密盐: $salt');
      return salt;
    }

    /// 提取认证页面中的Cas Ticket
    String getCasTicketFromAuthHtml(String htmlText) {
      final a = RegExp(r'<input type="hidden" name="lt" value="(.*?)"');
      final matchResult = a.firstMatch(htmlText)!.group(0)!;
      final casTicket = matchResult.substring(38, matchResult.length - 1);
      debug('当前页面CAS Ticket: $casTicket');
      return casTicket;
    }

    /// 获取认证页面内容
    Future<String> getAuthServerHtml() async {
      final response = await dio.get(
        _loginUrl,
        options: Options(headers: Map.from(neededHeaders)..remove('Referer')),
      );
      return response.data;
    }

    /// 判断是否需要验证码
    Future<bool> needCaptcha(String username) async {
      final response = await dio.get(
        _needCaptchaUrl,
        queryParameters: {
          'username': username,
          'pwdEncrypt2': 'pwdEncryptSalt',
        },
        options: Options(headers: neededHeaders),
      );
      final needCaptcha = response.data == 'true';
      debug('当前账户: $username, 是否需要验证码: $needCaptcha');
      return needCaptcha;
    }

    /// 获取验证码
    Future<String> getCaptcha() async {
      final response = await dio.get(
        _captchaUrl,
        options: Options(
          responseType: ResponseType.bytes,
          headers: neededHeaders,
        ),
      );
      Uint8List captchaData = response.data;
      final b64 = base64Encode(captchaData);
      return b64;
    }

    // 首先获取AuthServer首页
    final html = await getAuthServerHtml();

    await cookieJar.saveFromResponse(
      Uri.parse('https://authserver.sit.edu.cn'),
      [Cookie('org.springframework.web.servlet.i18n.CookieLocaleResolver.LOCALE', 'en')],
    );

    // 获取首页验证码
    var captcha = '';
    if (await needCaptcha(username)) {
      // 识别验证码
      // 一定要让识别到的字符串长度为4
      // 如果不是4，那就再试一次
      do {
        final captchaImage = await getCaptcha();
        captcha = await OcrServer.recognize(captchaImage);
        debug('识别验证码结果: $captcha');
      } while (captcha.length != 4);
    }
    // 获取casTicket
    final casTicket = getCasTicketFromAuthHtml(html);
    // 获取salt
    final salt = getSaltFromAuthHtml(html);
    // 加密密码
    final hashedPwd = hashPassword(salt, password);
    // 登录系统，获得cookie
    return await _postLoginRequest(username, hashedPwd, captcha, casTicket);
  }

  final neededHeaders = {
    "Accept-Encoding": "gzip, deflate, br",
    'Origin': 'https://authserver.sit.edu.cn',
    "Upgrade-Insecure-Requests": "1",
    "Sec-Fetch-Dest": "document",
    "Sec-Fetch-Mode": "navigate",
    "Sec-Fetch-Site": "same-origin",
    "Sec-Fetch-User": "?1",
    "Referer": "https://authserver.sit.edu.cn/authserver/login",
  };

  /// 登录统一认证平台
  Future<Response> _postLoginRequest(String username, String hashedPassword, String captcha, String casTicket) async {
    final requestBody = {
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
    final res = await dio.post(_loginUrl,
        data: requestBody,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          followRedirects: false,
          validateStatus: (status) {
            return status! < 400;
          },
          headers: neededHeaders,
        ));
    // 处理重定向
    return await DioUtils.processRedirect(dio, res, headers: neededHeaders);
  }

  @override
  Future<SessionRes> request(
    String url,
    ReqMethod method, {
    Map<String, String>? para,
    data,
    SessionOptions? options,
    SessionProgressCallback? onSendProgress,
    SessionProgressCallback? onReceiveProgress,
  }) async {
    Response response = await _dioRequest(
      url,
      method.uppercaseName,
      queryParameters: para,
      data: data,
      options: options?.toDioOptions(),
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response.toMyResponse();
  }
}
