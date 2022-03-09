import 'package:kite/util/hive_register_adapter.dart';

import 'entity/report.dart';

class ReportInitializer {
  static void init() {
    registerAdapter(ReportHistoryAdapter());
  }
}
