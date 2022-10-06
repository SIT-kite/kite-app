/*
 * 上应小风筝  便利校园，一步到位
 * Copyright (C) 2022 上海应用技术大学 上应小风筝团队
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/override/interface.dart';
import 'package:kite/override/storage.dart';
import 'package:kite/storage/dao/admin.dart';
import 'package:kite/storage/dao/develop.dart';
import 'package:kite/storage/dao/kite.dart';
import 'package:kite/storage/dao/pref.dart';
import 'package:kite/storage/storage/admin.dart';
import 'package:kite/storage/storage/develop.dart';
import 'package:kite/storage/storage/kite.dart';
import 'package:kite/storage/storage/pref.dart';
import 'package:kite/storage/storage/report.dart';

import 'dao/index.dart';
import 'dao/report.dart';
import 'storage/index.dart';

export 'dao/index.dart';
export 'storage/index.dart';

class Kv {
  static late ThemeSettingDao theme;
  static late AuthSettingDao auth;
  static late AdminSettingDao admin;
  static late NetworkSettingDao network;
  static late JwtDao jwt;
  static late JwtDao sitAppJwt;
  static late HomeSettingDao home;
  static late LoginTimeDao loginTime;
  static late FreshmanCacheDao freshman;
  static late DevelopOptionsDao developOptions;
  static late ReportStorageDao report;
  static late FunctionOverrideStorageDao override;
  static late KiteStorageDao kite;
  static late PrefDao pref;

  static late Box<dynamic> kvStorageBox;
  static Future<void> init({
    required Box<dynamic> kvStorageBox,
  }) async {
    Kv.kvStorageBox = kvStorageBox;
    Kv.auth = AuthSettingStorage(kvStorageBox);
    Kv.admin = AdminSettingStorage(kvStorageBox);
    Kv.home = HomeSettingStorage(kvStorageBox);
    Kv.theme = ThemeSettingStorage(kvStorageBox);
    Kv.network = NetworkSettingStorage(kvStorageBox);
    Kv.jwt = JwtStorage(kvStorageBox);
    Kv.sitAppJwt = SitAppJwtStorage(kvStorageBox);
    Kv.loginTime = LoginTimeStorage(kvStorageBox);
    Kv.freshman = FreshmanCacheStorage(kvStorageBox);
    Kv.developOptions = DevelopOptionsStorage(kvStorageBox);
    Kv.report = ReportStorage(kvStorageBox);
    Kv.kite = KiteStorage(kvStorageBox);
    Kv.override = FunctionOverrideStorage(kvStorageBox);
    Kv.pref = PrefStorage(kvStorageBox);
  }
}
