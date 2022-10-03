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
import 'package:kite/global/cookie_initializer.dart';
import 'package:kite/global/dio_initializer.dart';
import 'package:kite/module/user_event/dao.dart';
import 'package:kite/route.dart';
import 'package:kite/session/sso/index.dart';
import 'package:kite/storage/dao/index.dart';
import 'package:kite/user_widget/future_builder.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:kite/util/event_bus.dart';
import 'package:kite/util/page_logger.dart';

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
      showAlertDialog(
        context,
        title: '网络连接超时',
        content: [
          const Text('连接超时，该功能需要您连接校园网环境；\n\n'
              '注意：学校服务器崩溃或停机维护也会产生这个问题。'),
        ],
        actionTextList: ['进入网络工具检查', '取消'],
      ).then((select) {
        if (select == 0) Navigator.of(context).popAndPushNamed('/connectivity');
        inSsoErrorDialog = false;
      });
    }
  }

  static Future<void> init({
    required UserEventStorageDao userEventStorage,
    required AuthSettingDao authSetting,
  }) async {
    cookieJar = await CookieInit.init();
    dio = await DioInit.init(
      config: DioConfig()
        ..cookieJar = cookieJar
        ..httpProxy = GlobalConfig.httpProxy
        ..sendTimeout = 6 * 1000
        ..receiveTimeout = 6 * 1000
        ..connectTimeout = 6 * 1000,
    );
    dio2 = await DioInit.init(
      config: DioConfig()
        ..cookieJar = cookieJar
        ..httpProxy = GlobalConfig.httpProxy
        ..connectTimeout = 30 * 1000
        ..sendTimeout = 30 * 1000
        ..receiveTimeout = 30 * 1000,
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
      if (error is DioError && [DioErrorType.connectTimeout, DioErrorType.other].contains((error).type)) {
        return Center(
          child: Column(
            children: [
              const Text('网络连接超时，请检查是否连接到校园网环境(也有可能学校临时维护服务器，请以网页登录结果为准)'),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushReplacementNamed(RouteTable.connectivity),
                child: const Text('进入网络工具检查'),
              ),
              if (futureBuilder.futureGetter != null && futureBuilder.controller != null)
                TextButton(
                  onPressed: () => futureBuilder.controller?.refresh(),
                  child: const Text('刷新页面'),
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
