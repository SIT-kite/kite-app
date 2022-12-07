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
import 'package:kite/module/kite_bulletin/storage/storage.dart';
import 'package:kite/storage/init.dart';

import 'cache/cache.dart';
import 'dao/local.dart';
import 'dao/remote.dart';
import 'service/bulletin.dart';
import 'using.dart';

class KiteBulletinInit {
  KiteBulletinInit._();

  static late KiteBulletinServiceDao service;
  static late ISession kiteSession;
  static late KiteBulletinStorageDao storage;
  static late KiteBulletinServiceDao cache;

  static Future<void> init({
    required ISession session,
  }) async {
    KiteBulletinInit.kiteSession = session;
    service = KiteBulletinService(session);
    storage = KiteBulletinStorage(Kv.kvStorageBox);
    cache = CachedKiteBulletinService(
      storage: storage,
      service: service,
    );
  }
}
