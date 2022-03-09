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
import 'package:kite/domain/kite/dao/notice.dart';
import 'package:kite/domain/kite/entity/notice.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

class NoticeService extends AService implements NoticeServiceDao {
  static const String _noticePath = '/notice';

  NoticeService(ASession session) : super(session);

  /// 对通知排序, 优先放置置顶通知, 其次是新通知.
  void _sort(List<KiteNotice> noticeList) {
    noticeList.sort((a, b) {
      // 相同优先级比发布序号
      return ((a.top == b.top && a.id > b.id) || (a.top && !b.top)) ? -1 : 1;
    });
  }

  @override
  Future<List<KiteNotice>> getNoticeList() async {
    final response = await session.get(_noticePath);
    final List noticeList = response.data;

    List<KiteNotice> result = noticeList.map((e) => KiteNotice.fromJson(e)).toList();
    _sort(result);
    return result;
  }
}
