import 'announcement.dart';

/// 获取到的通知页
class BulletinListPage {
  int currentPage = 1;
  int totalPage = 10;
  List<BulletinRecord> bulletinItems = [];

  @override
  String toString() {
    return 'BulletinListPage{currentPage: $currentPage, totalPage: $totalPage, bulletinItems: $bulletinItems}';
  }
}
