import 'package:dio/dio.dart';
import 'package:kite/abstract/abstract_session.dart';
import 'package:kite/util/hive_register_adapter.dart';

import 'dao/report.dart';
import 'entity/report.dart';
import 'report_session.dart';
import 'service/index.dart';

class ReportInitializer {
  static late ASession session;
  static late ReportDao reportService;
  static void init({
    required Dio dio,
  }) {
    registerAdapter(ReportHistoryAdapter());
    session = ReportSession(dio: dio);
    reportService = ReportService(session);
  }
}
