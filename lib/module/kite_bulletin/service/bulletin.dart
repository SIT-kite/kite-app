import '../dao/remote.dart';
import '../entity/bulletin.dart';
import '../using.dart';

class NoticeService implements NoticeServiceDao {
  static const String _noticePath = '/notice';

  final ISession session;

  const NoticeService(this.session);

  /// 对通知排序, 优先放置置顶通知, 其次是新通知.
  void _sort(List<KiteNotice> noticeList) {
    noticeList.sort((a, b) {
      // 相同优先级比发布序号
      return ((a.top == b.top && a.id > b.id) || (a.top && !b.top)) ? -1 : 1;
    });
  }

  @override
  Future<List<KiteNotice>> getNoticeList() async {
    final response = await session.request(_noticePath, ReqMethod.get);
    final List noticeList = response.data;

    List<KiteNotice> result = noticeList.map((e) => KiteNotice.fromJson(e)).toList();
    _sort(result);
    return result;
  }
}
