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
import 'package:flutter/material.dart';
import 'package:quiver/core.dart';
import 'package:rettulf/rettulf.dart';

import '../cache.dart';
import '../entity/course.dart';
import '../entity/meta.dart';
import '../using.dart';
import 'daily.dart';
import 'weekly.dart';

abstract class InitialTimeProtocol {
  DateTime get initialDate;
}

extension InitialTimeUtils on InitialTimeProtocol {
  TimetablePosition locateInTimetable(DateTime target) => TimetablePosition.locate(initialDate, target);
}

class TimetablePosition {
  final int week;
  final int day;

  const TimetablePosition({this.week = 1, this.day = 1});

  static const initial = TimetablePosition();

  static TimetablePosition locate(DateTime initial, DateTime time) {
    // 求一下过了多少天
    int days = time.clearTime().difference(initial.clearTime()).inDays;

    int week = days ~/ 7 + 1;
    int day = days % 7 + 1;
    if (days >= 0 && 1 <= week && week <= 20 && 1 <= day && day <= 7) {
      return TimetablePosition(week: week, day: day);
    } else {
      return const TimetablePosition(week: 1, day: 1);
    }
  }

  TimetablePosition copyWith({int? week, int? day}) => TimetablePosition(
        week: week ?? this.week,
        day: day ?? this.day,
      );

  @override
  bool operator ==(Object other) {
    return other is TimetablePosition && runtimeType == other.runtimeType && week == other.week && day == other.day;
  }

  @override
  int get hashCode => hash2(week, day);
}

class TimetableViewer extends StatefulWidget {
  /// 初始课表元数据
  final TimetableMeta initialTableMeta;

  /// 初始课表课程
  final List<Course> initialTableCourses;

  /// 初始显示模式
  final ValueNotifier<DisplayMode> $displayMode;

  final VoidCallback? onJumpedToday;

  /// 课表视图使用的缓存
  final TableCache tableCache;

  final ValueNotifier<TimetablePosition> $currentPos;

  const TimetableViewer({
    required this.initialTableMeta,
    required this.initialTableCourses,
    required this.$displayMode,
    required this.tableCache,
    required this.$currentPos,
    this.onJumpedToday,
    Key? key,
  }) : super(key: key);

  @override
  State<TimetableViewer> createState() => _TimetableViewerState();
}

class _TimetableViewerState extends State<TimetableViewer> {
  /// 最大周数
  /// TODO 还没用上
  // static const int maxWeekCount = 20;

  @override
  void initState() {
    Log.info('TimetableViewer init');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.$displayMode <<
        (ctx, mode, _) => (mode == DisplayMode.daily
                    ? DailyTimetable(
                        $currentPos: widget.$currentPos,
                        allCourses: widget.initialTableCourses,
                        initialDate: widget.initialTableMeta.startDate,
                        tableCache: widget.tableCache,
                      )
                    : WeeklyTimetable(
                        $currentPos: widget.$currentPos,
                        allCourses: widget.initialTableCourses,
                        initialDate: widget.initialTableMeta.startDate,
                        tableCache: widget.tableCache,
                      ))
                .animatedSwitched(
              d: const Duration(milliseconds: 300),
            );
  }
}
