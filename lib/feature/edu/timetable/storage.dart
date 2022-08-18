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

String buildTableName(SchoolYear schoolYear, Semester semester) => '${schoolYear.year!}-${semester.index}';

class TimetableKeys {
  static const _namespace = '/timetable';

  /// 当前的显示模式
  static const lastMode = '$_namespace/lastMode';

  /// 课表相关数据的命名空间
  static const table = '$_namespace/table';

  /// 课表名
  static const tableNames = '$table/names';

  /// 维护多个课表的元数据
  static String buildTableMetaKeyByName(name) => '$table/metas/${name.hashCode.toRadixString(16)}'; // 名称不能存中文在路径中需要哈希一下

  /// 通过课表名称获取课表路径
  static String buildTableCoursesKeyByName(name) => '$table/courses/${name.hashCode.toRadixString(16)}';

  /// 当前使用的课表名称
  static const currentTableName = '$_namespace/currentTableName';

  /// 当前课表显示的起始日期
  static const startDate = '$_namespace/startDate';
}

class TimetableStorage {
  final Box<dynamic> box;

  const TimetableStorage(this.box);

  List<String>? get tableNames => box.get(TimetableKeys.tableNames);
  set tableNames(List<String>? foo) => box.put(TimetableKeys.tableNames, foo);

  /// 通过课表名获取课表
  List<Course>? getTableCourseByName(String name) => box.get(TimetableKeys.buildTableCoursesKeyByName(name));

  /// 添加一张课表
  void addTableCourses(String name, List<Course> table) =>
      box.put(TimetableKeys.buildTableCoursesKeyByName(name), table);

  /// 通过课表名获取课表元数据
  TimetableMeta? getTableMetaByName(String name) => box.get(TimetableKeys.buildTableMetaKeyByName(name));

  /// 通过课表名添加课表元数据
  void addTableMeta(String name, TimetableMeta? foo) => box.put(TimetableKeys.buildTableMetaKeyByName(name), foo);

  /// 添加课表
  void addTable(TimetableMeta meta, List<Course> courses) {
    tableNames = [meta.name, ...((tableNames ?? []).where((n) => n != meta.name))];
    addTableMeta(meta.name, meta);
    addTableCourses(meta.name, courses);
  }

  /// 删除课表
  void removeTable(String name) {
    // 如果删除的是当前正在使用的课表
    if (name == currentTableName) {
      currentTableName = null;
    }
    tableNames = (tableNames ?? []).where((n) => n != name).toList();
    [
      TimetableKeys.buildTableMetaKeyByName(name),
      TimetableKeys.buildTableCoursesKeyByName(name),
    ].forEach(box.delete);
  }

  String? get currentTableName => box.get(TimetableKeys.currentTableName);
  set currentTableName(String? foo) => box.put(TimetableKeys.currentTableName, foo);

  List<Course>? get currentTableCourses {
    if (currentTableName == null) return null;
    return getTableCourseByName(currentTableName!);
  }

  TimetableMeta? get currentTableMeta {
    if (currentTableName == null) return null;
    return getTableMetaByName(currentTableName!);
  }

  DisplayMode? get lastMode {
    final idx = box.get(TimetableKeys.lastMode);
    if (idx == null) return null;
    return DisplayMode.values[idx];
  }

  set lastMode(DisplayMode? foo) => box.put(TimetableKeys.lastMode, foo?.index);
}
