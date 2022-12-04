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

import 'dart:async';

import 'package:catcher/catcher.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kite/global/cookie_init.dart';
import 'package:kite/global/dio_initializer.dart';
import 'package:kite/module/activity/using.dart';
import 'package:kite/module/user_event/dao/user_event.dart';
import 'package:kite/route.dart';
import 'package:kite/util/event_bus.dart';
import 'package:kite/util/page_logger.dart';

import '../util/upgrade.dart';

class GlobalConfig {
  static String? httpProxy;
  static bool isTestEnv = false;
}

enum EventNameConstants {
  onRouteRefresh,
  onWeatherUpdate,
  onHomeRefresh,
  onHomeItemReorder,
  onSelectCourse,
  onRemoveCourse,
  onCampusChange,
  onBackgroundChange,
  onJumpTodayTimetable,
}

/// 应用程序全局数据对象
class Global {
  static late AppVersion currentVersion;

  static final eventBus = EventBus<EventNameConstants>();
  static late PageLogger pageLogger;

  static late CookieJar cookieJar;
  static late Dio dio;
  static late Dio dio2; // 消费查询专用连接池(因为需要修改连接超时)
  static late SsoSession ssoSession;
  static late SsoSession ssoSession2;

  static BuildContext? get buildContext => Catcher.navigatorKey?.currentState?.context;

  // 是否正处于网络错误对话框
  static bool inSsoErrorDialog = false;

  static onSsoError(error, stacktrace) {
    if (Catcher.navigatorKey == null) return;
    if (Catcher.navigatorKey!.currentContext == null) return;
    final context = Catcher.navigatorKey!.currentContext!;
    if (error is DioError) {
      if (inSsoErrorDialog) return;
      inSsoErrorDialog = true;
      context
          .showRequest(
              title: i18n.networkConnectionTimeoutError,
              desc: i18n.networkConnectionTimeoutErrorDesc,
              yes: i18n.openNetworkToolBtn,
              no: i18n.cancel)
          .then((confirm) {
        if (confirm == true) Navigator.of(context).popAndPushNamed('/connectivity');
        inSsoErrorDialog = false;
      });
    }
  }

  static Future<void> init(
      {required UserEventStorageDao userEventStorage, required AuthSettingDao authSetting, bool? debugNetwork}) async {
    currentVersion = await getCurrentVersion();
    cookieJar = await CookieInit.init();
    dio = await DioInit.init(
      config: DioConfig()
        ..cookieJar = cookieJar
        ..httpProxy = GlobalConfig.httpProxy
        ..sendTimeout = 6 * 1000
        ..receiveTimeout = 6 * 1000
        ..connectTimeout = 6 * 1000,
      debug: debugNetwork,
    );
    dio2 = await DioInit.init(
      config: DioConfig()
        ..cookieJar = cookieJar
        ..httpProxy = GlobalConfig.httpProxy
        ..connectTimeout = 30 * 1000
        ..sendTimeout = 30 * 1000
        ..receiveTimeout = 30 * 1000,
      debug: debugNetwork,
    );
    ssoSession = SsoSession(dio: dio, cookieJar: cookieJar, onError: onSsoError);
    ssoSession2 = SsoSession(dio: dio2, cookieJar: cookieJar, onError: onSsoError);
    pageLogger = PageLogger(dio: dio, userEventStorage: userEventStorage);
    pageLogger.startup();

    // 若本地存放了用户名与密码，那就惰性登录
    final auth = authSetting;
    if (auth.currentUsername != null && auth.ssoPassword != null) {
      // 惰性登录
      ssoSession.lazyLogin(auth.currentUsername!, auth.ssoPassword!);
    }

    // 全局FutureBuilder异常处理
    MyFutureBuilder.globalErrorBuilder = (context, futureBuilder, error, stacktrace) {
      // 单独处理网络连接错误，且不上报
      if (error is DioError && const [DioErrorType.connectTimeout, DioErrorType.other].contains((error).type)) {
        return Center(
          child: Column(
            children: [
              i18n.networkConnectionTimeoutError.txt,
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed(RouteTable.connectivity),
                child: i18n.openNetworkToolBtn.txt,
              ),
              if (futureBuilder.futureGetter != null)
                TextButton(
                  onPressed: () => futureBuilder.controller?.refresh(),
                  child: i18n.refresh.txt,
                ),
            ],
          ),
        );
      }

      Catcher.reportCheckedError(error, stacktrace);

      // 其他错误暂时不处理
      return null;
    };
  }
}
