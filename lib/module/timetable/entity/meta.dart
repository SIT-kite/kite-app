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
import '../using.dart';

part 'meta.g.dart';

/// 存放课表元数据
@HiveType(typeId: HiveTypeId.timetableMetaItem)
class TimetableMeta extends HiveObject {
  /// 课表名称
  @HiveField(0)
  String name = '';

  /// 课表描述
  @HiveField(1)
  String description = '';

  /// 课表的起始时间
  @HiveField(2)
  DateTime startDate = DateTime.now();

  /// 学年
  @HiveField(3)
  int schoolYear = 0;

  /// 学期
  @HiveField(4)
  int semester = 0;

  @override
  String toString() {
    return 'TimetableMeta{name: $name, description: $description, startDate: $startDate, schoolYear: $schoolYear, semester: $semester}';
  }
}
