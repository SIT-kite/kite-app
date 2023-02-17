/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:kite/util/logger.dart';

import '../dao/remote.dart';
import '../entity/bulletin.dart';
import '../using.dart';

class KiteBulletinService implements KiteBulletinServiceDao {
  static const String _bulletinPath = '${Backend.kiteStatic}/bulletin/content.json';
  static const String _bulletinMetaPath = '${Backend.kiteStatic}/bulletin/meta.json';

  final ISession session;

  const KiteBulletinService(this.session);

  /// 对通知排序, 优先放置置顶通知, 其次是新通知.
  void _sort(List<KiteBulletin> noticeList) {
    noticeList.sort((a, b) {
      // 相同优先级比发布序号
      return ((a.top == b.top && a.id > b.id) || (a.top && !b.top)) ? -1 : 1;
    });
  }

  @override
  Future<List<KiteBulletin>> getSortedBulletinList() async {
    final response = await session.request(_bulletinPath, ReqMethod.get);
    final List noticeList = response.data;

    List<KiteBulletin> result = noticeList.map((e) => KiteBulletin.fromJson(e)).toList();
    _sort(result);
    return result;
  }

  @override
  Future<KiteBulletinMeta> getBulletinMeta() async {
    Log.info('请求：$_bulletinMetaPath');
    final response = await session.request(_bulletinMetaPath, ReqMethod.get);
    return KiteBulletinMeta.fromJson(response.data);
  }
}
