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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kite/feature/edu/common/entity/index.dart';
import 'package:kite/feature/edu/util/selector.dart';
import 'package:kite/util/alert_dialog.dart';

import '../entity.dart';

class TimetableImportPage extends StatefulWidget {
  const TimetableImportPage({Key? key}) : super(key: key);

  @override
  State<TimetableImportPage> createState() => _TimetableImportPageState();
}

class _TimetableImportPageState extends State<TimetableImportPage> {
  /// 四位年份
  late int selectedYear;

  /// 要查询的学期
  late Semester selectedSemester;

  final ValueNotifier<DateTime> selectedDate = ValueNotifier(DateTime.now());

  @override
  void initState() {
    final DateTime now = DateTime.now();
    // 先根据当前时间估算出是哪个学期
    selectedYear = (now.month >= 9 ? now.year : now.year - 1);
    selectedSemester = (now.month >= 3 && now.month <= 7) ? Semester.secondTerm : Semester.firstTerm;

    super.initState();
  }

  Widget _buildSemesterSelector() {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      child: SemesterSelector(
        yearSelectCallback: (year) {
          setState(() => selectedYear = year);
        },
        semesterSelectCallback: (semester) {
          setState(() => selectedSemester = semester);
        },
        initialYear: selectedYear,
        initialSemester: selectedSemester,
        showEntireYear: false,
        showNextYear: true,
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [const Text('导入学期'), _buildSemesterSelector()],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('起始日期'),
            TextButton(
              child: ValueListenableBuilder<DateTime>(
                valueListenable: selectedDate,
                builder: (context, value, child) {
                  return Text('${value.year} 年 ${value.month} 月 ${value.day} 日');
                },
              ),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: selectedDate.value,
                  currentDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year),
                  lastDate: DateTime(DateTime.now().year + 2),
                );
                if (date != null) selectedDate.value = date;
              },
            ),
          ],
        )
      ],
    );
  }

  ///更新时间的方法
  Future<void> updateData() async {
    // TimetableInitializer.timetableStorage.currentYear = SchoolYear(selectedYear);
  }

  Future<List<Course>> _updateTimetable() async {
    // final timetable =
    //     await TimetableInitializer.timetableService.getTimetable(SchoolYear(selectedYear), selectedSemester);
    //
    // await TimetableInitializer.timetableStorage.clear();
    // TimetableInitializer.timetableStorage.addAll(timetable);
    //
    // TimetableInitializer.timetableStorage.currentYear = SchoolYear(selectedYear);
    // TimetableInitializer.timetableStorage.currentSemester = selectedSemester;
    // TimetableInitializer.timetableStorage.startDate = selectedDate.value;
    //
    // TableCache.clear();

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('导入课表'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await showAlertDialog(
                context,
                title: '警告',
                content: [const Text('小风筝将清除您本学期课表数据')],
                actionWidgetList: [
                  ElevatedButton(onPressed: () {}, child: const Text('好')),
                  TextButton(onPressed: () {}, child: const Text('暂时不要')),
                ],
              ) ==
              0) {
            _updateTimetable();
            Navigator.of(context).pop(true);
          }
        },
        child: const Icon(Icons.check),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: _buildBody(),
      ),
    );
  }
}
