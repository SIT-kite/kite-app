/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:intl/intl.dart';
import 'package:kite/network/session.dart';

import 'dao.dart';
import 'entity.dart';

class BulletinService implements BulletinDao {
  final ISession session;

  const BulletinService(this.session);

  List<Attachment> _parseAttachment(Bs4Element element) {
    return element.find('#containerFrame > table')!.findAll('a').map((e) {
      return Attachment()
        ..name = e.text.trim()
        ..url = 'https://myportal.sit.edu.cn/${e.attributes['href']!}';
    }).toList();
  }

  BulletinDetail _parseBulletinDetail(Bs4Element item) {
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
    final response = await session.request(_buildBulletinUrl(bulletinCatalogueId, uuid), ReqMethod.get);
    return _parseBulletinDetail(BeautifulSoup(response.data).html!);
  }

  // 构造获取文章列表的url
  static String _buildBulletinListUrl(int pageIndex, String bulletinCatalogueId) {
    return 'https://myportal.sit.edu.cn/detach.portal?pageIndex=$pageIndex&groupid=&action=bulletinsMoreView&.ia=false&pageSize=&.pmn=view&.pen=$bulletinCatalogueId';
  }

  static BulletinListPage _parseBulletinListPage(Bs4Element element) {
    final list = element.findAll('li').map((e) {
      final departmentAndDate = e.find('span', class_: 'rss-time')!.text.trim();
      final departmentAndDateLen = departmentAndDate.length;
      final department = departmentAndDate.substring(0, departmentAndDateLen - 8);
      final date = '20${departmentAndDate.substring(departmentAndDateLen - 8, departmentAndDateLen)}';

      final titleElement = e.find('a', class_: 'rss-title')!;
      final uri = Uri.parse(titleElement.attributes['href']!);

      return BulletinRecord()
        ..title = titleElement.text.trim()
        ..department = department
        ..dateTime = DateFormat('yyyy-MM-dd').parse(date)
        ..bulletinCatalogueId = uri.queryParameters['.pen']!
        ..uuid = uri.queryParameters['bulletinId']!;
    }).toList();

    final currentElement = element.find('div', attrs: {'title': '当前页'})!;
    final lastElement = element.find('a', attrs: {'title': '点击跳转到最后页'})!;
    final lastElementHref = Uri.parse(lastElement.attributes['href']!);
    final lastPageIndex = lastElementHref.queryParameters['pageIndex']!;
    return BulletinListPage()
      ..bulletinItems = list
      ..currentPage = int.parse(currentElement.text)
      ..totalPage = int.parse(lastPageIndex);
  }

  @override
  Future<BulletinListPage> queryBulletinList(int pageIndex, String bulletinCatalogueId) async {
    final response = await session.request(_buildBulletinListUrl(pageIndex, bulletinCatalogueId), ReqMethod.get);
    return _parseBulletinListPage(BeautifulSoup(response.data).html!);
  }
}
