import 'dao/remote.dart';
import 'service/bulletin.dart';
import 'using.dart';

class KiteBulletinInit {
  KiteBulletinInit._();

  static late NoticeServiceDao noticeService;
  static late KiteSession kiteSession;

  static Future<void> init({
    required KiteSession kiteSession,
  }) async {
    KiteBulletinInit.kiteSession = kiteSession;
    noticeService = NoticeService(kiteSession);
  }
}
