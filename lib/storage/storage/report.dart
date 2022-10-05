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
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kite/storage/dao/report.dart';

class ReportKeys {
  static const namespace = '/report';
  static const enable = '$namespace/enable';
  static const time = '$namespace/time';
}

class ReportStorage implements ReportStorageDao {
  final Box<dynamic> box;

  ReportStorage(this.box);

  @override
  bool? get enable => box.get(ReportKeys.enable);
  @override
  set enable(bool? val) => box.put(ReportKeys.enable, val);

  @override
  DateTime? get time => box.get(ReportKeys.time);
  @override
  set time(DateTime? val) => box.put(ReportKeys.time, val);
}
