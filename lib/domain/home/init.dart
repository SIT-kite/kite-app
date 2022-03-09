import 'package:kite/domain/kite/dao/index.dart';
import 'package:kite/session/sso/index.dart';

class HomeInitializer {
  static late SsoSession ssoSession;
  static late NoticeServiceDao noticeService;
  static init({
    required SsoSession ssoSession,
    required NoticeServiceDao noticeService,
  }) {
    HomeInitializer.ssoSession = ssoSession;
    HomeInitializer.noticeService = noticeService;
  }
}
