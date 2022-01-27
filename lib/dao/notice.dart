import 'package:kite/entity/kite/notice.dart';

// 本地存储
abstract class NoticeStorageDao {
  List<KiteNotice> getNoticeList();
}

// 远程
abstract class NoticeServiceDao {
  // 获取电费数据
  Future<List<KiteNotice>> getNoticeList();
}
