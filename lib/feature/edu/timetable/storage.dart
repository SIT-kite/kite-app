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
import 'package:hive/hive.dart';
import 'package:kite/feature/edu/common/entity/index.dart';

import 'entity.dart';

class TimetableKeys {
  static const _namespace = '/timetable';

  /// 当前的显示模式
  static const lastMode = '$_namespace/lastMode';

  /// 课表相关数据的命名空间
  static const table = '$_namespace/table';

  /// 维护多个课表的元数据
  static const tableNames = '$table/name';

  /// 通过课表名称获取课表路径
  static String buildTableKeyByName(String name) => '$table/data/$name';

  /// 通过学年学期信息获取课表路径
  static String buildTableKey(SchoolYear schoolYear, Semester semester) =>
      buildTableKeyByName('${schoolYear.year!}-${semester.index}');

  /// 当前使用的课表名称
  static const currentTableName = '$_namespace/currentTableName';

  /// 当前课表显示的起始日期
  static const startDate = '$_namespace/startDate';
}

class TimetableStorage {
  final Box<dynamic> box;

  const TimetableStorage(this.box);

  List<Course>? getTableByName(String name) {
    return box.get(TimetableKeys.buildTableKeyByName(name));
  }

  void setTableByName(String name, List<Course>? table) {
    box.put(TimetableKeys.buildTableKeyByName(name), table);
  }

  List<Course>? getTable(SchoolYear schoolYear, Semester semester) {
    return box.get(TimetableKeys.buildTableKey(schoolYear, semester));
  }

  void setTable(SchoolYear schoolYear, Semester semester, List<Course>? table) {
    box.put(TimetableKeys.buildTableKey(schoolYear, semester), table);
  }

  List<String>? get tableNames => box.get(TimetableKeys.tableNames);
  set tableNames(List<String>? foo) => box.put(TimetableKeys.tableNames, foo);

  String? get currentTableName => box.get(TimetableKeys.currentTableName);
  set currentTableName(String? foo) => box.put(TimetableKeys.currentTableName, foo);

  List<Course>? get currentTable {
    if (currentTableName == null) return null;
    return getTableByName(currentTableName!);
  }

  DisplayMode? get lastMode {
    final idx = box.get(TimetableKeys.lastMode);
    if (idx == null) return null;
    return DisplayMode.values[idx];
  }

  set lastMode(DisplayMode? foo) => box.put(TimetableKeys.lastMode, foo?.index);

  DateTime? get startDate => box.get(TimetableKeys.startDate);
  set startDate(DateTime? date) => box.put(TimetableKeys.startDate, date);
}
