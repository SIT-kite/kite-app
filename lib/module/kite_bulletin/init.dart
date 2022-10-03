import 'dao/remote.dart';
import 'service/bulletin.dart';
import 'using.dart';

class KiteBulletinInitializer {
  KiteBulletinInitializer._();

  static late NoticeServiceDao noticeService;
  static late KiteSession kiteSession;

  static Future<void> init({
    required KiteSession kiteSession,
  }) async {
    KiteBulletinInitializer.kiteSession = kiteSession;
    noticeService = NoticeService(kiteSession);
  }
}
