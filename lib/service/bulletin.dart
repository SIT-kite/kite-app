import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:intl/intl.dart';
import 'package:kite/dao/bulletin.dart';
import 'package:kite/entity/bulletin.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/service/abstract_session.dart';

class BulletinService extends AService implements BulletinDao {
  BulletinService(ASession session) : super(session);

  List<Attachment> _parseAttachment(Bs4Element element) {
    return element.find('#containerFrame > table')!.findAll('a').map((e) {
      return Attachment()
        ..name = e.text.trim()
        ..url = 'https://myportal.sit.edu.cn/' + e.attributes['href']!;
    }).toList();
  }

  BulletinDetail _noticeDetailMap(Bs4Element item) {
    final dateFormat = DateFormat('yyyy年MM月dd日 hh:mm');

    String metaHtml = item.find('div', class_: 'bulletin-info')?.innerHtml ?? '';
    // 删除注释
    metaHtml = metaHtml.replaceAll('<!--', '').replaceAll(r'-->', '');
    String meta = BeautifulSoup(metaHtml).text;

    final metaList = meta.split('|').map((e) => e.trim()).toList();

    return BulletinDetail()
      ..title = item.find('div', class_: 'bulletin-title')?.text.trim() ?? ''
      ..content = item.find('div', class_: 'bulletin-content')?.innerHtml ?? ''
      ..attachments = _parseAttachment(item)
      ..dateTime = dateFormat.parse(metaList[0].substring(5))
      ..department = metaList[1].substring(5)
      ..author = metaList[2].substring(3)
      ..readNumber = int.parse(metaList[3].substring(5));
  }

  @override
  Future<List<BulletinCatalogue>> getAllCatalogues() async {
    return const [
      BulletinCatalogue('学生事务', 'pe2362'),
      BulletinCatalogue('学习课堂', 'pe2364'),
      BulletinCatalogue('二级学院通知', 'pe2368'),
      BulletinCatalogue('校园文化', 'pe2366'),
      BulletinCatalogue('公告信息', 'pe2367'),
      BulletinCatalogue('生活服务', 'pe2365'),
      BulletinCatalogue('文件下载专区', 'pe2382')
    ];
  }

  static String _buildBulletinUrl(String bulletinCatalogueId, String uuid) {
    return 'https://myportal.sit.edu.cn/detach.portal?action=bulletinBrowser&.ia=false&.pmn=view&.pen=$bulletinCatalogueId&bulletinId=$uuid';
  }

  @override
  Future<BulletinDetail> getBulletinDetail(String bulletinCatalogueId, String uuid) async {
    final response = await session.get(_buildBulletinUrl(bulletinCatalogueId, uuid));
    return _noticeDetailMap(BeautifulSoup(response.data).html!);
  }

  @override
  Future<List<BulletinRecord>> queryBulletinList(int pageIndex, String bulletinCatalogueId) {
    // TODO: implement queryBulletinList
    throw UnimplementedError();
  }
}
