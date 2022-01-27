import 'package:kite/dao/notice.dart';
import 'package:kite/entity/kite/notice.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

class NoticeService extends AService implements NoticeServiceDao {
  static const String _noticeUrl = 'https://kite.sunnysab.cn/api/v2/notice';

  NoticeService(ASession session) : super(session);

  @override
  Future<List<KiteNotice>> getNoticeList() async {
    final response = await session.get(_noticeUrl);
    final List noticeList = response.data['data'];

    List<KiteNotice> result = noticeList.map((e) => KiteNotice.fromJson(e)).toList();
    return result;
  }
}
