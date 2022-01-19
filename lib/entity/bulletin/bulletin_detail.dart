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
  String content = "";

  /// 附件
  List<Attachment> attachments = [];

  @override
  String toString() {
    return 'BulletinDetail{title: $title, dateTime: $dateTime, department: $department, author: $author, readNumber: $readNumber, content: $content, attachments: $attachments}';
  }
}
