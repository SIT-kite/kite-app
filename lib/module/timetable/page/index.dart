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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kite/design/user_widgets/dialog.dart';
import '../using.dart';

import '../cache.dart';
import '../entity/course.dart';
import '../entity/meta.dart';
import '../init.dart';
import '../user_widget/tiemtable.dart';
import 'export.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final ValueNotifier<bool> $isTodayView = ValueNotifier(true);

  /// 最大周数
  /// TODO 还没用上
  // static const int maxWeekCount = 20;
  final tableViewerController = TimetableViewerController();

  final storage = TimetableInit.timetableStorage;

  // 模式：周课表 日课表
  late DisplayMode displayMode;

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
            title: i18n.timetableInitialImportRquest,
            desc: i18n.timetableInitialImportRquestDesc,
            yes: i18n.yes,
            no: i18n.notNow);

        if (approve) {
          if (!mounted) return;
          await Navigator.of(context).pushNamed(RouteTable.timetableImport);
          _onRefresh();
        }
      });
    }
  }

  @override
  void initState() {
    Log.info('Timetable init');
    displayMode = storage.lastMode ?? DisplayMode.weekly;
    storage.lastMode = displayMode;
    courses = storage.currentTableCourses ?? [];
    meta = storage.currentTableMeta;
    checkFirstImportTable();
    super.initState();
  }

  void _onExport() {
    if (meta == null || courses.isEmpty) {
      showBasicFlash(context, const Text('你咋没课呢？？'));
      return;
    }
    exportDialog.export();
  }

  /// 根据本地缓存刷新课表
  void _onRefresh() {
    setState(() {
      courses = storage.currentTableCourses ?? [];
      meta = storage.currentTableMeta;
    });
  }

  ///跳转到某一周按钮
  Widget _buildSwitchWeekButton() {
    List weekList = Iterable.generate(20, (i) => i).toList();

    return PopupMenuButton(
      onSelected: (index) => tableViewerController.jumpToWeek(int.parse(index.toString()) + 1),
      itemBuilder: (BuildContext context) {
        return weekList
            .map((e) => PopupMenuItem(
                  value: e,
                  child: Text('第${e + 1}周'),
                ))
            .toList();
      },
      constraints: const BoxConstraints(maxHeight: 400, minWidth: 50),
      child: const Icon(Icons.scale),
    );
  }

  @override
  Widget build(BuildContext context) {
    Log.info('Timetable build');
    return Scaffold(
      appBar: AppBar(
        title: i18n.ftype_timetable.txt,
        actions: <Widget>[
          //_buildSwitchWeekButton(),
          buildSwitchViewButton(context),
          buildMyTimetablesButton(context),
        ],
      ),
      floatingActionButton: ValueListenableBuilder<bool>(
        valueListenable: $isTodayView,
        builder: (BuildContext context, bool value, Widget? child) {
          return AnimatedOpacity(
            opacity: value ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 100),
            child: FloatingActionButton(
              onPressed: () {
                tableViewerController.jumpToToday();
              },
              child: const Icon(Icons.undo_rounded),
            ),
          );
        },
      ),
      body: TimetableViewer(
        key: UniqueKey(),
        controller: tableViewerController,
        initialTableMeta: meta,
        initialTableCourses: courses,
        tableCache: TableCache(),
        $isTodayView: $isTodayView,
        initialDisplayMode: displayMode,
        onDisplayChanged: (DisplayMode newMode) {
          displayMode = newMode;
          storage.lastMode = newMode;
        },
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
          _onRefresh();
        });
  }
}
