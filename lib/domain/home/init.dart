import 'package:kite/util/hive_register_adapter.dart';

import 'entity/home.dart';

class HomeInitializer {
  static void init() {
    registerAdapter(FunctionTypeAdapter());
  }
}
