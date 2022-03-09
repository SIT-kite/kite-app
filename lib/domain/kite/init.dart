import 'package:kite/util/hive_register_adapter.dart';

import 'entity/index.dart';

class KiteInitializer {
  static void init() {
    registerAdapter(UserEventAdapter());
    registerAdapter(UserEventTypeAdapter());
  }
}
