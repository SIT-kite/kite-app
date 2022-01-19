import 'package:kite/entity/report.dart';

abstract class ReportDao {
  Future<List<ReportHistory>> getHistoryList(String userId);

  Future<ReportHistory?> getRecentHistory(String userId);
}
