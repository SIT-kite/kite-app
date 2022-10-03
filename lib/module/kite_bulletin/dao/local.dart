import '../entity/bulletin.dart';

// 本地存储
abstract class NoticeStorageDao {
  List<KiteNotice> getNoticeList();
}
