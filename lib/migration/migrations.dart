/*
 *    上应小风筝(SIT-kite)  便利校园，一步到位
 *    Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 *    This program is free software: you can redistribute it and/or modify
 *    it under the terms of the GNU General Public License as published by
 *    the Free Software Foundation, either version 3 of the License, or
 *    (at your option) any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import 'package:kite/migration/all/initial.dart';
import 'package:kite/r.dart';
import 'package:version/version.dart';

import 'all/cache.dart';
import 'foundation.dart';

class Migrations {
  static final _manager = MigrationManager();
  static Migration? _onNullVersion;

  static void init() {
    _onNullVersion = NoVersionSpecifiedMigration;
    R.v1_5_3 << ClearCacheMigration;
  }

  static Future<void> perform({required Version? from, required Version? to}) async {
    if (from == null) {
      await _onNullVersion?.perform();
    } else {
      if (to != null) {
        await _manager.upgrade(from, to);
      }
    }
  }
}

extension _MigrationEx on Version {
  void operator <<(Migration migration) {
    Migrations._manager.when(this, perform: migration);
  }
}
