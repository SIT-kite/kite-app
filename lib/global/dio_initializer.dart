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
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:kite/setting/init.dart';
import 'package:kite/util/logger.dart';
import 'package:kite/util/rule.dart';

const String _defaultUaString = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:46.0) Gecko/20100101 Firefox/46.0';

class DioConfig {
  String? httpProxy;
  bool allowBadCertificate = true;
  CookieJar cookieJar = DefaultCookieJar();
}

/// 用于初始化Dio,全局只有一份dio对象
class DioInitializer {
  /// 初始化SessionPool
  static Future<Dio> init({required DioConfig config}) async {
    Log.info("初始化Dio");
    // dio初始化完成后，才能初始化 UA
    final dio = _initDioInstance(config: config);
    await _initUserAgentString(dio: dio);

    return dio;
  }

  static Dio _initDioInstance({required DioConfig config}) {
    // 设置 HTTP 代理
    HttpOverrides.global = KiteHttpOverrides(config: config);

    Dio dio = Dio();
    // 添加拦截器
    dio.interceptors.add(CookieManager(config.cookieJar));

    // 设置默认超时时间
    dio.options.connectTimeout = 3 * 1000;
    dio.options.sendTimeout = 3 * 1000;
    dio.options.receiveTimeout = 3 * 1000;
    return dio;
  }

  static Future<void> _initUserAgentString({
    required Dio dio,
  }) async {
    try {
      // 如果非IOS/Android，则该函数将抛异常
      await FkUserAgent.init();
      // 更新 dio 设置的 user-agent 字符串
      dio.options.headers['User-Agent'] = FkUserAgent.webViewUserAgent ?? _defaultUaString;
    } catch (e) {
      // Desktop端将进入该异常
      // TODO: 自定义UA
      dio.options.headers['User-Agent'] = _defaultUaString;
    }
  }
}

class KiteHttpOverrides extends HttpOverrides {
  final DioConfig config;
  KiteHttpOverrides({required this.config});

  String getProxyPolicyByUrl(Uri url, String httpProxy) {
    // 使用代理访问的网站规则
    final rule = const ChainRule(ConstRule())
        .sum(const EqualRule('jwxt.sit.edu.cn'))
        .sum(const EqualRule('sc.sit.edu.cn'))
        .sum(const EqualRule('card.sit.edu.cn'))
        .sum(const EqualRule('myportal.sit.edu.cn'))
        .sum(const EqualRule('210.35.66.106')) // 图书馆
        .sum(const EqualRule('210.35.98.178')); // 门禁

    final host = url.host;
    if (rule.accept(host)) {
      Log.info('使用代理访问 $url');
      return 'PROXY $httpProxy';
    } else {
      Log.info('直连访问 $url');
      return 'DIRECT';
    }
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);

    // 设置证书检查
    if (config.allowBadCertificate || SettingInitializer.network.useProxy || config.httpProxy != null) {
      client.badCertificateCallback = (cert, host, port) => true;
    }

    // 设置代理. 优先使用代码中的设置, 便于调试.
    if (config.httpProxy != null) {
      // 判断测试环境代理合法性
      // TODO: 检查代理格式
      if (config.httpProxy!.isNotEmpty) {
        // 可以
        Log.info('测试环境设置代理: ${config.httpProxy}');
        client.findProxy = (url) => getProxyPolicyByUrl(url, config.httpProxy!);
      } else {
        // 不行
        Log.info('测试环境代理服务器为空或不合法，将不使用代理服务器');
      }
    } else if (SettingInitializer.network.useProxy && SettingInitializer.network.proxy.isNotEmpty) {
      Log.info('线上设置代理: ${config.httpProxy}');
      client.findProxy = (url) => getProxyPolicyByUrl(url, SettingInitializer.network.proxy);
    }
    return client;
  }
}
