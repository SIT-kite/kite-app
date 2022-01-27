import 'package:kite/dao/notice.dart';
import 'package:kite/entity/kite/notice.dart';
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
