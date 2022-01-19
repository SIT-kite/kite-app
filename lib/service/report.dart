import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:kite/dao/report.dart';
import 'package:kite/entity/report.dart';
import 'package:kite/service/abstract_service.dart';
import 'package:kite/service/abstract_session.dart';

class ReportService extends AService implements ReportDao {
  ReportService(ASession session) : super(session);

  static const String _historyUrl = 'http://xgfy.sit.edu.cn/report/report/getMyReport';

  @override
  Future<List<ReportHistory>> getHistoryList(String userId) async {
    // TODO: 如果要支持其他功能, 请服用本函数中的部分代码.
    _md5(s) => md5.convert(const Utf8Encoder().convert(s)).toString();
    _sign(t) => _md5('${userId}Unifrinew$t');

    final ts = DateTime.now().microsecondsSinceEpoch;
    final payload = '{"usercode":"$userId","batchno":""}';
    final response = await session.post(
      _historyUrl,
      data: payload,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      options: Options(headers: {'ts': ts, 'decodes': _sign(ts)}),
    );

    final Map<String, dynamic> respondedData = response.data;
    if (respondedData['code'] == 0) {
      final List<Map<String, dynamic>> userHistory = respondedData['data'];
      return userHistory.map(ReportHistory.fromJson).toList();
    }
    throw Exception('(${respondedData['code']}) ${respondedData['msg']}');
  }

  @override
  Future<ReportHistory?> getRecentHistory(String userId) async {
    return (await getHistoryList(userId)).first;
  }
}
