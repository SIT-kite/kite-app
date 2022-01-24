import 'package:dio/dio.dart';
import 'package:kite/dao/report.dart';
import 'package:kite/entity/report.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/session/abstract_session.dart';

export '../../session/report_session.dart';

class ReportService extends AService implements ReportDao {
  ReportService(ASession session) : super(session);

  static const String _historyUrl = 'http://xgfy.sit.edu.cn/report/report/getMyReport';

  @override
  Future<List<ReportHistory>> getHistoryList(String userId) async {
    final payload = '{"usercode":"$userId","batchno":""}';
    final response = await session.post(_historyUrl,
        data: payload, contentType: Headers.jsonContentType, responseType: ResponseType.json);

    final Map<String, dynamic> respondedData = response.data;
    if (respondedData['code'] == 0) {
      final List userHistory = respondedData['data'];
      return userHistory.map((e) => ReportHistory.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('(${respondedData['code']}) ${respondedData['msg']}');
  }

  @override
  Future<ReportHistory?> getRecentHistory(String userId) async {
    final historyList = await getHistoryList(userId);
    ReportHistory? result;
    try {
      // 当元素不存在时 first getter 会抛出异常.
      result = historyList.first;
    } catch (_) {}
    return result;
  }
}
