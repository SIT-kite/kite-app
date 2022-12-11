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
import 'package:hive/hive.dart';
import 'package:version/version.dart';

import '../dao/version.dart';

class _Key {
  static const ns = "/version";
  static const lastVersion = "$ns/lastVersion";
  static const lastStartupTime = "$ns/lastStartupTime";
}

class VersionStorage implements VersionDao {
  final Box<dynamic> box;

  VersionStorage(this.box);

  @override
  Version? get lastVersion => box.get(_Key.lastVersion);

  @override
  set lastVersion(Version? newV) => box.put(_Key.lastVersion, newV);

  @override
  DateTime? get lastStartupTime => box.get(_Key.lastStartupTime);

  @override
  set lastStartupTime(DateTime? newV) => box.put(_Key.lastStartupTime, newV);
}
