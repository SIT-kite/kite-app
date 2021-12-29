/*
 *     Copyright (C) 2021  DanXi-Dev
 *
 *     This program is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:kite/services/ocr.dart';
import './nonpersistentCookieJar.dart';
import './utils.dart';
import './constants.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_log/dio_log.dart';
import 'package:dio/adapter.dart';

import 'encrypt_util.dart';

class Auth {
  // http客户端对象
  final Dio dio;
  // 要登录的服务链接
  final String serviceUrl;
  // cookie缓存
  final NonpersistentCookieJar jar;
  // 用户名
  final String username;
  // 密码
  final String password;

  Auth(this.dio, this.serviceUrl, this.jar, this.username, this.password) {
    // 添加拦截器
    dio.interceptors.add(CookieManager(jar));
    dio.interceptors.add(DioLogInterceptor());
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    dio.options.headers = {
      'accept':
          'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
      'accept-language': 'ja,en-US;q=0.9,en;q=0.8,zh-CN;q=0.7,zh;q=0.6',
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36',
      'content-type': 'application/x-www-form-urlencoded',
    };
    // dio.options.followRedirects = true;
  }

  /// 提取认证页面中的加密盐
  String getSaltFromAuthHtml(String htmlText) {
    var a = RegExp(r'var pwdDefaultEncryptSalt = "(.*?)";');
    var matchResult = a.firstMatch(htmlText)!.group(0)!;
    var salt = matchResult.substring(29, matchResult.length - 2);
    return salt;
  }

  login() async {
    // 首先获取AuthServer首页
    var html = await getAuthServerHtml();
    // 获取首页验证码
    var a = await getCaptcha();
    // 识别验证码
    var r = await OcrServer.recognize(a);
    // 获取casTicket
    var casTicket = getCasTicketFromAuthHtml(html);
    // 获取salt
    var salt = getSaltFromAuthHtml(html);
    // 加密密码
    var hashedPwd = hashPassword(salt, password);
    // 登录系统，获得cookie
    await _login(username, hashedPwd, r, casTicket);
  }

  /// 登录
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
    var res = await dio.post(Constant.LOGIN_URL,
        data: requestBody,
        queryParameters: {
          'service': serviceUrl,
        },
        options: DioUtils.NON_REDIRECT_OPTION_WITH_FORM_TYPE);
    // 处理重定向
    return await DioUtils.processRedirect(dio, res);
  }

  /// 提取认证页面中的Cas Ticket
  String getCasTicketFromAuthHtml(String htmlText) {
    var a = RegExp(r'<input type="hidden" name="lt" value="(.*?)"');
    var matchResult = a.firstMatch(htmlText)!.group(0)!;
    var casTicket = matchResult.substring(38, matchResult.length - 1);
    return casTicket;
  }

  /// 获取认证页面内容
  Future<String> getAuthServerHtml() async {
    var response = await dio.get(Constant.LOGIN_URL);
    return response.data;
  }

  /// 判断是否需要验证码
  Future<bool> needCaptcha() async {
    var response = await dio.get(
      Constant.NEED_CAPTCHA_URL,
      queryParameters: {
        'username': username,
        'pwdEncrypt2': 'pwdEncryptSalt',
      },
    );
    return response.data == 'true';
  }

  /// 获取验证码
  Future<String> getCaptcha() async {
    var response = await dio.get(
      Constant.CAPTCHA_URL,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    Uint8List captchaData = response.data;
    return base64Encode(captchaData);
  }
}
