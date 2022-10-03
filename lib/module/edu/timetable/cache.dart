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

import 'entity.dart';

/// 某一天课程的缓存
class TableCache {
  final Map<int, List<Course>> _cache = {};

  TableCache();

  List<Course> get(int week, int day) {
    return _cache[week * 10 + day] ?? [];
  }

  void put(int week, int day, List<Course> courseList) {
    _cache[week * 10 + day] = courseList;
  }

  void clear() {
    _cache.clear();
  }

  List<Course> filterCourseOnDay(List<Course> allCourses, int week, int day) {
    List<Course> filtered = get(week, day);
    if (filtered.isNotEmpty) {
      return filtered;
    }
    filtered = allCourses.where((e) => e.dayIndex == day && e.weekIndex & 1 << week != 0).toList();
    filtered.sort((a, b) => (a.timeIndex).compareTo(b.timeIndex));
    put(week, day, filtered);
    return filtered;
  }
}
