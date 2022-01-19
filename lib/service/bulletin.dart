import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:intl/intl.dart';
import 'package:kite/entity/bulletin/attachment.dart';
import 'package:kite/entity/bulletin/bulletin_detail.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/service/abstract_session.dart';

class BulletinService extends AService {
  BulletinService(ASession session) : super(session);

  List<Attachment> _parseAttachment(Bs4Element element) {
    return element.find('#containerFrame > table')!.findAll('a').map((e) {
      return Attachment()
        ..name = e.text.trim()
        ..url = 'https://myportal.sit.edu.cn/' + e.attributes['href']!;
    }).toList();
  }

  BulletinDetail _noticeDetailMap(Bs4Element item) {
    final dateformat = DateFormat('yyyy年MM月dd日 hh:mm');

    String metaHtml = item.find('div', class_: 'bulletin-info')?.innerHtml ?? '';
    // 删除注释
    metaHtml = metaHtml.replaceAll('<!--', '').replaceAll(r'-->', '');
    String meta = BeautifulSoup(metaHtml).text;

    final metaList = meta.split('|').map((e) => e.trim()).toList();

    return BulletinDetail()
      ..title = item.find('div', class_: 'bulletin-title')?.text.trim() ?? ''
      ..content = item.find('div', class_: 'bulletin-content')?.innerHtml ?? ''
      ..attachments = _parseAttachment(item)
      ..dateTime = dateformat.parse(metaList[0].substring(5))
      ..department = metaList[1].substring(5)
      ..author = metaList[2].substring(3)
      ..readNumber = int.parse(metaList[3].substring(5));
  }
}
