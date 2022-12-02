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
import '../events.dart';
import '../utils.dart';
import 'package:rettulf/rettulf.dart';

import '../cache.dart';
import '../entity/course.dart';
import '../entity/meta.dart';
import '../init.dart';
import '../user_widget/timetable.dart';
import '../using.dart';
import 'export.dart';

const DisplayMode defaultMode = DisplayMode.weekly;

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  /// 最大周数
  /// TODO 还没用上
  // static const int maxWeekCount = 20;
  final tableViewerController = TimetableViewerController();

  final storage = TimetableInit.timetableStorage;

  // 模式：周课表 日课表
  late ValueNotifier<DisplayMode> $displayMode;

  // 课程表
  late List<Course> courses;

  // 课表元数据
  late TimetableMeta? meta;

  /// 懒加载变量，只有用到的时候才会初始化
  late ExportDialog exportDialog = ExportDialog(context, meta!, courses);

  void checkFirstImportTable() {
    if (courses.isEmpty) {
      Future.delayed(Duration.zero, () async {
        final approve = await context.showRequest(
            title: i18n.timetableInitialImportRequest,
            desc: i18n.timetableInitialImportRequestDesc,
            yes: i18n.yes,
            no: i18n.notNow);

        if (approve == true) {
          if (!mounted) return;
          await Navigator.of(context).pushNamed(RouteTable.timetableImport);
        }
      });
    }
  }

  @override
  void initState() {
    Log.info('Timetable init');
    final initialMode = storage.lastMode ?? DisplayMode.weekly;
    $displayMode = ValueNotifier(initialMode);
    $displayMode.addListener(() {
      storage.lastMode = $displayMode.value;
    });
    storage.lastMode = initialMode;
    courses = storage.currentTableCourses ?? [];
    meta = storage.currentTableMeta;
    eventBus.on<DefaultTimetableChangeEvent>().listen((event) {
      if (!mounted) return;
      setState(() {
        courses = storage.currentTableCourses ?? [];
        meta = storage.currentTableMeta;
      });
    });
    checkFirstImportTable();
    super.initState();
  }

  // TODO: Finish this
  void _onExport() {
    if (meta == null || courses.isEmpty) {
      showBasicFlash(context, const Text('你咋没课呢？？'));
      return;
    }
    exportDialog.export();
  }

  Future<void> selectTimetablePageToJump(BuildContext ctx) async {
    final currentWeek = $currentPos.value.week;
    final initialIndex = currentWeek - 1;
    final controller = FixedExtentScrollController(initialItem: initialIndex);
    final startDate = meta?.startDate;
    final todayIndex = startDate != null ? TimetablePosition.locate(startDate, DateTime.now()).week - 1 : 0;
    final goto = await ctx.showPicker(
        count: 20,
        controller: controller,
        ok: i18n.timetableJumpBtn,
        okEnabled: (curSelected) => curSelected != initialIndex,
        actions: [
          if (startDate != null)
            (ctx, curSelected) => i18n.timetableJumpFindTodayBtn.text().cupertinoButton(
                onPressed: curSelected == todayIndex
                    ? null
                    : () {
                        controller.animateToItem(todayIndex,
                            duration: const Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
                      })
        ],
        make: (ctx, i) {
          return Text(i18n.timetableWeekOrderedName(i + 1));
        });
    if (goto != null && goto != (initialIndex)) {
      tableViewerController.jumpToWeek(goto + 1);
    }
  }

  final ValueNotifier<TimetablePosition> $currentPos = ValueNotifier(TimetablePosition.initial);

  @override
  Widget build(BuildContext context) {
    Log.info('Timetable build');
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: $currentPos,
          builder: (ctx, value, child) {
            var weekdayText = makeWeekdaysText();
            final mode = $displayMode.value;
            if (mode == DisplayMode.weekly) {
              return i18n.timetableWeekOrderedName(value.week).text();
            } else {
              return "${i18n.timetableWeekOrderedName(value.week)} ${weekdayText[(value.day - 1) % 7]}".text();
            }
          },
        ),
        actions: <Widget>[
          //_buildSwitchWeekButton(),
          buildSwitchViewButton(context),
          buildMyTimetablesButton(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.undo_rounded),
        onPressed: () async {
          await selectTimetablePageToJump(context);
        },
      ),
      body: TimetableViewer(
        controller: tableViewerController,
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
      onPressed: tableViewerController.toggleDisplayMode,
    );
  }

  Widget buildMyTimetablesButton(BuildContext ctx) {
    return IconButton(
        icon: const Icon(Icons.person_rounded),
        onPressed: () async {
          await Navigator.of(ctx).pushNamed(RouteTable.myTimetables);
        });
  }
}
