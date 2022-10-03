import 'attachment.dart';

class BulletinDetail {
  /// 标题
  String title = '';

  /// 发布时间
  DateTime dateTime = DateTime.now();

  /// 发布部门
  String department = '';

  /// 发布者
  String author = '';

  /// 阅读人数
  int readNumber = 0;

  /// 内容(html格式)
  String content = '';

  /// 附件
  List<Attachment> attachments = [];

  @override
  String toString() {
    return 'BulletinDetail{title: $title, dateTime: $dateTime, department: $department, author: $author, readNumber: $readNumber, content: $content, attachments: $attachments}';
  }
}

/// 通知分类
class BulletinCatalogue {
  /// 分类名
  final String name;

  /// 分类代号(OA上命名为pen，以pe打头)
  final String id;

  const BulletinCatalogue(this.name, this.id);
}

/// 某篇通知的记录信息，根据该信息可寻找到对应文章
class BulletinRecord {
  /// 标题
  String title = '';

  /// 文章id
  String uuid = '';

  /// 目录id
  String bulletinCatalogueId = '';

  /// 发布时间
  DateTime dateTime = DateTime.now();

  /// 发布部门
  String department = '';

  @override
  String toString() {
    return 'BulletinRecord{title: $title, uuid: $uuid, bulletinCatalogueId: $bulletinCatalogueId, dateTime: $dateTime, department: $department}';
  }
}
