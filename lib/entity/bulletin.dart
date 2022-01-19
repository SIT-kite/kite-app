class Attachment {
  /// 附件标题
  String name = "";

  /// 附件下载网址
  String url = "";

  @override
  String toString() {
    return 'Attachment{name: $name, url: $url}';
  }
}

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
  String content = "";

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

  /// 分类代号(OA上命名为pen)
  final String id;

  const BulletinCatalogue(this.name, this.id);
}

/// 某篇通知的记录信息，根据该信息可寻找到对应文章
class BulletinRecord {
  String title = '';
  String uuid = '';
  String bulletinCatalogueId = '';
}

/// 获取到的通知页
class BulletinListPage {
  int currentPage = 1;
  int totalPage = 10;
  List<BulletinRecord> bulletinItems = [];
}
