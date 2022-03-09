import 'package:kite/domain/kite/dao/index.dart';
import 'package:kite/session/sso/index.dart';
import 'package:kite/util/hive_register_adapter.dart';

import 'entity/home.dart';

class HomeInitializer {
  static late SsoSession ssoSession;
  static late NoticeServiceDao noticeService;
  static init({
    required SsoSession ssoSession,
    required NoticeServiceDao noticeService,
  }) {
    registerAdapter(FunctionTypeAdapter());

    HomeInitializer.ssoSession = ssoSession;
    HomeInitializer.noticeService = noticeService;
  }
}
