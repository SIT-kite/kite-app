import 'package:kite/r.dart';
import 'package:version/version.dart';

import 'all/cache.dart';
import 'foundation.dart';

class Migrations {
  static final _manager = MigrationManager();

  static void init() {
    R.v1_5_3 << ClearCacheMigration;
  }

  static Future<void> perform({required Version? from, required Version? to}) async {
    if (from == null || to == null) return;
    _manager.upgrade(from, to);
  }
}

extension _MigrationEx on Version {
  void operator <<(Migration migration) {
    Migrations._manager.when(this, perform: migration);
  }
}
