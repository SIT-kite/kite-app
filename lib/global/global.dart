import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:kite/global/cookie_initializer.dart';
import 'package:kite/global/dio_initializer.dart';
import 'package:kite/session/sso/index.dart';
import 'package:kite/setting/dao/auth.dart';
import 'package:kite/util/event_bus.dart';
import 'package:kite/util/page_logger.dart';

import '../feature/user_event/dao.dart';

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
  static String? httpProxy;

  static final eventBus = EventBus<EventNameConstants>();
  static late PageLogger pageLogger;

  static late CookieJar cookieJar;
  static late Dio dio;
  static late Dio dio2; // 消费查询连接池
  static late SsoSession ssoSession;
  static late SsoSession ssoSession2;

  static Future<void> init({
    required UserEventStorageDao userEventStorage,
    required AuthSettingDao authSetting,
  }) async {
    cookieJar = await CookieInitializer.init();
    dio = await DioInitializer.init(
      config: DioConfig()
        ..cookieJar = cookieJar
        ..httpProxy = httpProxy,
    );
    dio2 = await DioInitializer.init(
      config: DioConfig()
        ..cookieJar = cookieJar
        ..connectTimeout = 30 * 1000
        ..httpProxy = httpProxy,
    );
    ssoSession = SsoSession(dio: dio, cookieJar: cookieJar);
    ssoSession2 = SsoSession(dio: dio2, cookieJar: cookieJar);
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
