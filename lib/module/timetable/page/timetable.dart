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
import 'package:rettulf/rettulf.dart';

import '../cache.dart';
import '../entity/course.dart';
import '../entity/meta.dart';
import '../init.dart';
import '../user_widget/palette.dart';
import '../user_widget/timetable.dart';
import '../using.dart';
import '../utils.dart';
import 'export.dart';

const DisplayMode defaultMode = DisplayMode.weekly;

class TimetablePage extends StatefulWidget {
  final TimetableMeta meta;

  const TimetablePage({super.key, required this.meta});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  /// 最大周数
  /// TODO 还没用上
  // static const int maxWeekCount = 20;
  final storage = TimetableInit.timetableStorage;

  // 模式：周课表 日课表
  late ValueNotifier<DisplayMode> $displayMode;

  // 课程表
  late List<Course> courses;

  // 课表元数据
  TimetableMeta get meta => widget.meta;

  late final ValueNotifier<TimetablePosition> $currentPos;

  /// 懒加载变量，只有用到的时候才会初始化
  late ExportDialog exportDialog = ExportDialog(context, meta, courses);

  @override
  void initState() {
    super.initState();
    Log.info('Timetable init');
    final initialMode = storage.lastMode ?? DisplayMode.weekly;
    $displayMode = ValueNotifier(initialMode);
    $displayMode.addListener(() {
      storage.lastMode = $displayMode.value;
    });
    storage.lastMode = initialMode;
    courses = storage.getTableCourseByName(meta.name) ?? [];
    $currentPos = ValueNotifier(TimetablePosition.locate(widget.meta.startDate, DateTime.now()));
  }

  // TODO: Finish this
  void _onExport() {
    if (courses.isEmpty) {
      showBasicFlash(context, const Text('你咋没课呢？？'));
      return;
    }
    exportDialog.export();
  }

  Future<void> selectWeeklyTimetablePageToJump(BuildContext ctx) async {
    final currentWeek = $currentPos.value.week;
    final initialIndex = currentWeek - 1;
    final controller = FixedExtentScrollController(initialItem: initialIndex);
    final todayPos = TimetablePosition.locate(meta.startDate, DateTime.now());
    final todayIndex = todayPos.week - 1;
    final index2Go = await ctx.showPicker(
        count: 20,
        controller: controller,
        ok: i18n.timetableJumpBtn,
        okEnabled: (curSelected) => curSelected != initialIndex,
        actions: [
          (ctx, curSelected) => i18n.timetableJumpFindTodayBtn.text().cupertinoButton(
              onPressed: (curSelected == todayIndex)
                  ? null
                  : () {
                      controller.animateToItem(todayIndex,
                          duration: const Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn);
                    })
        ],
        make: (ctx, i) {
          return Text(i18n.timetableWeekOrderedName(i + 1));
        });
    controller.dispose();
    if (index2Go != null && index2Go != initialIndex) {
      $currentPos.value = $currentPos.value.copyWith(
        week: index2Go + 1,
      );
    }
  }

  Future<void> selectDailyTimetablePageToJump(BuildContext ctx) async {
    final currentPos = $currentPos.value;
    final initialWeekIndex = currentPos.week - 1;
    final initialDayIndex = currentPos.day - 1;
    final $week = FixedExtentScrollController(initialItem: initialWeekIndex);
    final $day = FixedExtentScrollController(initialItem: initialDayIndex);
    final todayPos = TimetablePosition.locate(meta.startDate, DateTime.now());
    final todayWeekIndex = todayPos.week - 1;
    final todayDayIndex = todayPos.day - 1;
    final weekdayNames = makeWeekdaysText();
    final indices2Go = await ctx.showDualPicker(
        countA: 20,
        countB: 7,
        controllerA: $week,
        controllerB: $day,
        ok: i18n.timetableJumpBtn,
        okEnabled: (weekSelected, daySelected) => weekSelected != initialWeekIndex || daySelected != initialDayIndex,
        actions: [
          (ctx, week, day) => i18n.timetableJumpFindTodayBtn.text().cupertinoButton(
              onPressed: (week == todayWeekIndex && day == todayDayIndex)
                  ? null
                  : () {
                      $week.animateToItem(todayWeekIndex,
                          duration: const Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn);

                      $day.animateToItem(todayDayIndex,
                          duration: const Duration(milliseconds: 500), curve: Curves.fastLinearToSlowEaseIn);
                    })
        ],
        makeA: (ctx, i) => i18n.timetableWeekOrderedName(i + 1).text(),
        makeB: (ctx, i) => weekdayNames[i].text());
    $week.dispose();
    $day.dispose();
    final week2Go = indices2Go?.item1;
    final day2Go = indices2Go?.item2;
    if (week2Go != null && day2Go != null && (week2Go != initialWeekIndex || day2Go != initialDayIndex)) {
      $currentPos.value = TimetablePosition(week: week2Go + 1, day: day2Go + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    Log.info('Timetable build');
    return Scaffold(
      appBar: AppBar(
        title: $currentPos <<
            (ctx, pos, _) =>
                $displayMode <<
                (ctx, mode, _) => mode == DisplayMode.weekly
                    ? i18n.timetableWeekOrderedName(pos.week).text()
                    : "${i18n.timetableWeekOrderedName(pos.week)} ${makeWeekdaysText()[(pos.day - 1) % 7]}".text(),
        actions: [
          buildSwitchViewButton(context),
          buildMyTimetablesButton(context),
        ],
      ),
      floatingActionButton: InkWell(
          onLongPress: () {
            final today = TimetablePosition.locate(meta.startDate, DateTime.now());
            if ($currentPos.value != today) {
              $currentPos.value = today;
            }
          },
          child: FloatingActionButton(
            child: const Icon(Icons.undo_rounded),
            onPressed: () async {
              if ($displayMode.value == DisplayMode.weekly) {
                await selectWeeklyTimetablePageToJump(context);
              } else {
                await selectDailyTimetablePageToJump(context);
              }
            },
          )),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext ctx) {
    return TimetablePaletteProv(
      child: TimetableViewer(
        initialTableMeta: meta,
        $currentPos: $currentPos,
        initialTableCourses: courses,
        tableCache: TableCache(),
        $displayMode: $displayMode,
      ),
    );
  }

  Widget buildSwitchViewButton(BuildContext ctx) {
    return IconButton(
      icon: const Icon(Icons.swap_horiz_rounded),
      onPressed: () {
        $displayMode.value = DisplayMode.values[($displayMode.value.index + 1) & 1];
      },
    );
  }

  Widget buildMyTimetablesButton(BuildContext ctx) {
    return IconButton(
        icon: const Icon(Icons.person_rounded),
        onPressed: () async {
          await Navigator.of(ctx).pushNamed(RouteTable.timetableMine);
        });
  }
}
