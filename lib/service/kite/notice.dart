import 'package:kite/dao/notice.dart';
import 'package:kite/entity/kite/notice.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

class NoticeService extends AService implements NoticeServiceDao {
  static const String _noticePath = '/notice';

  NoticeService(ASession session) : super(session);

  @override
  Future<List<KiteNotice>> getNoticeList() async {
    final response = await session.get(_noticePath);
    final List noticeList = response.data;

    List<KiteNotice> result = noticeList.map((e) => KiteNotice.fromJson(e)).toList();
    return result;
  }
}
