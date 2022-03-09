import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:kite/global/cookie_initializer.dart';
import 'package:kite/global/dio_initializer.dart';
import 'package:kite/session/sso/index.dart';
import 'package:kite/setting/init.dart';
import 'package:kite/util/event_bus.dart';
import 'package:kite/util/page_logger.dart';

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
  static late SsoSession ssoSession;

  static Future<void> init() async {
    dio = await DioInitializer.init(config: DioConfig());
    cookieJar = await CookieInitializer.init();
    ssoSession = SsoSession(dio: dio, cookieJar: cookieJar);
    pageLogger = PageLogger(dio);

    // 若本地存放了用户名与密码，那就惰性登录
    final auth = SettingInitializer.auth;
    if (auth.currentUsername != null && auth.ssoPassword != null) {
      // 惰性登录
      ssoSession.lazyLogin(auth.currentUsername!, auth.ssoPassword!);
    }
    pageLogger.startup();
  }
}
