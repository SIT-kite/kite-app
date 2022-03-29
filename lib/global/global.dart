import 'package:catcher/catcher.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kite/global/cookie_initializer.dart';
import 'package:kite/global/dio_initializer.dart';
import 'package:kite/session/sso/index.dart';
import 'package:kite/setting/dao/auth.dart';
import 'package:kite/util/alert_dialog.dart';
import 'package:kite/util/event_bus.dart';
import 'package:kite/util/page_logger.dart';

import '../feature/user_event/dao.dart';

class GlobalConfig {
  static String? httpProxy;
  static bool isTestEnv = false;
}

enum EventNameConstants {
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

  static onSsoError(error, stacktrace) {
    if (Catcher.navigatorKey == null) return;
    if (Catcher.navigatorKey!.currentContext == null) return;
    final context = Catcher.navigatorKey!.currentContext!;
    if (error is DioError && error.type == DioErrorType.connectTimeout) {
      Future.delayed(Duration.zero, () async {
        final select = await showAlertDialog(
          context,
          title: '网络连接超时',
          content: [
            const Text('连接超时，该功能需要您连接校园网环境；\n\n注意：学校服务器崩溃或停机维护也会产生这个问题。'),
          ],
          actionTextList: ['进入网络工具检查', '取消'],
        );
        if (select == 0) {
          Navigator.of(context).popAndPushNamed('/connectivity');
        }
      });
    }
  }

  static Future<void> init({
    required UserEventStorageDao userEventStorage,
    required AuthSettingDao authSetting,
  }) async {
    cookieJar = await CookieInitializer.init();
    dio = await DioInitializer.init(
      config: DioConfig()
        ..cookieJar = cookieJar
        ..httpProxy = GlobalConfig.httpProxy
        ..sendTimeout = 6 * 1000
        ..receiveTimeout = 6 * 1000,
    );
    dio2 = await DioInitializer.init(
      config: DioConfig()
        ..cookieJar = cookieJar
        ..httpProxy = GlobalConfig.httpProxy
        ..connectTimeout = 30 * 1000,
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
  }
}
