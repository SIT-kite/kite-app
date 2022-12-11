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
import 'package:kite/credential/symbol.dart';
import 'package:kite/credential/using.dart';

import '../foundation.dart';

// ignore: non_constant_identifier_names
final NoVersionSpecifiedMigration = _NoVersionSpecifiedMigrationImpl();

class _NoVersionSpecifiedMigrationImpl extends Migration {
  @override
  Future<void> perform() async {
    await migrateOAAuth();
    await migrateFreshmanAuth();
  }

  Future<void> migrateOAAuth() async {
    final kvBox = HiveBoxInit.kv;
    final credentialBox = HiveBoxInit.credentials;
    final dynamic account = kvBox.get("/auth/currentUsername");
    final dynamic password = kvBox.get("/auth/ssoPassword");
    if (account is String && password is String) {
      credentialBox.put("/credential/oa", OACredential(account, password));
      kvBox.delete("/auth/currentUsername");
      kvBox.delete("/auth/ssoPassword");
    }
  }

  Future<void> migrateFreshmanAuth() async {
    final kvBox = HiveBoxInit.kv;
    final dynamic account = kvBox.get("/freshman/auth/account");
    final dynamic password = kvBox.get("/freshman/auth/secret");
    final credentialBox = HiveBoxInit.credentials;
    if (account is String && password is String) {
      credentialBox.put("/credential/oa", OACredential(account, password));
      kvBox.delete("/freshman/auth/account");
      kvBox.delete("/freshman/auth/secret");
    }
  }
}
