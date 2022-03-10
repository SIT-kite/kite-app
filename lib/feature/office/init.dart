import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

import 'office_session.dart';
import 'service/function.dart';
import 'service/message.dart';

class OfficeInitializer {
  static late CookieJar cookieJar;
  static late OfficeFunctionService functionService;
  static late OfficeMessageService messageService;
  static late OfficeSession session;

  static Future<void> init({
    required Dio dio,
    required CookieJar cookieJar,
  }) async {
    OfficeInitializer.cookieJar = cookieJar;
    session = OfficeSession(dio: dio);

    OfficeInitializer.functionService = OfficeFunctionService(session);
    OfficeInitializer.messageService = OfficeMessageService(session);
  }
}
