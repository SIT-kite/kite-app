import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:intl/intl.dart';

String bulletinTitle = "div.bulletin-title";
String bulletinMessage = "div.bulletin-info";
String bulletinContent = "div.bulletin-content";
String bulletinAttachments = 'tr[align="center"] > td';

class BulletinDetail {
  /// 标题
  String title = "";

  /// 发布时间
  DateTime dateTime;

  /// 发布部门
  String department = "";

  /// 内容
  String content = "";

  /// 附件
  List<Attachment> attachments;

  BulletinDetail(this.title, this.dateTime, this.department, this.content,
      this.attachments);

  @override
  String toString() {
    return 'BulletinDetail{title: $title, dateTime: $dateTime, department: $department, content: $content, attachments: $attachments}';
  }

  static String _replaceNbsp(String s) => s.replaceAll("&nbsp;", "");

  static BulletinDetail _noticeDetailMap(BeautifulSoup item) {
    List<Attachment> attachments = [];
    var dateformat = DateFormat('yyyy年MM月dd日 hh:mm');
    // Get message
    String title = item
        .findAll(bulletinTitle)
        .map((e) => e.innerHtml.split("<")[0].trim())
        .elementAt(0);
    String message = item
        .findAll(bulletinMessage)
        .map((e) => _replaceNbsp(e.innerHtml.trim()))
        .elementAt(0);
    String content =
        item.findAll(bulletinContent).map((e) => e.innerHtml).join();
    item.findAll(bulletinAttachments).forEach((element) {
      var url =
          element.findAll("a").map((e) => e.attributes['href']).elementAt(0);
      String attachmentUrl = "https://myportal.sit.edu.cn/" + url!;
      var attachmentName =
          element.findAll("a").map((e) => e.innerHtml).elementAt(0);
      Attachment attachment = Attachment(attachmentName, attachmentUrl);
      attachments.add(attachment);
    });

    // Parse message
    DateTime time = dateformat.parse(message
        .split('|')
        .map((e) => e.trim())
        .elementAt(0)
        .replaceAll('发布时间：', ''));
    String place = message
        .split('|')
        .map((e) => e.trim())
        .elementAt(1)
        .replaceAll('发布部门：', '')
        .split('<')[0];

    return BulletinDetail(title, time, place, content, attachments);
  }
}

BulletinDetail getNoticeDetail(String htmlPage) {
  final BeautifulSoup soup = BeautifulSoup(htmlPage);
  return BulletinDetail._noticeDetailMap(soup);
}

class Attachment {
  /// 附件标题
  String name = "";

  /// 附件下载网址
  String url = "";

  Attachment(this.name, this.url);

  @override
  String toString() {
    return 'Attachment{name: $name, url: $url}';
  }
}
